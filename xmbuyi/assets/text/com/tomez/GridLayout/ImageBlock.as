package com.tomez.GridLayout 
{
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import br.com.stimuli.loading.BulkLoader;
	
	/**
	* ...
	* @author Tomez
	*/
	public class ImageBlock extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var source:String;
		private var bg:TSprite;
		
		private var content:*;
		
		private var xml:XML;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function ImageBlock(src:String, xml:XML) 
		{
			this.source = text.getContentPath() + "/" + src;
			this.xml = xml;
			
			bg = new TSprite();
			
			var ct:* = BulkLoader.getLoader("exloader").getContent(source).constructor;
			
			if (ct == Bitmap) {
				content = new Bitmap(BulkLoader.getLoader("exloader").getBitmapData(source));
			} else {
				content = BulkLoader.getLoader("exloader").getContent(source);
			}
			
			bg.addChild(content);
			
			xml.@width = String(Number(bg.width + xml.@padding * 2));
			
			addChild(bg);
			
		}
		
	}
	
}