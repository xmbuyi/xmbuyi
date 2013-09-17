package com.tomez.GridLayout 
{
	import com.tomez.TSprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	/**
	* ...
	* @author Tomez
	*/
	public class TextBlock extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var format:TextFormat;
		private var tf:TextField;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function TextBlock(txt:String, width:Number) 
		{
			format = new TextFormat;
			format.font = "Verdana";
			
			tf = new TextField();
			tf.selectable = false;
			tf.defaultTextFormat = format;
			tf.embedFonts = text.useEmbedFont;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.width = width;
			
			tf.htmlText = txt;
			addChild(tf);
		}
		
		// METHODS ________________________________________________________________________________________
		
		public function setWidth(width:Number):void {
			tf.width = width;
		}
	}
	
}