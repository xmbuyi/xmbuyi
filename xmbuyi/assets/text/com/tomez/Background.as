package com.tomez 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	* ...
	* @author Tomez
	*/
	public class Background extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var source:String;
		private var isPattern:Boolean;
		
		private var loader:Loader;
		private var bmp:BitmapData;
		private var bitmap:Bitmap;
		private var bg:TSprite;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Background(src:String, isPattern:Boolean = false) 
		{
			this.source = text.getContentPath() + "/" + src;
			this.isPattern = isPattern;
			
			addListener();
			
			bg = new TSprite();
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(new URLRequest(source));
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function addListener():void {
			text.getStage().addEventListener(Event.RESIZE, resize);
		}
		
		private function removeListener():void {
			text.getStage().removeEventListener(Event.RESIZE, resize);
		}
		
		private function resize(e:Event):void {
			if (isPattern) {
				redrawPatternBg();
			}
		}
		
		private function onComplete(e:Event):void {
			bmp = loader.content["bitmapData"] as BitmapData;
			bitmap = new Bitmap(bmp);
			
			if (isPattern) {
				drawPatternBg();
			} else {
				drawBg();
			}
			
			trace("bg loading completed.");
		}
		
		private function onIOError(e:IOErrorEvent):void {
			trace(source, e.text);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function redrawPatternBg():void {
			var iwidth:Number = text.getStage().stageWidth;
			var iheight:Number = text.getStage().stageHeight;
			
			bg.graphics.clear();
			bg.graphics.beginBitmapFill(bmp, null, true, true);
			bg.graphics.drawRect(0, 0, iwidth, iheight);
			bg.graphics.endFill();
		}
		
		private function drawBg():void {
			bg.addChild(bitmap);
			addChild(bg);
		}
		
		private function drawPatternBg():void {
			redrawPatternBg();
			
			bg.addChild(bitmap);
			addChild(bg);
		}
		
	}
	
}