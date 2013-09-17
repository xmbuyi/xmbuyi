package com.tomez.menu 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	* ...
	* @author Tomez
	*/
	public class SubMenu extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var mouseScroll:Boolean = true;
		private var tempY:Number;
		private var targetY:Number;
		private var scrollDist:Number;
		private var dist:Number;
		private var ratio:Number;
		private var maxY:Number;
		private var mnull:Number;
		private var scnull:Number;
		
		private var _mask:Sprite;
		private const maskHeight:Number = 7 * 22;
		
		private var border:Sprite;
		
		private var holder:Sprite;
		
		private var mi:MenuItem;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function SubMenu(xml:XMLList, mi:MenuItem) 
		{
			this.mi = mi;
			
			build(xml);
			if (mouseScroll && holder.height > maskHeight) {
				initScroll();
			}
			
			drawBorder();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function scroll(e:Event):void {
			if (mouseX >= 0 && mouseX <= width) {
				
				tempY = Math.round(mnull -(ratio * (mouseY - scnull) ) );
				targetY -= Math.round( (holder.y - tempY) / 4);
				if (targetY < maxY) {
					targetY = maxY;
				}
				if (targetY > mnull) {
					targetY = mnull;
				}
			
				holder.y = targetY
			}
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function initScroll():void {
			initMask();
			
			addEventListener(Event.ENTER_FRAME, scroll);
		}
		
		private function initMask():void {
			_mask = new Sprite();
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0, 0, holder.width + 1, maskHeight);
			_mask.graphics.endFill();
			
			holder.mask = _mask;
			addChild(_mask);
		}
		
		private function drawBorder():void {
			border = new Sprite();
			border.graphics.lineStyle(1, 0x0099FF);
			border.graphics.moveTo(0, getHeight());
			border.graphics.lineTo(holder.width, getHeight());
			
			addChild(border);
		}
		
		private function build(xml:XMLList):void {
			var ax:Number = 0;
			var ay:Number = 0;
			var i:uint;
			var len:uint = xml.m.length();
			var max_width:Number = 0;
			
			holder = new Sprite();
			
			for (i = 0; i < len; i++) {
				var item:SubMenuItem = new SubMenuItem(xml.m[i], mi);
				item.x = ax;
				item.y = ay;
				
				ay += item.height + 0;
				
				holder.addChild(item);
				max_width = Math.max(item.width, max_width);
			}
			
			for (i = 0; i < len; i++) {
				(holder.getChildAt(i) as SubMenuItem).itemWidth = max_width;
				(holder.getChildAt(i) as SubMenuItem).redrawBg();
				//if (i == 0) item.clearFirstLine();
			}
			
			mnull = 0;
			scnull = 22;
			targetY = 0;
			
			scrollDist = maskHeight - 22 * 2;
			dist = Math.round(holder.height - maskHeight);
			ratio = dist / scrollDist;
			maxY = -dist + mnull;
			
			addChild(holder);
		}
		
		public function getItem(id:Number):SubMenuItem {
			return (holder.getChildAt(id) as SubMenuItem);
		}
		
		public function getHeight():Number {
			if (mouseScroll) {
				return (height >= maskHeight ? maskHeight : height);
			} else {
				return height;
			}
		}
		
		public function reset():void {
			targetY = 0;
			holder.y = targetY;
		}
		
	}
	
}