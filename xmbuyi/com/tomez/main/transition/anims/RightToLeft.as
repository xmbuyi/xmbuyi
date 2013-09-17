package com.tomez.main.transition.anims 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	
	import gs.easing.Linear;
	import gs.TweenLite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class RightToLeft
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private static var _mask:Sprite;
		
		private static var _stage:Stage;
		
		// METHODS ________________________________________________________________________________________
		
		public static function initMask(mask:Sprite):void {
			_mask = mask;
			_stage = getDefinitionByName("main").getStage();
			
			_mask.scaleX = 0;
			_mask.scaleY = 0;
			
			drawMask();
		}
		
		public static function drawMask():void {
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			_mask.graphics.endFill();
			_mask.x = _stage.stageWidth;
			_mask.y = 0;
		}
		
		public static function animateIn(onComplete:Function):void {
			_mask.scaleX = 0;
			_mask.scaleY = 1;
			_mask.rotation = 0;
			TweenLite.to(_mask, 0.55, { scaleX:-1, scaleY:1, rotation:0, ease:Linear.easeOut, onComplete:onComplete} );
		}
		
		public static function animateOut(onComplete:Function):void {
			TweenLite.to(_mask, 0.55, { scaleX:0, scaleY:1, rotation:0, ease:Linear.easeOut, onComplete:onComplete} );
		}
		
	}
	
}