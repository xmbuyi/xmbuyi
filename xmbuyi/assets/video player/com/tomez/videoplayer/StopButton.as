package com.tomez.videoplayer 
{
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class StopButton extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var overSkin:TSprite;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function StopButton() 
		{
			buttonMode = true;
			init();
			
			addEventListener(MouseEvent.CLICK, onPress);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onPress(e:MouseEvent):void {
			dispatchEvent(new Event("onStop", true));
			disable();
		}
		
		private function onOver(e:MouseEvent):void {
			if (mouseEnabled) {
				TweenLite.to(overSkin, 0.2, {alpha:1 } );
			}
		}
		
		private function onOut(e:MouseEvent):void {
			if (mouseEnabled) {
				TweenLite.to(overSkin, 0.2, {alpha:0 } );
			}
		}
		
		public function onPlay(e:Event):void {
			if (!mouseEnabled) {
				buttonMode = true;
				mouseEnabled = true;
				
			}
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			var bg:Bitmap = new Bitmap(new img_stop(0, 0));
			
			var size:uint = 30;
			var overSkinSizeDiff:uint = 4;
			
			overSkin = new TSprite;
			overSkin.graphics.beginFill(0xffffff, 0.14);
			overSkin.graphics.drawRoundRect(overSkinSizeDiff / 2, overSkinSizeDiff / 2, size-overSkinSizeDiff, size-overSkinSizeDiff, 10);
			overSkin.graphics.endFill();
			
			overSkin.alpha = 0;
			addChild(overSkin);
			addChild(bg);
			bg.x = 10;
			bg.y = 10;
		}
		
		private function disable():void {
			buttonMode = false;
			onOut(null);
			mouseEnabled = false;
		}
		
	}
	
}