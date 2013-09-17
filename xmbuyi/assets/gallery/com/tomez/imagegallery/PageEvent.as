package com.tomez.imagegallery 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author Tomez
	*/
	public class PageEvent extends Event 
	{
		public var page:uint;
		
		public function PageEvent(type:String, page:uint, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			this.page = page;
			super(type, bubbles, cancelable);
			
		} 

	}
	
}