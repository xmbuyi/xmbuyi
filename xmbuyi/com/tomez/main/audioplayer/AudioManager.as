package com.tomez.main.audioplayer 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	/**
	* ...
	* @author Tomez
	*/
	public class AudioManager 
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private static var snd:Sound;
		private static var channel:SoundChannel;
		
		private static var pFunc:Function;
		private static var cFunc:Function;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function AudioManager() 
		{
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private static function onProgress(e:ProgressEvent):void {
			if (pFunc != null) {
				pFunc(e);
			}
		}
		
		private static function onComplete(e:Event):void {
			if (cFunc != null) {
				cFunc(e);
			}
		}
		
		private static function onIoError(e:IOErrorEvent):void {
			
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			snd = new Sound();
			
			
		}
		
		public static function play(url:String, progressFunc:Function = null, completeFunc:Function = null):void {
			if (progressFunc != null) {
				pFunc = progressFunc;
			}
			if (completeFunc != null) {
				cFunc = completeFunc;
			}
			
			if (channel) {
				channel.stop();
			}
			if (url.toLowerCase() != "no sound") {
				snd = new Sound(new URLRequest(url));
				channel = snd.play();
			}
			
			if (channel) {
				if (!snd.hasEventListener(ProgressEvent.PROGRESS)) {
					snd.addEventListener(ProgressEvent.PROGRESS, onProgress);
				}
				if (!snd.hasEventListener(Event.COMPLETE)) {
					snd.addEventListener(Event.COMPLETE, onComplete);
				}
			}			
		}
		
		public static function getSound():Sound {
			return snd;
		}
		
		public static function getChannel():SoundChannel {
			return channel;
		}
		
	}
	
}