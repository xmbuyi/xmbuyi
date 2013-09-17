package com.tomez.main.controlbuttons 
{
	import com.tomez.TSprite;
	import com.tomez.main.audioplayer.AudioManager;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import gs.TweenLite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class MainVolumeControl extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var barBorderColor:Number = 0x3b3b3b;
		private var barBgColor:Number = 0x171717;
		private var barHeight:uint = 5;
		private var bg:TSprite;
		
		private var volumeLine:TSprite;
		private var VolumeLineColor:Number = 0x54d2f4;
		private var holder:TSprite;
		
		private const defaultVolume:Number = 0.6;
		
		private var drag:TSprite;
		private var dragging:Boolean = false;
		private var info:Object = new Object();
		
		private var soundIcon:SoundIcon;
		
		private var st:SoundTransform;
		
		private var muted:Boolean = false;
		private var lastVolume:Number = defaultVolume;
		
		private var _stage:Object;
		
		private var targetWidth:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function MainVolumeControl(width:Number) 
		{
			this.targetWidth = width;
			
			try {
				_stage = main.getStage();
			} catch (e:Error) {
				
			}
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onDragPress(e:MouseEvent):void {
			dragging = true;
			var bounds:Rectangle = new Rectangle(0, drag.y, targetWidth - drag.width + 1, 0);
			drag.startDrag(false, bounds);
			
			_stage.addEventListener(MouseEvent.MOUSE_UP, onDragRelease);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onDragRelease(e:MouseEvent):void {
			drag.stopDrag();
			dragging = false;
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onDragRelease);
			
			var percent:Number = drag.x / (targetWidth - drag.width);
			percent = percent > 1 ? 1 : percent;
			lastVolume = percent;
		}
		
		private function onSoundIconPress(e:MouseEvent):void {
			if (!muted) {
				TweenLite.to(drag, 0.4, { x:0, onUpdate:update } );
				
				muted = true;
			} else {
				TweenLite.to(drag, 0.4, { x:lastVolume * (targetWidth - drag.width), onUpdate:update } );
				
				muted = false;
			}
		}
		
		private function onOver(e:MouseEvent):void {
			
		}
		
		private function onOut(e:MouseEvent):void {
			
		}
		
		private function onEnterFrame(e:Event):void {
			setVolumeLineWidth(drag.x);
			
			var percent:Number = drag.x / (targetWidth - drag.width);
			percent = percent > 1 ? 1 : percent;
			info.volume = percent;
			
			if (percent == 0) {
				soundIcon.setVisible(0);
			} else {
				soundIcon.setVisible( (1 + percent * 4) < 5 ? (1 + percent * 4) : 4);
			}
			
			try {
				st = AudioManager.getChannel().soundTransform;
				st.volume = percent;
            	AudioManager.getChannel().soundTransform = st;
            } catch (e:Error) {
				
			}
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			initSoundIcon();
			
			holder = new TSprite();
			holder.x = 27;
			addChild(holder);
			
			initBg();
			
			initVolumeLine();
			
			drawDrag();
			
			onEnterFrame(null);
		}
		
		private function initSoundIcon():void {
			soundIcon = new SoundIcon();
			soundIcon.y = -soundIcon.height / 2 + 2;
			addChild(soundIcon);
			
			soundIcon.buttonMode = true;
			soundIcon.addEventListener(MouseEvent.CLICK, onSoundIconPress);
		}
		
		public function volumeOff():void {
			if (!muted) {
				TweenLite.to(drag, 0.4, { x:0, onUpdate:update } );
				
				muted = true;
			}
		}
		
		public function volumeBack():void {
			if(muted) {
				TweenLite.to(drag, 0.4, { x:lastVolume * (targetWidth - drag.width), onUpdate:update } );
				
				muted = false;
			}
		}
		
		private function drawDrag():void {
			drag = new TSprite();
			
			drag.graphics.lineStyle(1, 0x000000, 1, true, "normal", null, "miter");
			drag.graphics.beginFill(0xcccccc);
			drag.graphics.drawRect(0, 0, 6, 6);
			drag.graphics.endFill();
			
			drag.x = defaultVolume * targetWidth;
			drag.y = -1;
			holder.addChild(drag);
			
			drag.buttonMode = true;
			
			drag.addEventListener(MouseEvent.MOUSE_DOWN, onDragPress);
			drag.addEventListener(MouseEvent.MOUSE_UP, onDragRelease);
			drag.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			drag.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		private function setVolumeLineWidth(value:Number):void {
			volumeLine.graphics.clear();
			volumeLine.graphics.beginFill(VolumeLineColor);
			volumeLine.graphics.drawRect(0, 0, value, barHeight-2);
			volumeLine.graphics.endFill();
		}
		
		private function update():void {
			onEnterFrame(null);
		}
		
		private function initVolumeLine():void {
			volumeLine = new TSprite();
			
			volumeLine.graphics.beginFill(VolumeLineColor);
			volumeLine.graphics.drawRect(0, 0, defaultVolume * targetWidth, barHeight-2);
			volumeLine.graphics.endFill();
			volumeLine.x = 1;
			volumeLine.y = 1;
			holder.addChild(volumeLine);
		}
		
		private function initBg():void {
			bg = new TSprite();
			
			bg.graphics.lineStyle(1, barBorderColor, 1, true, "normal", null, "miter");
			bg.graphics.beginFill(barBgColor);
			bg.graphics.drawRect(0, 0, targetWidth, barHeight-1);
			bg.graphics.endFill();
			holder.addChild(bg);
		}
		
	}
	
}