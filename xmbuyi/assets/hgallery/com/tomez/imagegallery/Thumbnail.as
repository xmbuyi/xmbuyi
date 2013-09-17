package com.tomez.imagegallery 
{
	import com.tomez.TSprite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.navigateToURL;
	
	import gs.TweenLite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class Thumbnail extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		public var thumb:BasicThumbnail;
		
		private var bg:TSprite;

		private var tf:label;
		private var tf_desc:desc_text;
		
		private var title:String;
		private var description:String;
		private var linkURL:String;
		
		public var ox:Number;
		public var oy:Number;
		
		private var bgColor:Number = 0x333333;
		
		private var rollOverBgColor:Number = 0xffffff;
		private var rollOverTextColor:Number = 0x000000;
		
		public var bigImageInfo:Object;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Thumbnail(title:String, description:String, link:String) 
		{
			this.title = title;
			this.description = description;
			this.linkURL = link;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onProgress(e:ProgressEvent):void {
			
		}
		
		private function onComplete(e:Event):void {
			drawBg();
			addTextField(title.length > 0 ? title : "Untitled", thumb.width);
			addDescTextField(description.length > 0 ? description : "", thumb.width);
		}
		
		private function onIOError(e:IOErrorEvent):void {
			
		}
		
		private function onClick(e:MouseEvent):void {
			clickHandler();
		}
		
		public function clickHandler():void {
			if(linkURL != "") {
				navigateToURL(new URLRequest(linkURL), "_blank");
			}
		}
		
		private function onOver(e:MouseEvent):void {
			TweenLite.to(bg, 0.1, { tint:rollOverBgColor } );
			TweenLite.to(tf, 0.1, { tint:rollOverTextColor } );
		}
		
		private function onOut(e:MouseEvent):void {
			TweenLite.to(bg, 0.4, { tint:null } );
			TweenLite.to(tf, 0.4, { tint:null } );
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			thumb = new BasicThumbnail();
			addChild(thumb);
			
			addEventListener(Event.COMPLETE, onComplete);
			
			thumb.buttonMode = true;
			thumb.mouseChildren = false;
			
			thumb.addEventListener(MouseEvent.CLICK, onClick);
			thumb.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			thumb.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		private function addTextField(text:String, width:Number):void {
			
			tf = new label();
			tf.d_text.width = width;
			tf.d_text.height = 20;
			tf.d_text.htmlText = text;
			tf.y = thumb.height;
			
			addChild(tf);
		}
		
		private function addDescTextField(text:String, width:Number):void {
			
			tf_desc = new desc_text();
			tf_desc.d_text.width = width;
			tf_desc.d_text.autoSize = "left";
			tf_desc.d_text.wordWrap = true;
			tf_desc.d_text.htmlText = text;
			tf_desc.y = thumb.height + 24;
			
			addChild(tf_desc);
		}
		
		
		private function drawBg():void {
			bg = new TSprite();
			bg.graphics.beginFill(bgColor);
			bg.graphics.lineStyle(4, bgColor, 1, true, "normal", "round", "round");
			bg.graphics.drawRect( -1, -1, thumb.width + 2, thumb.height + 20);
			bg.graphics.endFill();
			
			addChildAt(bg, 0);
		}
		
	}
	
}