package com.tomez.videoplayer 
{
	import com.tomez.TSprite;
	import flash.utils.getDefinitionByName;
	
	/**
	* ...
	* @author Tomez
	*/
	public class VideoPlayer extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var video:BasicVideo;
		
		private var skin:VideoSkin;
		
		private var targetWidth:Number;
		private var targetHeight:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function VideoPlayer(width:Number = 350, height:Number = 240) 
		{
			this.targetWidth = width >= 350 ? width : 350;
			this.targetHeight = height >= 240 ? height : 240;
			
			init();
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			skin = new VideoSkin(targetWidth, targetHeight);
			
			video = new BasicVideo(targetWidth, targetHeight);
			
			video.addEventListener("onUpdate", skin.update);
			
			addChild(video);
			addChild(skin);			
			
			skin.addEventListener("onTogglePause", video.togglePause);
			skin.addEventListener("onStop", video.stopVideo);
			skin.addEventListener("onSeek", video.seekVideo);
			skin.addEventListener("onSeekFinished", video.seekFinished);
			skin.addEventListener("onVolumeChanged", video.setVideoVolume);
		}
		
		public function playVideo(url:String):void {
			try {
				getDefinitionByName("main").onVideoPlaying();
			} catch(e:Error) {}
			
			video.playVideo(url);
		}
		
		public function stopVideo():void {
			video.stopVideo(null);
		}
		
		public function getVideoWindow():BasicVideo {
			return video;
		}
		
		public function destroy():void {
			skin.removeAllEventListeners(true);
			skin = null;
			
			video.destroy();
			video = null;
		}
		
	}
	
}