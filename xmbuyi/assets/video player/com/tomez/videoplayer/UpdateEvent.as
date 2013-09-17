package com.tomez.videoplayer 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author Tomez
	*/
	public class UpdateEvent extends Event 
	{
		public var info:Object;
		
		public function UpdateEvent(type:String, info:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.info = info;
			super(type, bubbles, cancelable);
			
		}
		
	}
	
}