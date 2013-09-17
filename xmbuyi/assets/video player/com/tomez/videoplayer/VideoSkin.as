package com.tomez.videoplayer 
{
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	* ...
	* @author Tomez
	*/
	public class VideoSkin extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var controls_bg:TSprite;
		
		private var stop:StopButton;
		private var play:PlayButton;
		
		private var separator1:TSprite;
		private var separator2:TSprite;
		private var separator3:TSprite;
		private var separator4:TSprite;
		
		private var sep_width:uint = 2;
		
		private var streamBar:StreamBar;
		
		private var videoTime:VideoTime;
		
		private var volumeControl:VolumeControl;
		
		private var splash_screen:TSprite;
		
		private var targetWidth:Number;
		private var targetHeight:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function VideoSkin(width:Number, height:Number) 
		{
			this.targetWidth = width;
			this.targetHeight = height;
			
			build();
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function build():void {
			addSplashScreen();
			addControlsBg();
			addStopButton();
			addSeparator1();
			addPlayButton();
			addSeparator2();
			addStreamBar();
			addSeparator3();
			addVideoTime();
			addSeparator4();
			initVolumeControl();
		}
		
		private function initVolumeControl():void {
			volumeControl = new VolumeControl(62);
			volumeControl.x = separator4.x + 10 + sep_width;
			volumeControl.y = targetHeight + 13;
			addChild(volumeControl);
		}
		
		public function update(event:UpdateEvent):void {
			videoTime.setPlayTime(event.info.secs);
			videoTime.setTotalTime(event.info.totalSecs);
			
			streamBar.setPlayedPercent(event.info.amountPlayed);
			streamBar.setLoadedPercent(event.info.amountLoaded);
			streamBar.setPlayTime(event.info.secs);
			
			if (event.info.amountPlayed > 0 && splash_screen.visible) {
				hideSplashScreen();
			}
		}
		
		private function addVideoTime():void {
			videoTime = new VideoTime(targetWidth, targetHeight);
			videoTime.x = separator3.x + 10 + sep_width;
			videoTime.y = targetHeight + 7;
			addChild(videoTime);
		}
		
		private function addStreamBar():void {
			streamBar = new StreamBar(targetWidth - 300);
			streamBar.x = 71 + sep_width;
			streamBar.y = targetHeight + 13;
			addChild(streamBar);
		}
		
		private function addSeparator1():void {
			var bg:Bitmap = new Bitmap(new img_separator(0, 0));
			
			separator1 = new TSprite();
			separator1.addChild(bg);
			separator1.x = 28 + sep_width;
			separator1.y = targetHeight + 4;
			addChild(separator1);
		}
		
		private function addSeparator2():void {
			var bg:Bitmap = new Bitmap(new img_separator(0, 0));
			
			separator2 = new TSprite();
			separator2.addChild(bg);
			separator2.x = 60 + sep_width;
			separator2.y = targetHeight + 4;
			addChild(separator2);
		}
		
		private function addSeparator3():void {
			var bg:Bitmap = new Bitmap(new img_separator(0, 0));
			
			separator3 = new TSprite();
			separator3.addChild(bg);
			separator3.x = streamBar.x + streamBar.barWidth + 8 + sep_width;
			separator3.y = targetHeight + 4;
			addChild(separator3);
		}
		
		private function addSeparator4():void {
			var bg:Bitmap = new Bitmap(new img_separator(0, 0));
			
			separator4 = new TSprite();
			separator4.addChild(bg);
			separator4.x = videoTime.x + videoTime.width + 9 + sep_width;
			separator4.y = targetHeight + 4;
			addChild(separator4);
		}
		
		private function addPlayButton():void {
			play = new PlayButton();
			play.x = 30 + sep_width;
			play.y = targetHeight;
			addChild(play);
			
			addEventListener("onStop", play.onStop);
		}
		
		private function addStopButton():void {
			stop = new StopButton();
			stop.y = targetHeight;
			
			addChild(stop);
			
			addEventListener("onPlay", stop.onPlay);
			addEventListener("onSeekFinished", stop.onPlay);
		}
		
		private function addSplashScreen():void {
			var splash_screen_color:Number = 0x000000;
			splash_screen = new TSprite();
			splash_screen.graphics.beginFill(splash_screen_color, 1.0);
			splash_screen.graphics.drawRect(0, 0, targetWidth, targetHeight);
			splash_screen.graphics.endFill();
			
			addChild(splash_screen);
		}
		
		private function addControlsBg():void {
			var bg:Bitmap = new Bitmap(new img_controls_bg(0, 0));
			var bmpdata:BitmapData = bg.bitmapData;
			
			controls_bg = new TSprite();
			controls_bg.graphics.beginBitmapFill(bmpdata, null, true);
			controls_bg.graphics.drawRect(0, 0, targetWidth, bg.height);
			controls_bg.graphics.endFill();
			
			controls_bg.y = targetHeight;
			addChild(controls_bg);
		}
		
		public function hideSplashScreen():void {
			splash_screen.visible = false;
		}
		
		public function showSplashScreen():void {
			splash_screen.visible = true;
		}
		
	}
	
}