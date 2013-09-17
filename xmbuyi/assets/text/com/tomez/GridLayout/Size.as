package com.tomez.GridLayout
{
	
	/**
	* ...
	* @author Tomez
	*/
	public class Size 
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var referenceWidth:Number;
		private var percentWidth:Number;
		private var targetWidth:Number;
		
		private var referenceHeight:Number;
		private var percentHeight:Number;
		private var targetHeight:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Size(referenceWidth:Number, percentWidth:Number, referenceHeight:Number = NaN, percentHeight:Number = NaN) 
		{
			this.referenceWidth = referenceWidth;
			this.percentWidth = percentWidth;
			this.referenceHeight = referenceHeight;
			this.percentHeight = percentHeight;
			
			targetWidth = Math.round(referenceWidth * percentWidth / 100);
			targetHeight = Math.round(referenceHeight * percentHeight / 100);
		}
		
		// METHODS ________________________________________________________________________________________
		
		// WIDTH
		
		public function setWidth(referenceWidth:Number, percentWidth:Number):Number {
			this.referenceWidth = referenceWidth;
			this.percentWidth = percentWidth;
			targetWidth = Math.round(referenceWidth * percentWidth / 100);
			return targetWidth;
		}
		
		public function set pwidth(percentWidth:Number):* {
			return setWidth(this.referenceWidth, percentWidth);
		}
		
		public function get pwidth():Number {
			return percentWidth;
		}
		
		public function set rwidth(referenceWidth:Number):* {
			return setWidth(referenceWidth, this.percentWidth);
		}
		
		public function get rwidth():Number {
			return referenceWidth;
		}
		
		public function get width():Number {
			return targetWidth;
		}
		
		// HEIGHT
		
		public function setHeight(referenceHeight:Number, percentHeight:Number):Number {
			this.referenceHeight = referenceHeight;
			this.percentHeight = percentHeight;
			targetHeight = Math.round(referenceHeight * percentHeight / 100);
			return targetHeight;
		}
		
		public function set pheight(percentHeight:Number):* {
			return setHeight(this.referenceHeight, percentHeight);
		}
		
		public function get pheight():Number {
			return percentHeight;
		}
		
		public function set rheight(referenceHeight:Number):* {
			return setHeight(referenceHeight, this.percentHeight);
		}
		
		public function get rheight():Number {
			return referenceHeight;
		}
		
		public function get height():Number {
			return targetHeight;
		}
		
	}
	
}