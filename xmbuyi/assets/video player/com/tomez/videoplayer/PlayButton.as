package com.tomez.videoplayer 
{
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class PlayButton extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var symbol_1:Bitmap;
		private var symbol_2:Bitmap;
		
		private var overSkin:TSprite;
		
		private var playState:Boolean = false;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function PlayButton() 
		{
			buttonMode = true;
			init();
			
			setPauseSymbol();
			
			addEventListener(MouseEvent.CLICK, onPress);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onPress(e:MouseEvent):void {
			dispatchEvent(new Event("onTogglePause", true));
			if (playState) {
				setPauseSymbol();
			} else {
				setPlaySymbol();
			}
			playState = ! playState;
			
			dispatchEvent(new Event("onPlay", true));
		}
		
		private function onOver(e:MouseEvent):void {
			TweenLite.to(overSkin, 0.2, {alpha:1 } );
		}
		
		private function onOut(e:MouseEvent):void {
			TweenLite.to(overSkin, 0.2, {alpha:0 } );
		}
		
		public function onStop(e:Event):void {
			playState = true;
			setPlaySymbol();
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			symbol_1 = new Bitmap(new img_play(0, 0));
			symbol_2 = new Bitmap(new img_pause(0, 0));
			
			var size:uint = 30;
			var overSkinSizeDiff:uint = 4;
			
			overSkin = new TSprite;
			overSkin.graphics.beginFill(0xffffff, 0.14);
			overSkin.graphics.drawRoundRect(overSkinSizeDiff / 2, overSkinSizeDiff / 2, size-overSkinSizeDiff, size-overSkinSizeDiff, 10);
			overSkin.graphics.endFill();
			
			overSkin.alpha = 0;
			addChild(overSkin);
			
			symbol_2.alpha = 0;
			symbol_2.x = 10;
			symbol_2.y = 10;
			addChild(symbol_2);
			
			symbol_1.x = 10;
			symbol_1.y = 10;
			addChild(symbol_1);
		}
		
		private function setPauseSymbol():void {
			TweenLite.to(symbol_1, 0.2, { alpha:0 } );
			TweenLite.to(symbol_2, 0.2, { alpha:1 } );
		}
		
		private function setPlaySymbol():void {
			TweenLite.to(symbol_1, 0.2, { alpha:1 } );
			TweenLite.to(symbol_2, 0.2, { alpha:0 } );
		}
		
	}
	
}