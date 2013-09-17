package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	
	import com.tomez.StageSetup;
	import com.tomez.main.ContentHolder;
	
	import com.tomez.main.audioplayer.AudioPlayer;
	import com.tomez.main.controlbuttons.ControlButtons;
	
	import com.tomez.SWFAddress;
	import com.tomez.SWFAddressEvent;
	
	import com.tomez.main.RightClickMenu;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkErrorEvent;
	
	import gs.TweenLite;
	import gs.easing.*;
	
	/**
	* ...
	* @author Tomez
	*/
	public class main extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private static var stageref:Stage;
		
		private var rightClickMenu:RightClickMenu;
		
		private var loader:BulkLoader;
		
		private var menu:*;
		
		private static var content:ContentHolder;
		
		private var bg:Sprite;
		
		private var xml:XML;
		
		private static var controlButtons:ControlButtons;
		
		private var audioPlayer:AudioPlayer;
		
		private static var closeRect:Sprite;
		
		private static var loaderAnim:*;
		
		private var sitelogo:*;
		
		private var menuHeight:Number;
		public static var stageRect:Rectangle;
		
		// for SWFAddress
		private var siteTitle:String = "";
		
		//Google Analytics
		private var isAnalyticsEnabled:Boolean = false;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function main() 
		{
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		public static function onVideoPlaying():void {
			controlButtons.vc.volumeOff();
		}
		
		private function onXMLComplete(e:Event):void {
			trace("xml: loaded.");
			
			xml = new XML(loader.getContent("xmldoc") as XML);
			
			initBgColor();
			
			rightClickMenu = new RightClickMenu(content);
			
			loader.removeEventListener(BulkLoader.COMPLETE, onXMLComplete);
			loader.addEventListener(BulkLoader.COMPLETE, onComplete);
			loadAssets();
			
			initSWFAddress();
		}
		
		private function onComplete(e:Event):void {
			trace("loaded all");
			
			menu = loader.getContent("menu");
			
			stageRect.y = menu.getHeight() + sitelogo.height;
			stageRect.height = stageref.stageHeight - stageRect.y;
			stageRect.width = stageref.stageWidth;
			
			loadStartContent();
		}
		
		private function onError(evt:BulkErrorEvent):void {
			trace("an error ocurred when loading");
			for each (var loadingItem:* in evt.errors) {
				trace(loadingItem, "has failed to load");
			}
		}
		
		private function onLoaderAnimLoaded(e:Event):void {
			trace("loaderAnim loader");
			
			loader.removeEventListener(BulkLoader.COMPLETE, onLoaderAnimLoaded);
			loader.addEventListener(BulkLoader.COMPLETE, onXMLComplete);
			
			loadXml();
			
			sitelogo = loader.getContent("logo");
			
			loaderAnim = loader.getContent("loader");
			loaderAnim.x = stage.stageWidth / 2 - 140;
			loaderAnim.y = stage.stageHeight / 2 - 115 + sitelogo.height / 2;
			loaderAnim.alpha = 0;
			addChild(loaderAnim);
			
			TweenLite.to(loaderAnim, 0.5, { alpha: 1, delay:0.1 } );
		}
		
		private function onResize(e:Event):void {
			bg.graphics.clear();
			bg.graphics.beginFill(Number(xml.background.color.toString()));
			bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			bg.graphics.endFill();
			
			stageRect.height = stageref.stageHeight - stageRect.y;
			stageRect.width = stageref.stageWidth;
			
			closeRect.graphics.clear();
			closeRect.graphics.beginFill(0x111111);
			closeRect.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			closeRect.graphics.endFill();
			
			audioPlayer.x = Math.round(stage.stageWidth / 2 - audioPlayer.width / 2);
			audioPlayer.y = Math.round(stage.stageHeight / 2 - audioPlayer.height / 2);
			
			sitelogo.x = 5;
			
			controlButtons.x = Math.round(stage.stageWidth - controlButtons.width);
			
			loaderAnim.x = stage.stageWidth / 2 - 140;
			loaderAnim.y = stage.stageHeight / 2 - 115 + sitelogo.height / 2;
		}
		
		private function fullScreenEventHandler(e:FullScreenEvent):void {
			onResize(null);
			controlButtons.fullScreenEventHandler(e);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			
			stageRect = new Rectangle();
			
			stageref = stage;
			var stageSetup:StageSetup = new StageSetup(stage);
			
			stageref.addEventListener(Event.RESIZE, onResize);
			stageref.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenEventHandler);
			
			content = new ContentHolder();
			addChild(content);
			
			closeRect = new Sprite();
			closeRect.graphics.beginFill(0x111111);
			closeRect.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			closeRect.graphics.endFill();
			
			closeRect.alpha = 0;
			closeRect.mouseEnabled = false;
			addChild(closeRect);
			
			loader = new BulkLoader("main-site");
			loader.addEventListener(BulkLoader.COMPLETE, onLoaderAnimLoaded);
			loader.addEventListener(BulkLoader.ERROR, onError);
			
			loadLogo_and_LoaderAnim();
		}
		
		private function initAudioPlayer():void {
			audioPlayer = new AudioPlayer(stage, xml.audio);
			
			audioPlayer.x = Math.round(stage.stageWidth / 2 - audioPlayer.width / 2);
			audioPlayer.y = Math.round(stage.stageHeight / 2 - audioPlayer.height / 2);
			
			audioPlayer.visible = false;
			audioPlayer.alpha = 0;
			addChild(audioPlayer);
		}
		
		private function initControlButtons():void {
			controlButtons = new ControlButtons(stage, audioPlayer);
			
			controlButtons.x = Math.round(stage.stageWidth - controlButtons.width);
			addChild(controlButtons);
		}
		
		private function initBgColor():void {
			bg = new Sprite();
			bg.graphics.beginFill(Number(xml.background.color.toString()));
			bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			bg.graphics.endFill();
			
			addChildAt(bg, 0);
		}
		
		private function loadStartContent():void {
			
			// Menu init
			menu.alpha = 0;
			addChild(menu);
			TweenLite.to(menu, 0.5, {alpha:1, ease:Linear.easeOut });
			
			menu.init(xml.menu);
			menu.y = sitelogo.height;

			sitelogo.x = 5;
			addChild(sitelogo);
			
			content.y = stageRect.y;
			
			//audio player init first!
			initAudioPlayer();
			initControlButtons();
			
			TweenLite.delayedCall(0.7, SWFAddress.addEventListener, [SWFAddressEvent.CHANGE, handleSWFAddress]);
			
		}
		
		private function loadLogo_and_LoaderAnim():void {
			loader.add("assets/logo.png", { id:"logo" } );
			loader.add("assets/loader.swf", { id:"loader" } );
			loader.start();
		}
		
		private function loadXml():void {
			loader.add("assets/site.xml", { id:"xmldoc" } );
			loader.start();
		}
		
		private function loadAssets():void {
			loader.add("assets/font.swf");
			loader.add("assets/menu/menu.swf", { id:"menu" } );
			//audioplayer
			loader.add("assets/audioplayer/itembg.png", { id:"audioplayer_itembg.png" } );
			loader.add("assets/audioplayer/itembg_over.png", { id:"audioplayer_itembg_over.png" } );
			loader.add("assets/audioplayer/bg.png", { id:"audioplayer_bg.png" } );
			loader.start();
		}
		
		private function initSWFAddress():void {
			siteTitle = xml.title;
			
			isAnalyticsEnabled = xml.analytics.@enabled == "true";
			trace("Google Analytics enabled: ", isAnalyticsEnabled);
			
			initDeepLink();
		}
		
		private function formatTitle(title:String):String {
			return siteTitle + (title != '/' ? ' / ' + (title.substr(1, title.length - 2).replace( '/', ' / ')) : '');
		}
		
		private function handleSWFAddress(e:SWFAddressEvent):void {
			try {
				SWFAddress.setTitle(formatTitle(e.value));
				var xmlinfo:Object = getContentInfoXML(e.value);
				trace("content: ", e.value);
				
				// Google Analytics tracking
				if(isAnalyticsEnabled) {
					if (ExternalInterface.available) { ExternalInterface.call("pageTracker._trackPageview", e.value); }
				}
				
				if (e.value != "/") {
					if (xmlinfo.index != -1) {
						content.loadContentByXml(xmlinfo.xml);
						menu.setSelectedItem(xmlinfo.index, xmlinfo.subitem_index);
					} else {
						
					}
				} else {
					xmlinfo = getContentInfoXML("/" + xml.menu.@startContent + "/");
					content.loadContentByXml(xmlinfo.xml);
					menu.setSelectedItem(xmlinfo.index, xmlinfo.subitem_index);
				}
				
			} catch (e:Error) {
				
			}
		}
		
		private function getContentInfoXML(str:String):Object {
			var ret:Object = new Object();
			ret.index = -1;
			var item:XML;
			
			for each(item in xml.menu.m) {
				if (item.deepLink.toString() == str) {
					ret.xml = item;
					ret.index = item.childIndex();
					ret.subitem_index = -1;
				}
			}
			
			//search in subitems
			if (ret.index < 0) {
				for each(item in xml.menu.m) {
					if (item.hasOwnProperty("submenu")) {
						for each(var subitem:XML in item.submenu.m) {
							if (subitem.deepLink.toString() == str) {
								ret.xml = subitem;
								ret.index = item.childIndex();
								ret.subitem_index = subitem.childIndex();
							}
						}
					}
				}
			}
			
			return ret;
		}
		
		private function initDeepLink():void {
			var item:XML;
			for each(item in xml.menu.m) {
				if (item.deepLink.toString().length > 0) {
					item.deepLink = "/" + item.deepLink + "/";
				} else {
					item.deepLink = "/" + (item.childIndex() + 1) + "/";
				}
				//trace(item.deepLink);
				
				//child nodes deepLink
				if (item.hasOwnProperty("submenu")) {
					for each(var subitem:XML in item.submenu.m) {
						if (subitem.deepLink.toString().length > 0) {
							subitem.deepLink = item.deepLink.toString() + subitem.deepLink + "/";
						} else {
							subitem.deepLink = item.deepLink.toString() + (subitem.childIndex() + 1) + "/";
						}
						//trace(subitem.deepLink);
					}
				}
				
			}
		}
		
		public static function showCloseRect():void {
			closeRect.mouseEnabled = true;
			TweenLite.to(closeRect, 0.2, { alpha:0.9 } );
		}
		
		public static function hideCloseRect():void {
			closeRect.mouseEnabled = false;
			TweenLite.to(closeRect, 0.2, { alpha:0 } );
		}
		
		public static function showLoader(color:* = null):void {
			TweenLite.to(loaderAnim, 0.5, { alpha: 1, tint:color, overwrite:false } );
		}
		
		public static function hideLoader(func:Function = null, color:* = null):void {
			TweenLite.to(loaderAnim, 0.5, { alpha: 0, delay:0.5, tint:color, overwrite:false, onComplete:func } );
		}
		
		public static function getStage():Stage {
			return stageref;
		}
		
		public static function getContent():ContentHolder {
			return content;
		}
		
		public static function getSWFAddress():* {
			return SWFAddress;
		}
	}
	
}