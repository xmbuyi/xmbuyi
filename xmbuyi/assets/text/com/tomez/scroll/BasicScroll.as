package com.tomez.scroll 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class BasicScroll 
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var tempY:Number;
		private var targetY:Number;
		private var scrollDist:Number;
		private var dist:Number;
		private var ratio:Number;
		private var maxY:Number;
		private var mnull:Number;
		private var scnull:Number;
		
		private var smoothScrolling:Boolean = true;
		
		private var _mask:Sprite;
		private var maskHeight:Number;
		
		private var _content:*;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function BasicScroll(content:*, maskHeight:Number, scrollDist:Number) 
		{
			this._content = content;
			this.maskHeight = maskHeight;
			this.scrollDist = scrollDist;
			
			init();
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			mnull = _content.y;
			scnull = 0;
			targetY = 0;
			
			scrollDist = maskHeight;
			dist = Math.round(_content.height - maskHeight);
			ratio = dist / scrollDist;
			maxY = -dist + mnull;
		}
		
		public function refresh(maskHeight:Number, scrollDist:Number):void { 
			this.maskHeight = maskHeight;
			
			this.scrollDist = scrollDist;
			dist = Math.round(_content.height - maskHeight);
			ratio = dist / scrollDist;
			maxY = -dist + mnull;
		}
		
		public function scroll(drag:DisplayObject):void {
			tempY = Math.round(mnull - (ratio * (drag.y - scnull) ) );
			if (smoothScrolling) {
				targetY -= Math.round( (_content.y - tempY) / 4);
			} else {
				targetY = Math.round( tempY );
			}
			
			if(targetY != _content.y) {
				_content.y = targetY
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