package com.tomez.contact 
{
	import com.tomez.TSprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	
	/**
	* ...
	* @author Tomez
	*/
	public class LabeledTextArea extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________

		private var tf:Text;
		private var inf:Text;
		
		private var inputBox:TSprite;
		
		private var targetWidth:Number;
		private var targetHeight:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function LabeledTextArea(label:String, targetWidth:Number = 320, targetHeight:Number = 30) 
		{
			this.targetWidth = targetWidth;
			this.targetHeight = targetHeight;
			
			draw(label);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function draw(label:String):void {
			drawLabel(label);
			
			drawInput(targetWidth, targetHeight);
			drawText();
		}
		
		private function drawLabel(text:String):void {
			tf = new Text();
			tf.d_text.selectable = false;
			tf.d_text.autoSize = "left";
			tf.d_text.multiline = false;
			tf.d_text.htmlText = "<font color='#ffffff'>" + text + "</font>";
			
			addChild(tf);
		}
		
		private function drawText():void {
			
			inf = new Text();
			inf.d_text.type = "input";
			inf.d_text.selectable = true;
			inf.d_text.multiline = true;
			inf.d_text.width = targetWidth - 6;
			inf.d_text.htmlText = "";
			inf.d_text.height = targetHeight - 6
			
			inf.x = 6;
			inf.y = inputBox.y + 3;
			addChild(inf);
		}
		
		public function set text(text:String):void {
			inf.d_text.htmlText = text;
		}
		
		public function get text():String {
			return inf.d_text.text;
		}
		
		public function getTextField():TextField {
			return inf.d_text;
		}
		
		private function drawInput(targetWidth:Number, targetHeight:Number):void {
			inputBox = new TSprite();
			var ib:TSprite = inputBox;
			
			ib.graphics.lineStyle(1, 0x333333, 1, true, "normal", CapsStyle.ROUND, JointStyle.ROUND);
			ib.graphics.beginFill(0x222222);
			ib.graphics.drawRoundRect(0, 0, targetWidth, targetHeight, 0);
			ib.graphics.endFill();
			
			var ds:DropShadowFilter = new DropShadowFilter();
			ds.quality = 3;
			ds.distance = 1;
			ds.inner = true;
			ds.strength = 0.2;
			
			ib.filters = [ds];
			
			ib.y = 19;
			addChild(ib);
		}
		
	}
	
}