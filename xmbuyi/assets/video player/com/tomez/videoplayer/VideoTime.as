package com.tomez.videoplayer 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	* ...
	* @author Tomez
	*/
	public class VideoTime extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var bg:Sprite;
		
		private var format:TextFormat;
		
		private var playTime:TextField;
		private var totalTime:TextField;
		
		private var targetWidth:Number
		private var targetHeight:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function VideoTime(width:Number, height:Number) 
		{
			this.targetWidth = width;
			this.targetHeight = height;
			
			init();
		}
		
		// METHODS ________________________________________________________________________________________
		
		public function setPlayTime(str:String):void {
			playTime.htmlText = str;
		}
		
		public function setTotalTime(str:String):void {
			totalTime.htmlText = str;
		}
		
		private function init():void {
			
			drawBg();
			
			format = new TextFormat();
			format.font = "Arial";
			format.size = 10;
			
			playTime = new TextField();
			playTime.autoSize = "left";
			playTime.selectable = false;
			playTime.defaultTextFormat = format;
			playTime.htmlText = "00:00";
			playTime.textColor = 0x575757;
			playTime.x = 7;
			playTime.y = -1;
			
			totalTime = new TextField();
			totalTime.autoSize = "left";
			totalTime.selectable = false;
			totalTime.defaultTextFormat = format;
			totalTime.htmlText = "00:00";
			totalTime.textColor = 0xa2a6b0;
			totalTime.x = 48;
			totalTime.y = -1;
			
			var sep:Bitmap = new Bitmap(new img_time_sep(0, 0));
			sep.x = 41;
			sep.y = 4;
			
			addChild(playTime);
			addChild(sep);
			addChild(totalTime);
		}
		
		private function drawBg():void {
			bg = new Sprite();
			bg.graphics.beginFill(0x141414, 0.5);
			bg.graphics.drawRoundRect(0, 0, 85, 15, 10);
			bg.graphics.endFill();
			
			addChild(bg);
		}
		
	}
	
}