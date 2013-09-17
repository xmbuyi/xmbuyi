package com.tomez.tooltip 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	/**
	* ...
	* @author Tomez
	*/
	public class ToolTip extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var borderWidth:uint = 2;
		private var borderColor1:Number = 0x4d4d4d;
		private var borderColor2:Number = 0x353535;
		
		private var bgColor1:Number = 0x242424;
		private var bgColor2:Number = 0x000000;
		
		private var bg:Bitmap;
		
		private var holder:Sprite;
		
		private var format:TextFormat;
		private var tf:TextField;
		
		private var targetHeight:Number = 30;
		private var targetWidth:Number = 45;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function ToolTip(text:String) 
		{
			draw();
			initTextField(text);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function initTextField(text:String):void {
			format = new TextFormat();
			format.font = "Arial";
			format.size = 10;
			format.color = 0xcccccc;
			
			tf = new TextField();
			tf.autoSize = "left";
			//tf.antiAliasType = AntiAliasType.ADVANCED;
			//tf.embedFonts = true;
			tf.selectable = false;
			tf.defaultTextFormat = format;
			tf.htmlText = text;
			tf.x = targetWidth / 2 - tf.textWidth / 2 + 2;
			tf.y = targetHeight / 2 - tf.textHeight / 2;
			
			var gf:GlowFilter = new GlowFilter();
			gf.alpha = 0;
			tf.filters = [gf];
			
			addChild(tf);
		}
		
		public function set text(text:String):void {
			tf.htmlText = text;
			tf.x = targetWidth / 2 - tf.textWidth / 2 + 2;
		}
		
		private function draw():void {
			holder = new Sprite();
			
			bg = new Bitmap(new img_tooltipbg(0, 0));
			holder.addChild(bg);
			
			addChild(holder);
		}
		
	}
	
}