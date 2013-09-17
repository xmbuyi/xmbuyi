package com.tomez.GridLayout
{
	
	/**
	* ...
	* @author Tomez
	*/
	public class WidthCalc
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var sizes:Array;
		
		private var rwidth:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function WidthCalc(referenceWidth:Number) 
		{
			this.rwidth = referenceWidth;
			
			sizes = new Array();
		}
		
		// METHODS ________________________________________________________________________________________
		
		public function setReferenceWidth(width:Number):void {
			rwidth = width;
		}
		
		public function getReferenceWidth():Number {
			return rwidth;
		}
		
		public function addSize(width:Number):void {
			if (width <= rwidth) {
				sizes.push(width);
			} else if(width > rwidth) { // not NaN
				sizes.push(rwidth);
				//trace("width maximized");
			} else { // NaN
				sizes.push(width);
			}
		}
		
		public function calculate():void {
			var i:uint;
			var len:uint = sizes.length;
			var rlen:uint = sizes.length;
			
			for (i = 0; i < len; i++) {
				if (!isNaN(sizes[i])) {
					rwidth -= sizes[i];
					rlen--;
				} 
			}
			
			rwidth = rwidth < 0 ? 0 : rwidth;
			
			for (i = 0; i < len; i++) {
				if (isNaN(sizes[i])) {
					sizes[i] = Math.round(rwidth/rlen);
				}
			}
			
		}
		
		public function getSize(where:Number):Number {
			if (sizes.length > 0) {
				return sizes[where];
			}
			return rwidth;
		}
		
		public function get width():Number {
			var i:uint;
			var len:uint = sizes.length;
			var sum:Number = 0;
			
			for (i = 0; i < len; i++) 
			{
				sum += sizes[i];
			}
			return sum;
		}
		
	}
	
}