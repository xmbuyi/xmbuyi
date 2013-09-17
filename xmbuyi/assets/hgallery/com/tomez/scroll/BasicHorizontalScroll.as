package com.tomez.scroll 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class BasicHorizontalScroll 
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var tempX:Number;
		private var targetX:Number;
		private var scrollDist:Number;
		private var dist:Number;
		private var ratio:Number;
		private var maxX:Number;
		private var mnull:Number;
		private var scnull:Number;
		
		private var smoothScrolling:Boolean = true;
		
		private var _mask:Sprite;
		private var maskWidth:Number;
		
		private var _content:*;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function BasicHorizontalScroll(content:*, maskWidth:Number, scrollDist:Number) 
		{
			this._content = content;
			this.maskWidth = maskWidth;
			this.scrollDist = scrollDist;
			
			init();
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			mnull = _content.x;
			scnull = 0;
			targetX = 0;
			
			scrollDist = maskWidth;
			dist = Math.round(_content.width - maskWidth);
			ratio = dist / scrollDist;
			maxX = -dist + mnull;
		}
		
		public function refresh(maskWidth:Number, scrollDist:Number):void { 
			this.maskWidth = maskWidth;
			
			this.scrollDist = scrollDist;
			dist = Math.round(_content.width - maskWidth);
			ratio = dist / scrollDist;
			maxX = -dist + mnull;
		}
		
		public function scroll(drag:DisplayObject):void {
			tempX = Math.round(mnull - (ratio * (drag.x - scnull) ) );
			if (smoothScrolling) {
				targetX -= Math.round( (_content.x - tempX) / 4);
			} else {
				targetX = Math.round( tempX );
			}
			if (targetX != _content.x) {
				_content.x = targetX;
			}
		}
		
		public function set content(value:*):void {
			_content = value;
		}
		
		public function get content():* {
			return _content;
		}
		
	}
	
}