package com.tomez.main.audioplayer 
{
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.errors.EOFError;
	
	import gs.TweenLite;
	
	import br.com.stimuli.loading.BulkLoader;
	
	/**
	* ...
	* @author Tomez
	*/
	public class Skin extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		//scroll
		private var mouseScroll:Boolean = true;
		private var tempY:Number;
		private var targetY:Number;
		private var scrollDist:Number;
		private var dist:Number;
		private var ratio:Number;
		private var maxY:Number;
		private var mnull:Number;
		private var scnull:Number;
		private const maskHeight:Number = 169;
		
		
		private var img_bg:BitmapData = BulkLoader.getLoader("main-site").getBitmapData("audioplayer_bg.png");
		private var bg:Bitmap = new Bitmap(img_bg);
		
		private var holder:TSprite;
		
		private var format:TextFormat;
		private var tfnowplaying:TextField;
		private var tftitle:TextField;
		private var tftime:TextField;
		private var tfduration:TextField;
		
		private var closeCatch:TSprite;
		
		private var _stage:Stage;
		
		private var xml:XMLList;
		
		private var ap:AudioPlayer;
		
		private var line:TSprite;
		
		private var i:uint;
		private var num:Number;
		private var ba:ByteArray = new ByteArray();
		
		private var lastPlayed:int;
		
		private var _mask:TSprite;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Skin(stage:Stage, xml:XMLList, ap:AudioPlayer) 
		{
			this._stage = stage;
			this.xml = xml;
			this.ap = ap;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onCloseButtonClick(e:MouseEvent):void {
			
			getDefinitionByName("main").hideCloseRect();

			var ty:Number = Math.round(_stage.stageHeight + 100);
			
			TweenLite.to(ap, 0.5, {y:ty, autoAlpha:0 } );
		}
		
		private function onItemClick(e:ItemClick):void {
			tftitle.htmlText = e.info.@title;
			lastPlayed = e.target.id;
			
			if (AudioManager.getChannel()) {
				if (AudioManager.getChannel().hasEventListener(Event.SOUND_COMPLETE)) {
					AudioManager.getChannel().removeEventListener(Event.SOUND_COMPLETE, onSoundPlayCompleted);
				}
				if (lastPlayed > -1) {
					AudioManager.getChannel().addEventListener(Event.SOUND_COMPLETE, onSoundPlayCompleted);
				}
			}
			
		}
		
		private function onSoundPlayCompleted(e:Event):void {
			if (lastPlayed + 1 < xml.a.length()) {
				(holder.getChildAt(lastPlayed + 2) as Item).click();
			} else {
				// start first sound
				start();
			}
		}
		
		private function enterFrame(e:Event):void {
			if (AudioManager.getChannel()) {
				tftime.htmlText = timeConvert(AudioManager.getChannel().position / 1000);
				SoundMixer.computeSpectrum(ba);
				if (ap.alpha > 0) {
					drawSpectrum();
				}
			}
			if (AudioManager.getSound()) {
				tfduration.htmlText = timeConvert(AudioManager.getSound().length / 1000);
			}
			
			if (holder.height > maskHeight) {
				scroll();
			}
		}
		
		// Spectrum generator
		
		private function drawSpectrum():void {
			line.graphics.clear();
			line.graphics.lineStyle(1, 0x555555);
			
			for (i = 0; i < 256; i++) {
				
				try {
					num = ba.readFloat() * 20;
				} catch (e:EOFError) {
					num = 0;
				}
				
				line.graphics.lineTo(i/256*391, num);
			}
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			draw();
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			start();
		}
		
		private function draw():void {
			addChild(bg);
			
			line = new TSprite();
			
			line.x = 5;
			line.y = 31;
			addChild(line);
			
			drawText();
			
			holder = new TSprite();
			holder.x = 5;
			holder.y = 38;
			addChild(holder);
			
			drawItems();
			
			closeCatch = new TSprite();
			closeCatch.graphics.beginFill(0xffffff, 0);
			closeCatch.graphics.drawRect(0, 0, 40, 29);
			closeCatch.graphics.endFill();
			
			closeCatch.x = 358;
			closeCatch.y = 2;
			addChild(closeCatch);
			
			closeCatch.buttonMode = true;
			closeCatch.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
			
			_mask = new TSprite();
			_mask.graphics.beginFill(0xffffff);
			_mask.graphics.drawRect(0, 0, 396, maskHeight);
			_mask.graphics.endFill();
			
			_mask.x = 2;
			_mask.y = 38;
			addChild(_mask);
			
			holder.mask = _mask;
		}
		
		private function drawItems():void {
			var i:uint;
			var len:uint = xml.a.length();
			
			var ay:Number = 0;
			
			var nosound_xml:XML = <a title="NO SOUND" filename="no sound" />;
			
			var item:Item = new Item(nosound_xml);
			item.y = ay;
				
			ay += item.height - 2;
			holder.addChild(item);
			item.addEventListener("onItemClick", onItemClick);
			
			for (i = 0; i < len; i++) 
			{
				item = new Item(xml.a[i]);
				item.id = i;
				item.y = ay;
				
				ay += item.height - 2;
				holder.addChild(item);
				
				item.addEventListener("onItemClick", onItemClick);
			}
			
			mnull = holder.y;
			scnull = 27;
			targetY = holder.y;
			
			scrollDist = maskHeight - 27 * 2;
			dist = Math.round(holder.height - maskHeight);
			ratio = dist / scrollDist;
			maxY = -dist + mnull;
		}
		
		private function start():void {
			try {
				(holder.getChildAt(1) as Item).click();
			} catch (e:Error) {
				(holder.getChildAt(0) as Item).click();
			}
			
		}
		
		private function drawText():void {
			format = new TextFormat();
			format.font = "kroeger 05_55_8pt_st";
			format.size = 8;
			format.color = 0xcccccc;
			
			tfnowplaying = new TextField();
			tfnowplaying.selectable = false;
			tfnowplaying.defaultTextFormat = format;
			tfnowplaying.autoSize = "left";
			tfnowplaying.embedFonts = true;
			tfnowplaying.textColor = 0x575757;
			tfnowplaying.htmlText = "NOW PLAYING";
			tfnowplaying.x = 67;
			tfnowplaying.y = 8;
			
			tftitle = new TextField();
			tftitle.selectable = false;
			tftitle.defaultTextFormat = format;
			tftitle.autoSize = "left";
			tftitle.embedFonts = true;
			tftitle.htmlText = "";
			tftitle.x = 140;
			tftitle.y = 8;
			
			tftime = new TextField();
			tftime.selectable = false;
			tftime.defaultTextFormat = format;
			tftime.autoSize = "left";
			tftime.embedFonts = true;
			tftime.htmlText = "00:00";
			tftime.x = 280;
			tftime.y = 8;
			
			tfduration = new TextField();
			tfduration.selectable = false;
			tfduration.defaultTextFormat = format;
			tfduration.autoSize = "left";
			tfduration.embedFonts = true;
			tfduration.htmlText = "00:00";
			tfduration.x = 317;
			tfduration.y = 8;
			
			addChild(tfnowplaying);
			addChild(tftitle);
			addChild(tftime);
			addChild(tfduration);
		}
		
		private function scroll():void {
			if (mouseX >= 0 && mouseX <= width && _mask.mouseY >= 0 && _mask.mouseY <= (_mask.height)) {
				
				tempY = Math.round(mnull -(ratio * (_mask.mouseY - scnull) ) );
				targetY -= Math.round( (holder.y - tempY) / 4);
				if (targetY < maxY) {
					targetY = maxY;
				}
				if (targetY > mnull) {
					targetY = mnull;
				}
			
				holder.y = targetY
			} else {
				targetY -= Math.round( (holder.y - mnull - 2) / 4);
				holder.y = targetY
			}
		}
		
		public function reset():void {
			targetY = 0;
			holder.y = targetY;
		}
		
		private function timeConvert(num:Number):String {
			var tempNum:Number = num;
			var minutes:Number = Math.floor(tempNum / 60);
			var seconds:Number = Math.round(tempNum - (minutes * 60));
			
			return ( (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds) );
			
		}
		
	}
	
}