package com.tomez.contact 
{
	import com.tomez.TSprite;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Tomez
	*/
	public class QButton extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________

		private var tf:Text;
		
		private var bg:TSprite;
		private var ds:DropShadowFilter;
		private var bf:BevelFilter;
		
		private var targetWidth:Number;
		private var targetHeight:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function QButton(label:String, targetWidth:Number = 73, targetHeight:Number = 33) 
		{
			this.targetWidth = targetWidth;
			this.targetHeight = targetHeight;
			
			draw(label);
			
			buttonMode = true;
			mouseChildren = false;
			
			addListeners();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onMouseDown(e:Event):void {
			bf.distance = 0;
			bg.filters = [ds, bf];
			tf.x++;
			tf.y++;
		}
		
		private function onMouseUp(e:Event):void {
			bf.distance = 0.5;
			bg.filters = [ds, bf];
			tf.x--;
			tf.y--;
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function addListeners():void {
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function draw(label:String):void {
			drawBg();
			drawLabel(label);
		}
		
		private function drawLabel(text:String):void {
			tf = new Text();
			tf.d_text.autoSize = "left";
			tf.d_text.selectable = false;
			tf.d_text.multiline = false;
			tf.d_text.htmlText = text;
			tf.d_text.width = tf.d_text.textWidth + 6;
			
			tf.x = Math.round(targetWidth / 2 - tf.width / 2);
			tf.y = Math.round(targetHeight / 2 - tf.height / 2) + 1;
			addChild(tf);
		}
		
		private function drawBg():void {
			bg = new TSprite();
			bg.graphics.lineStyle(1, 0x333333, 1, true);
			bg.graphics.beginFill(0x222222);
			bg.graphics.drawRect(0, 0, targetWidth, targetHeight);
			bg.graphics.endFill();
			
			ds = new DropShadowFilter();
			ds.color = 0xcccccc;
			ds.quality = 3;
			ds.distance = 0;
			ds.blurX = 1;
			ds.blurY = ds.blurX;
			ds.strength = 0.2;
			
			bf = new BevelFilter();
			bf.quality = 3;
			bf.distance = 0.5;
			
			bg.filters = [ds, bf];
			
			addChild(bg);
		}
		
	}
	
}