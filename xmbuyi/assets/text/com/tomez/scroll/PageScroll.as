package com.tomez.scroll 
{
	import com.tomez.TSprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Tomez
	*/
	public class PageScroll extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var scrollg:scroll_graphics;
		
		private var bg:*;
		
		private var drag:*;
		private var dragging:Boolean = false;
		
		private var scrollSpeed:Number = 6;
		
		private var rect:Rectangle;

		private var targetHeight:Number;
		
		private var scroller:BasicScroll;
		
		private var target:DisplayObject;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function PageScroll(target:DisplayObject, targetHeight:Number) 
		{
			this.target = target;
			this.targetHeight = targetHeight;
			
			scrollg = new scroll_graphics();
			bg = scrollg.bg;
			drag = scrollg.drag;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		public function resize(targetHeight:Number):void {
			dragging = false;
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			this.targetHeight = targetHeight;
			
			redrawBg();
			
			rect.height = targetHeight - drag.height;
			
			drag.y = 0;
			
			scroller.refresh(targetHeight - 40, rect.height);
			
			setVisible();
		}
		
		private function mouseDown(e:Event):void {
			
			text.getStage().addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			dragging = true;
			if (!hasEventListener(Event.ENTER_FRAME)) {
				addEventListener(Event.ENTER_FRAME, enterFrame);
			}
			
			drag.startDrag(false, rect);
		}
		
		private function mouseUp(e:Event):void {
			
			text.getStage().removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			dragging = false;
			//removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			drag.stopDrag();
		}
		
		private function mouseWheel(e:MouseEvent):void {
			if (target.height > targetHeight) {
				if (!hasEventListener(Event.ENTER_FRAME)) {
					addEventListener(Event.ENTER_FRAME, enterFrame);
				}
				drag.y -= e.delta * scrollSpeed;
				if (drag.y > 0 + rect.height) {
					drag.y = 0 + rect.height;
				} else if (drag.y < 0) {
					drag.y = 0;
				}
				scroller.scroll(drag);
			}
		}
		
		private function mouseOver(e:Event):void {
			
		}
		
		private function mouseOut(e:Event):void {
			
		}
		
		private function enterFrame(e:Event):void {
			scroller.scroll(drag);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			
			drag.buttonMode = true;
			drag.mouseChildren = false;
			
			rect = new Rectangle(0, 0, 0, targetHeight - drag.height);
			
			addListeners();
			
			scroller = new BasicScroll(target, targetHeight, rect.height);
			
			addChild(scrollg);
			
			setVisible();
		}
		
		private function setVisible():void {
			if (target.height < targetHeight) {
				visible = false;
			} else {
				visible = true;
			}
		}
		
		private function addListeners():void {
			drag.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			drag.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			drag.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			drag.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			text.getStage().addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		public function removeListeners():void {
			drag.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			drag.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			drag.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			drag.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			text.getStage().removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		public function redrawBg():void {
			bg.height = targetHeight;
		}
		
	}
	
}