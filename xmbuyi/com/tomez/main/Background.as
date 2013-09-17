package com.tomez.main 
{
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	* ...
	* @author Tomez
	*/
	public class Background extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var source:DisplayObject;
		private var isPattern:Boolean;
		
		private var bmp:BitmapData;
		private var bitmap:Bitmap;
		private var bg:TSprite;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Background(src:DisplayObject, isPattern:Boolean = false) 
		{
			this.source = src;
			this.isPattern = isPattern;
			
			addListener();
			
			bg = new TSprite();
			
			draw();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function addListener():void {
			main.getStage().addEventListener(Event.RESIZE, resize);
		}
		
		public function removeListener():void {
			main.getStage().removeEventListener(Event.RESIZE, resize);
		}
		
		private function resize(e:Event):void {
			if (isPattern) {
				redrawPatternBg();
			}
		}
		
		private function draw():void {
			
			if (isPattern) {
				bmp = new BitmapData(source.width, source.height);
				bmp.draw(source);
				bitmap = new Bitmap(bmp);
				drawPatternBg();
			} else {
				drawBg();
			}
			
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function redrawPatternBg():void {
			var iwidth:Number = main.getStage().stageWidth;
			var iheight:Number = main.getStage().stageHeight;
			
			bg.graphics.clear();
			bg.graphics.beginBitmapFill(bmp, null, true, true);
			bg.graphics.drawRect(0, 0, iwidth, iheight);
			bg.graphics.endFill();
		}
		
		private function drawBg():void {
			bg.addChild(source);
			addChild(bg);
		}
		
		private function drawPatternBg():void {
			redrawPatternBg();
			
			bg.addChild(bitmap);
			addChild(bg);
		}
		
	}
	
}