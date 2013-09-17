package com.tomez.videoplayer 
{
	import com.tomez.tooltip.ToolTip;
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import gs.TweenLite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class StreamBar extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var barBorderColor:Number = 0x3b3b3b;
		private var barBgColor:Number = 0x3b3b3b;
		private var barHeight:uint = 5;
		private var bg:TSprite;
		
		private var amountPlayedColor:Number = 0x54d2f4;
		private var amountPlayed:TSprite;
		
		private var amountLoadedColor:Number = 0x171717;
		private var amountLoaded:TSprite
		
		private var drag:TSprite;
		private var dragging:Boolean = false;
		private var info:Object = new Object();
		
		private var tip:ToolTip;
		
		private var main:Object;
		private var _stage:Object;
		
		private var targetWidth:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function StreamBar(width:Number) 
		{
			this.targetWidth = width;
			
			try {
				main = getDefinitionByName("main");
				_stage = main;
			} catch (e:Error) {
				try {
					_stage = getDefinitionByName("gallery")
				} catch (e:Error) {
					_stage = player;
				}
			}
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onDragPress(e:MouseEvent):void {
			dragging = true;
			var bounds:Rectangle = new Rectangle(- drag.width / 2, drag.y, targetWidth, 0);
			drag.startDrag(false, bounds);
			
			_stage.getStage().addEventListener(MouseEvent.MOUSE_UP, onDragRelease);
			
			TweenLite.to(tip, 0.5, {alpha: 1 } );
		}
		
		private function onDragRelease(e:MouseEvent):void {
			drag.stopDrag();
			dragging = false;
			
			_stage.getStage().removeEventListener(MouseEvent.MOUSE_UP, onDragRelease);
			
			dispatchEvent(new Event("onSeekFinished", true));
			
			TweenLite.to(tip, 0.5, {alpha: 0 } );
		}
		
		// PUBLIC METHODS _________________________________________________________________________________
		
		public function setPlayedPercent(percent:Number):void {
			if (!dragging) {
				setAmountPlayed(targetWidth * percent);
				drag.x = targetWidth * percent - drag.width / 2;
			} else {
				setAmountPlayed(drag.x);
				info.seek = drag.x / targetWidth;
				
				dispatchEvent(new UpdateEvent("onSeek", info, true));
			}
		}
		
		public function setLoadedPercent(percent:Number):void {
			setAmountLoaded(targetWidth * percent);
		}
		
		public function setPlayTime(time:String):void {
			tip.x = drag.x - 19;
			tip.text = time;
		}
		
		public function reset(e:Event):void {
			setPlayedPercent(0);
			setLoadedPercent(0);
		}
		
		// PRIVATE METHODS ________________________________________________________________________________
		
		private function init():void {
			initBg();
			initAmountLoaded();
			initAmountPlayed();
			
			setAmountLoaded(0);
			setAmountPlayed(0);
			
			initDrag();
			
			tip = new ToolTip("00:00");
			tip.alpha = 0;			
			tip.y = -45;
			addChild(tip);
		}
		
		private function initDrag():void {
			drag = new TSprite();
			drag.addChild(new Bitmap(new img_drag(0, 0)));
			
			drag.x = - drag.width / 2;
			drag.y = -1;
			addChild(drag);
			
			drag.buttonMode = true;
			
			drag.addEventListener(MouseEvent.MOUSE_DOWN, onDragPress);
			drag.addEventListener(MouseEvent.MOUSE_UP, onDragRelease);
		}
		
		// not used now
		private function drawDrag():void {
			drag = new TSprite();
			
			drag.graphics.lineStyle(1, 0xe5e8e8, 1, true, "normal", null, "miter");
			drag.graphics.beginFill(0x000000);
			drag.graphics.drawRect(0, 0, 3, 6);
			drag.graphics.endFill();
			
			drag.x = - drag.width / 2;
			drag.y = -1;
			addChild(drag);
			
			drag.buttonMode = true;
			
			drag.addEventListener(MouseEvent.MOUSE_DOWN, onDragPress);
			drag.addEventListener(MouseEvent.MOUSE_UP, onDragRelease);
		}
		
		private function setAmountPlayed(value:Number):void {
			var width:Number = value <= (targetWidth - 1) ? value : (targetWidth - 1);
			amountPlayed.graphics.clear();
			amountPlayed.graphics.beginFill(amountPlayedColor);
			amountPlayed.graphics.drawRect(0, 0, width, barHeight-2);
			amountPlayed.graphics.endFill();
		}
		
		private function setAmountLoaded(value:Number):void {
			var width:Number = value <= (targetWidth - 1) ? value : (targetWidth - 1);
			amountLoaded.graphics.clear();
			amountLoaded.graphics.beginFill(amountLoadedColor);
			amountLoaded.graphics.drawRect(0, 0, width, barHeight-2);
			amountLoaded.graphics.endFill();
		}
		
		private function initAmountPlayed():void {
			amountPlayed = new TSprite();
			
			amountPlayed.graphics.beginFill(amountPlayedColor);
			amountPlayed.graphics.drawRect(0, 0, 0, barHeight-2);
			amountPlayed.graphics.endFill();
			amountPlayed.x = 1;
			amountPlayed.y = 1;
			addChild(amountPlayed);
		}
		
		private function initAmountLoaded():void {
			amountLoaded = new TSprite();
			
			amountLoaded.graphics.beginFill(amountLoadedColor);
			amountLoaded.graphics.drawRect(0, 0, 0, barHeight-2);
			amountLoaded.graphics.endFill();
			amountLoaded.x = 1;
			amountLoaded.y = 1;
			addChild(amountLoaded);
		}
		
		private function initBg():void {
			bg = new TSprite();
			
			bg.graphics.lineStyle(1, barBorderColor, 1, true, "normal", null, "miter");
			bg.graphics.beginFill(barBgColor);
			bg.graphics.drawRect(0, 0, targetWidth, barHeight-1);
			bg.graphics.endFill();
			addChild(bg);
		}
		
		public function get barWidth():Number {
			return bg.width;
		}
		
	}
	
}