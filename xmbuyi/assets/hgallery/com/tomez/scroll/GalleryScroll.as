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
	public class GalleryScroll extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var drag:*;
		private var dragging:Boolean = false;
		
		private var scrollSpeed:Number = 6;
		
		private var rect:Rectangle;
		
		private var targetWidth:Number;
		private var targetHeight:Number;
		private var dragWidth:Number;
		
		private var scroller:BasicHorizontalScroll;
		
		private var target:DisplayObject;
		
		//scroll is located in the library
		private var sc:scroll;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function GalleryScroll(target:DisplayObject, targetWidth:Number, targetHeight:Number) 
		{
			this.target = target;
			this.targetWidth = targetWidth;
			this.targetHeight = targetHeight;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		public function resize(targetHeight:Number, targetWidth:Number):void {
			dragging = false;
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			this.targetHeight = targetHeight;
			this.targetWidth = targetWidth;
			
			redrawBg();
			
			rect.width = targetWidth - drag.width;
			
			drag.x = 0;
			sc.y = Math.round(targetHeight / 2 + 200);
			
			scroller.refresh(targetWidth - 40, rect.width);
			
			setVisible();
		}
		
		private function mouseDown(e:Event):void {
			
			hgallery.getStage().addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			dragging = true;
			if (!hasEventListener(Event.ENTER_FRAME)) {
				addEventListener(Event.ENTER_FRAME, enterFrame);
			}
			
			drag.startDrag(false, rect);
		}
		
		private function mouseUp(e:Event):void {
			
			hgallery.getStage().removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			dragging = false;
			//removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			drag.stopDrag();
		}
		
		private function mouseWheel(e:MouseEvent):void {
			if (target.width > targetWidth) {
				if (!hasEventListener(Event.ENTER_FRAME)) {
					addEventListener(Event.ENTER_FRAME, enterFrame);
				}
				drag.x -= e.delta * scrollSpeed;
				if (drag.x > 0 + rect.width) {
					drag.x = 0 + rect.width;
				} else if (drag.x < 0) {
					drag.x = 0;
				}
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
			
			sc = new scroll();
			addChild(sc);
			this.dragWidth = sc.drag.width;
			this.drag = sc.drag;
			
			drag.buttonMode = true;
			drag.mouseChildren = false;
			
			rect = new Rectangle(0, 0, targetWidth - drag.width, 0);
			
			addListeners();
			
			scroller = new BasicHorizontalScroll(target, targetWidth, rect.width);
			
			setVisible();
		}
		
		private function setVisible():void {
			if (target.width < targetWidth) {
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
			hgallery.getStage().addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		public function removeListeners():void {
			drag.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			drag.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			drag.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			drag.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			hgallery.getStage().removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		public function redrawBg():void {
			sc.bg.width = targetWidth;
		}
		
	}
	
}