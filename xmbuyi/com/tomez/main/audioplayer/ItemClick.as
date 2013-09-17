package com.tomez.main.audioplayer 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author Tomez
	*/
	public class ItemClick extends Event 
	{
		public var info:XML;
		
		public function ItemClick(type:String, info:XML, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.info = info;
			super(type, bubbles, cancelable);
			
		} 
		
	}
	
}