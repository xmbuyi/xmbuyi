package com.tomez.main.transition 
{
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	import com.tomez.main.transition.anims.*;
	
	/**
	* ...
	* @author Tomez
	*/
	public class Transition 
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var _mask:Sprite;
		
		private const defaultTransitionPackage:String = "com.tomez.main.transition.anims.";
		private const defaultTransition:String = defaultTransitionPackage + "RotatingRectangle";
		
		private var t1:RotatingRectangle;
		private var t2:Zoom;
		private var t3:CircleZoom;
		private var t4:LeftToRight;
		private var t5:RightToLeft;
		private var t6:TopToBottom;
		private var t7:BottomToTop;
		
		private var nextTransition:String
		private var transition:Object;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Transition(mask:Sprite) 
		{
			this._mask = mask;
		}
		
		// METHODS ________________________________________________________________________________________
		
		public function setTransition(t:String):void {
			try {
				nextTransition = defaultTransitionPackage + t;
				transition = getDefinitionByName(nextTransition);
				transition.initMask(_mask);
			} catch (e:Error) {
				trace("Transition:", defaultTransitionPackage + t, "not found. Using default transition(", defaultTransition, ")");				
				nextTransition = defaultTransition;
				transition = getDefinitionByName(nextTransition);
				transition.initMask(_mask);
			}
			
		}
		
		public function startIn(onComplete:Function = null):void {
			transition.animateIn(onComplete);
		}
		
		public function startOut(onComplete:Function = null):void {
			transition.animateOut(onComplete);
		}
		
		public function drawMask():void {
			transition.drawMask();
		}
		
		public function showContent():void {
			_mask.scaleX = 1;
			_mask.scaleY = 1;
			_mask.rotation = 0;
		}
		
	}
	
}