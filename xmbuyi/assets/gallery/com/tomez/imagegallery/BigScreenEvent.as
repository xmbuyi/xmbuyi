package com.tomez.imagegallery 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author Tomez
	*/
	public class BigScreenEvent extends Event 
	{
		public var info:Object;
		
		public function BigScreenEvent(type:String, info:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.info = info;
			super(type, bubbles, cancelable);
			
		}
		
	}
	
}