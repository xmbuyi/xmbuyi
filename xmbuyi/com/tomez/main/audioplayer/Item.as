package com.tomez.main.audioplayer 
{
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	
	import com.tomez.main.audioplayer.AudioManager;
	
	import gs.TweenLite;
	
	import br.com.stimuli.loading.BulkLoader;
	
	/**
	* ...
	* @author Tomez
	*/
	public class Item extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var img_itembg:BitmapData = BulkLoader.getLoader("main-site").getBitmapData("audioplayer_itembg.png");
		private var itembg:Bitmap = new Bitmap(img_itembg);
		
		private var img_itembg_over:BitmapData = BulkLoader.getLoader("main-site").getBitmapData("audioplayer_itembg_over.png");
		private var itembg_over:Bitmap = new Bitmap(img_itembg_over);
		
		private var format:TextFormat;
		private var tftitle:TextField;
		private var tfduration:TextField;
		
		public var id:int = -1;
		
		private var xml:XML;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Item(xml:XML) 
		{
			this.xml = xml;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function mouseOver(e:Event):void {
			TweenLite.to(itembg_over, 0.1, { alpha:1 } );
		}
		
		private function mouseOut(e:Event):void {
			TweenLite.to(itembg_over, 0.1, { alpha:0 } );
		}
		
		// called by AudioManager
		private function onProgress(e:ProgressEvent):void {
			tfduration.htmlText = "STREAMING";
			tfduration.x = 342;
		}
		
		private function onComplete(e:Event):void {
			tfduration.htmlText = timeConvert(e.target.length / 1000);
			tfduration.x = 356;
		}
		
		private function onPress(e:Event):void {
			click();
		}
		
		public function click():void {
			AudioManager.play(xml.@filename, onProgress, onComplete);
			dispatchEvent(new ItemClick("onItemClick", xml, true));
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			draw();
			
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(MouseEvent.CLICK, onPress);
		}
		
		private function draw():void {
			itembg_over.alpha = 0;
			addChild(itembg);
			addChild(itembg_over);
			
			drawText();
		}
		
		private function drawText():void {
			format = new TextFormat();
			format.font = "kroeger 05_55_8pt_st";
			format.size = 8;
			format.color = 0xcccccc;
			
			tftitle = new TextField();
			tftitle.selectable = false;
			tftitle.defaultTextFormat = format;
			tftitle.autoSize = "left";
			tftitle.embedFonts = true;
			tftitle.htmlText = xml.@title;
			tftitle.x = 62;
			tftitle.y = 5;
			
			tfduration = new TextField();
			tfduration.selectable = false;
			tfduration.defaultTextFormat = format;
			tfduration.autoSize = "left";
			tfduration.embedFonts = true;
			tfduration.htmlText = "--:--";
			tfduration.x = 356;
			tfduration.y = 5;
			
			addChild(tftitle);
			addChild(tfduration);
		}
		
		private function timeConvert(num:Number):String {
			var tempNum:Number = num;
			var minutes:Number = Math.floor(tempNum / 60);
			var seconds:Number = Math.round(tempNum - (minutes * 60));
			
			return ( (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds) );
			
		}
		
	}
	
}