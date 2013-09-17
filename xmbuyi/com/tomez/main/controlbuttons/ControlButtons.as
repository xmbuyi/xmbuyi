package com.tomez.main.controlbuttons 
{
	import com.tomez.main.audioplayer.AudioPlayer;
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.display.StageDisplayState;
	import flash.utils.getDefinitionByName;
	
	import br.com.stimuli.loading.BulkLoader;
	
	import gs.TweenLite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class ControlButtons extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var bg:TSprite;
		
		private var fsbutton:fullscreenbutton;
		private var fsbitmap:Bitmap;
		
		private var playbutton:TSprite;
		
		private var playlist_mc:playlistbutton;
		
		public var vc:MainVolumeControl;
		
		private var _stage:Stage;
		private var audioPlayer:AudioPlayer;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function ControlButtons(stage:Stage, audioPlayer:AudioPlayer) 
		{
			this._stage = stage;
			this.audioPlayer = audioPlayer;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function mouseOver(e:MouseEvent):void {
			TweenLite.to(e.target, 0.1, { alpha:1 } );
		}
		
		private function mouseOut(e:MouseEvent):void {
			TweenLite.to(e.target, 0.1, { alpha:0.8 } );
		}
		
		private function onPlayButtonClick(e:MouseEvent):void {
			audioPlayer.x = Math.round(_stage.stageWidth / 2 - audioPlayer.width / 2);
			audioPlayer.y = -audioPlayer.height;
			
			getDefinitionByName("main").showCloseRect();
			
			var ty:Number = getDefinitionByName("main").stageRect.y + Math.round(getDefinitionByName("main").stageRect.height / 2 - 209 / 2);
			
			TweenLite.to(audioPlayer, 0.25, { autoAlpha:1, y:ty } );
		}
		
		private function onFullScreenButtonClick(e:MouseEvent):void {
			if (_stage.displayState == StageDisplayState.NORMAL) {
				_stage.displayState = StageDisplayState.FULL_SCREEN;
			} else {
				_stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		public function fullScreenEventHandler(e:FullScreenEvent):void {
			if (e.fullScreen) {
				fsbutton.gotoAndStop(2);
			} else {
				fsbutton.gotoAndStop(1);
			}
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			draw();
			
			fsbutton.buttonMode = true;
			fsbutton.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			fsbutton.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			fsbutton.addEventListener(MouseEvent.CLICK, onFullScreenButtonClick);
			
			playbutton.buttonMode = true;
			playbutton.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			playbutton.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			playbutton.addEventListener(MouseEvent.CLICK, onPlayButtonClick);
		}
		
		private function draw():void {
			fsbutton = new fullscreenbutton();
			fsbutton.mouseChildren = false;

			playbutton = new TSprite();
			playlist_mc = new playlistbutton();
			playbutton.addChild(playlist_mc);
			playbutton.x = 100;
			playbutton.y = 5;
			
			vc = new MainVolumeControl(62);
			vc.x = 0;
			vc.y = 8;
			
			fsbutton.x = 120;
			fsbutton.y = 0;
			fsbutton.alpha = 0.8;
			
			addChild(playbutton);
			addChild(fsbutton);
			addChild(vc);
		}
		
	}
	
}