package com.tomez.imagegallery 
{
	import com.tomez.TSprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	/**
	* ...
	* @author Tomez
	*/
	public class BasicThumbnail extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var loader:Loader;
		
		private var src:String;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function BasicThumbnail() 
		{
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onProgress(e:ProgressEvent):void {
			var per:Number = Math.round(e.bytesLoaded / e.bytesTotal * 100);
		}
		
		private function onComplete(e:Event):void {
			addChild(loader);
			dispatchEvent(new Event(Event.COMPLETE, true));
		}
		
		private function onIOError(e:IOErrorEvent):void {
			trace(e.text);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);

		}
		
		public function load(url:String):void {
			loader.load(new URLRequest(url));
		}
		
		public function set source(src:String):void {
			this.src = src;
		}
		
		public function get source():String {
			return this.src;
		}
		
	}
	
}