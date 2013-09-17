package com.tomez.GridLayout 
{
	
	/**
	* ...
	* @author Tomez
	*/
	public class GridLayoutOptions extends BlockOptions
	{
		// PROPERTIES _____________________________________________________________________________________
		
		public var minimumWidth:Number;
		public var maximumWidth:Number;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function GridLayoutOptions(minimumWidth:Number, maximumWidth:Number, align:String, layout:String, bgColor:Number, bgAlpha:Number, borderSize:Number, borderColor:Number, borderAlpha:Number, ellipseWidth:Number, padding:Number, spacing:Number) 
		{
			super(align, layout, bgColor, bgAlpha, borderSize, borderColor, borderAlpha, ellipseWidth, padding, spacing, "", "");
			this.minimumWidth = minimumWidth;
			this.maximumWidth = maximumWidth;			
		}
		
		override public function toString():String {
			return ("minimumWidth: " + minimumWidth + '\n' + "maximumWidth: " + maximumWidth + '\n' + "align: " + align + '\n' + "layout: " + layout + '\n' + "bgColor: 0x" + bgColor.toString(16) + '\n' + "bgAlpha: " + bgAlpha + '\n' + "borderSize: " + borderSize + '\n' + "borderColor: 0x" + borderColor.toString(16) + '\n' + "borderAlpha: " + borderAlpha + '\n' + "ellipseWidth: " + ellipseWidth + '\n' + "padding: " + padding + '\n' + "spacing: " + spacing);
		}
		
	}
	
}