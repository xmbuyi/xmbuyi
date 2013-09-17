package com.tomez 
{
	import flash.display.Sprite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class TSprite extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var _listeners:Array = new Array();
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function TSprite() 
		{
			
		}
		
		// METHODS ________________________________________________________________________________________
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_listeners.push({type:type, listener:listener});
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		// Deep removing works only when child added to rendering
		public function removeAllEventListeners(deep:Boolean = false):void {
			var i:uint = 0;
			var len:uint = listeners.length;
			
			for (i = 0; i < len; i++) {
				removeEventListener(listeners[i].type, listeners[i].listener);
			}
			
			if (deep && numChildren > 0) {
				for (i = 0; i < numChildren; i++) {
					if (getChildAt(i) is TSprite) {
						(getChildAt(i) as TSprite).removeAllEventListeners(true);
					}
				}
			}
			
			_listeners.length = 0;
			_listeners = [];
		}
		
		public function get listeners():Array {
			return _listeners;
		}
		
	}
	
}