package com.tomez.imagegallery 
{
	import com.tomez.TSprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenLite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class Button extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		public var id:uint;
		
		private var format:TextFormat;
		private var tf:TextField;
		
		private var bg:TSprite;
		private var bgColor:Number;
		
		private var textColor:Number;
		public var rollOverBorderColor:Number = 0x00bbff;
		public var rollOverBgColor:Number = 0x222222;
		public var rollOverTextColor:Number = 0x00bbff;
		
		private var targetWidth:Number;
		private var targetHeight:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Button(text:String, bgColor:Number = 0x222222, textColor:Number = 0x555555, width:Number = 18, height:Number = 19) 
		{
			this.bgColor = bgColor;
			this.textColor = textColor;
			this.targetWidth = width;
			this.targetHeight = height;
			
			init();
			this.text = text;
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onOver(e:MouseEvent):void {
			TweenLite.to(bg, 0.0, { tint:rollOverBgColor } );
			TweenLite.to(tf, 0.0, { tint:rollOverTextColor } );
		}
		
		private function onOut(e:MouseEvent):void {
			TweenLite.to(bg, 0.1, { tint:null } );
			TweenLite.to(tf, 0.1, { tint:null } );
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			drawText();
			
			bg = new TSprite();
			drawBg();
			addChildAt(bg, 0);
			
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		public function removeListeners():void {
			removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			
			buttonMode = false;
		}
		
		private function drawBg():void {
			bg.graphics.clear();
			bg.graphics.lineStyle(1, 0x555555);
			bg.graphics.beginFill(bgColor);
			bg.graphics.drawRect(0, 0, tf.width+7, targetHeight);
			bg.graphics.endFill();
		}
		
		private function drawText():void {
			format = new TextFormat();
			format.font = "Tahoma";
			format.size = 11;
			format.color = textColor;
			format.bold = true;
			
			tf = new TextField();
			tf.multiline = false;
			tf.autoSize = "left";
			tf.selectable = false;
			tf.defaultTextFormat = format;
			tf.htmlText = "10";
			tf.embedFonts = false;
			tf.x = 4;
			tf.y = 1;
			addChild(tf);
		}
		
		public function set text(text:String):void {
			tf.htmlText = text;
			drawBg();
		}
		
	}
	
}