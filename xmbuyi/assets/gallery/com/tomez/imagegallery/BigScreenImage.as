package com.tomez.imagegallery 
{
	import com.tomez.TSprite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class BigScreenImage extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		public var image:BasicThumbnail;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function BigScreenImage() 
		{
			init();
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			image = new BasicThumbnail();
			addChild(image);
		}
		
	}
	
}