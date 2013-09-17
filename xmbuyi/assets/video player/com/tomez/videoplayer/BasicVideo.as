package com.tomez.videoplayer 
{
	import com.tomez.TSprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	* ...
	* @author Tomez
	*/
	public class BasicVideo extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var videoURL:String;
		
		private var connection:NetConnection;
		private var stream:NetStream;
		
		private var video:Video;
		
		private var netClient:Object;
		
		private var st:SoundTransform;
		
		private var duration:uint;
		private var playTime:Number;
		private var amountLoaded:Number = 0;
		private var amountPlayed:Number = 0;
		private var info:Object = new Object();
		private var lastSeek:Number;
		
		private var metaWidth:uint;
		private var metaHeight:uint;
		private var metaFramerate:Number;
		
		private const traceInfo:Boolean = false;
		
		private var paused:Boolean = false;
		private var keepPaused:Boolean = false;
		private var seeking:Boolean = false;
		
		private const defaultVolume:Number = 0.6;
		
		private var targetWidth:Number;
		private var targetHeight:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________		
		
		public function BasicVideo(width:Number, height:Number) 
		{
			this.targetWidth = width;
			this.targetHeight = height;
			
			init();
			setVolume(defaultVolume);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			connection = new NetConnection();
			connection.connect(null);
			
			st = new SoundTransform();
			
			stream = new NetStream(connection);
			stream.soundTransform = st;
			
			video = new Video(targetWidth, targetHeight);
			video.width = targetWidth;
			video.height = targetHeight;
			addChild(video);
			
			video.attachNetStream(stream);
			video.smoothing = true;
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			netClient = new Object();
			netClient.onMetaData = onMetaData;
			
			stream.client = netClient;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onEnterFrame(e:Event):void {
			var secs:Number = Math.floor(stream.time);
			var totalSecs:Number = Math.round(duration);
			
			if (secs > 0) {
				amountPlayed = stream.time / duration;
				amountLoaded = stream.bytesLoaded / stream.bytesTotal;
			} else {
				amountPlayed = 0;
				amountLoaded = stream.bytesLoaded / stream.bytesTotal;
			}
			
			info.secs = videoTimeConvert(secs);
			info.totalSecs = videoTimeConvert(totalSecs);
			info.amountPlayed = amountPlayed;
			info.amountLoaded = amountLoaded;
			
			dispatchEvent(new UpdateEvent("onUpdate", info, true));
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler:" + event);
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
                case "NetStream.Play.StreamNotFound":
                    trace("Stream not found: " + videoURL);
                    break;
            }
		}
		
		private function onMetaData(info:Object):void {
			duration = info.duration;
			metaWidth = info.width;
			metaHeight = info.height;
			metaFramerate = info.framerate;
			
			// just for debug only
			if (traceInfo) {
				trace("duration:", duration);
				trace("width:", metaWidth);
				trace("height:", metaHeight);
				trace("framerate:", metaFramerate);
			}			
		}
		
		// PUBLIC METHODS _________________________________________________________________________________
		
		public function playVideo(url:String):void {
			videoURL = url;
			play(videoURL);
		}
		
		public function togglePause(e:Event):void {
			pause();
		}
		
		public function stopVideo(e:Event):void {
			stop();
		}
		
		public function seekVideo(e:UpdateEvent):void {
			if (lastSeek != e.info.seek * duration) {
				if (!seeking) {
					if (!paused) {
						stream.pause();
						keepPaused = false;
					} else {
						keepPaused = true;
					}
					seeking = true;
				}
				lastSeek = e.info.seek * duration;
				if (lastSeek > duration) lastSeek = duration;
				seek(lastSeek);
			}
		}
		
		public function seekFinished(e:Event):void {
			if (!keepPaused) {
				stream.resume();
			}
			seeking = false;
		}
		
		public function setVideoVolume(e:UpdateEvent):void {
			setVolume(Math.round(e.info.volume * 100) / 100);
		}
		
		public function destroy():void {
			stop();
			stream.close();
			connection.close();
			removeChild(video);
			video.attachNetStream(null);
			video.clear();
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			video = null;
		}
		
		// PRIVATE METHODS ________________________________________________________________________________
		
		private function play(url:String):void {
			try {
				stream.play(url);
				paused = false;
			} catch (e:Error) {
				trace(e);
			}
		}
		
		private function pause():void {
			stream.togglePause();
			paused = !paused;
		}
		
		private function stop():void {
			stream.pause();
			stream.seek(0);
			paused = true;
		}
		
		private function seek(offset:Number):void {
			stream.seek(offset);
		}
		
		private function mute():void {
			setVolume(0);
		}
		
		private function setVolume(value:Number):void {
			st.volume = value;
			stream.soundTransform = st;
		}
		
		private function videoTimeConvert(num:Number):String {
			var tempNum:Number = num;
			var minutes:Number = Math.floor(tempNum / 60);
			var seconds:Number = Math.round(tempNum - (minutes * 60));
			
			return ( (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds) );
			
		}
		
	}
	
}