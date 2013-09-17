package com.tomez.main
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import flash.system.Security;
	import flash.system.ApplicationDomain;
	
	import com.tomez.main.Background;
	import com.tomez.main.transition.Transition;
	
	import gs.TweenLite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class ContentHolder extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var holder:Sprite;
		
		private var loader:Loader;
		private var bgloader:Loader;
		
		private var nextContent:String;
		private var nextContentPath:String;
		private var nextContentHandleLoader:Boolean = true;
		private var nextContentBgPath:String;
		
		private var bg:Background;
		
		private var transitionManager:Transition;
		
		private var maskMc:Sprite;
		
		private var _stage:Object;
		
		private var alignMode:String = "TL";
		
		private var xmlinfo:XML;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function ContentHolder() 
		{
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onAllComplete():void {
			if (nextContentHandleLoader) {
				
			} else {
				main.hideLoader(transitionManager.startIn);
			}
			
			alignContent();
			
			if (nextContentPath.length > 0)  {
				trace(nextContentPath);
				(loader.content as Object).init(nextContentPath);
			}
		}
		
		private function onBgComplete(e:Event):void {
			
			removeBg();
			
			bg = new Background(bgloader.content, xmlinfo.bg.@isPattern);
			bg.mouseEnabled = false;
			holder.addChildAt(bg, 0);
			
			onAllComplete();
			
		}
		
		private function onComplete(e:Event):void {
			
			if (xmlinfo.hasOwnProperty("transition")) {
				transitionManager.setTransition(xmlinfo.transition);
			} else {
				transitionManager.setTransition("RotatingRectangle");
			}
			
			
			//load Bg if defined
			if (nextContentBgPath.length > 0) {
				loadBg();
			} else {
				
				removeBg();
				
				onAllComplete();
			}
			
		}
		
		private function onProgress(e:ProgressEvent):void {
			
		}
		
		private function onIOError(e:IOErrorEvent):void {
			trace(e);
		}
		
		private function onStageResize(e:Event):void {
			transitionManager.drawMask();
		}
		
		private function onResize(e:Event):void {
			centralizeContent();
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			_stage = main.getStage();
			
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			holder = new Sprite();
			addChild(holder);
			
			maskMc = new Sprite();
			drawMask();
			
			addChild(maskMc);
			holder.mask = maskMc;
			
			transitionManager = new Transition(maskMc);
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			bgloader = new Loader();
			bgloader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBgComplete);
			
			holder.addChild(loader);
			
			_stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		private function load():void {
			if (loader.content) {
				
				try {
					(loader.content as Object).destroy();
					loader.close();
					loader = null;
					loader = new Loader();
				} catch (e:Error) {
					
				}
			}
			loader.load(new URLRequest(nextContent));
			
			//loaderAnim
			main.showLoader();
		}
		
		public function loadContent(fn:String):void {
			_stage.removeEventListener(Event.RESIZE, onResize);
			
			nextContent = fn;
			if (loader.content) {
				transitionManager.startOut(load);
			} else {
				load();
			}
		}
		
		public function loadContentByXml(x:XML):void {
			
			xmlinfo = x;
			
			if (x.hasOwnProperty("align")) {
				alignMode = x.align;
			} else {
				alignMode = "TL";
			}
			
			if (x.hasOwnProperty("content_handle_loader")) {
				if (x.content_handle_loader == "true") {
					nextContentHandleLoader = true;
				} else {
					nextContentHandleLoader = false;
					main.hideLoader();
				}
			} else {
				nextContentHandleLoader = false;
				main.hideLoader();
			}
			
			if (x.hasOwnProperty("bg")) {
				if (x.bg.toString().length > 0) {
					nextContentBgPath = x.bg.toString();
				} else {
					nextContentBgPath = "";
				}
			} else {
				nextContentBgPath = "";
			}
			
			if (x.hasOwnProperty("content")) {
				if (x.hasOwnProperty("content_path")) {
					nextContentPath = x.content_path;
				} else {
					nextContentPath = "";
				}
				loadContent(x.content);
			}
		}
		
		private function loadBg():void {
			bgloader.load(new URLRequest(xmlinfo.bg));
		}
		
		private function removeBg():void {
			if (bg) {
				holder.removeChild(bg);
				bg.removeListener();
				bg.removeAllEventListeners(true);
				
				bg = null;
			}
		}
		
		private function alignContent():void {
			if (alignMode.toLowerCase() == "tl") {
				loader.x = 0;
				loader.y = 0;
			} else if (alignMode.toLowerCase() == "center") {
				centralizeContent();
				_stage.addEventListener(Event.RESIZE, onResize);
			}
		}
		
		private function centralizeContent():void {
			loader.x = Math.round(_stage.stageWidth / 2 - loader.width / 2);
			loader.y = Math.round(main.stageRect.height / 2 - loader.height / 2);
		}
		
		private function drawMask():void {
			maskMc.graphics.clear();
			maskMc.graphics.beginFill(0x000000);
			maskMc.graphics.drawRect(-_stage.stageWidth/2, -_stage.stageHeight/2, _stage.stageWidth, _stage.stageHeight);
			maskMc.graphics.endFill();
			maskMc.x = _stage.stageWidth / 2;
			maskMc.y = _stage.stageHeight / 2;
		}
		
		public function startTransition():void {
			transitionManager.startIn();
		}
		
		public function showContent():void {
			transitionManager.showContent();
		}
		
	}
	
}