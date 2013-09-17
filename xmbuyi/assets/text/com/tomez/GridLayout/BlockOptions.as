package com.tomez.GridLayout 
{
	
	/**
	* ...
	* @author Tomez
	*/
	public class BlockOptions 
	{
		// PROPERTIES _____________________________________________________________________________________
		
		public var bgColor:Number;
		public var bgAlpha:Number;
		
		public var borderColor:Number;
		public var borderSize:Number;
		public var borderAlpha:Number;
		public var ellipseWidth:Number;
		
		public var padding:Number;
		public var spacing:Number;
		public var align:String;
		public var layout:String;
		
		public var link:String;
		public var target:String;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function BlockOptions(align:String, layout:String, bgColor:Number, bgAlpha:Number, borderSize:Number, borderColor:Number, borderAlpha:Number, ellipseWidth:Number, padding:Number, spacing:Number, link:String, target:String) 
		{
			this.align = align;
			this.layout = layout;
			this.bgColor = bgColor;
			this.bgAlpha = bgAlpha;
			this.borderSize = borderSize;
			this.borderColor = borderColor;
			this.borderAlpha = borderAlpha;
			this.ellipseWidth = ellipseWidth;
			this.padding = padding;
			this.spacing = spacing;
			this.link = link;
			this.target = target;
		}
		
		public function toString():String {
			return ("align: " + align + '\n' + "layout: " + layout + '\n' + "bgColor: 0x" + bgColor.toString(16) + '\n' + "bgAlpha: " + bgAlpha + '\n' + "borderSize: " + borderSize + '\n' + "borderColor: 0x" + borderColor.toString(16) + '\n' + "borderAlpha: " + borderAlpha + '\n' + "ellipseWidth: " + ellipseWidth + '\n' + "padding: " + padding + '\n' + "spacing: " + spacing);
		}
		
	}
	
}