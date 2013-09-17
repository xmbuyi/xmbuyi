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
		
		private var format:TextFormat;
		private var tf:TextField;
		
		private var title:String;
		
		public var ox:Number;
		public var oy:Number;
		
		private var bgColor:Number = 0x333333;
		
		private var rollOverBgColor:Number = 0xffffff;
		private var rollOverTextColor:Number = 0x000000;
		
		public var bigImageInfo:Object;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Thumbnail(title:String) 
		{
			this.title = title;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onProgress(e:ProgressEvent):void {
			
		}
		
		private function onComplete(e:Event):void {
			drawBg();
			addTextField(title.length > 0 ? title : "Untitled", thumb.width);
			if (bigImageInfo.xml.hasOwnProperty("video")) {
				addVideoPlayButton();
			}
		}
		
		private function onIOError(e:IOErrorEvent):void {
			
		}
		
		private function onClick(e:MouseEvent):void {
			clickHandler();
		}
		
		public function clickHandler():void {
			dispatchEvent(new BigScreenEvent("Thumb Click", bigImageInfo, true));
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
			
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		private function addTextField(text:String, width:Number):void {
			format = new TextFormat();
			format.color = 0xffffff;
			format.font = "Verdana";
			
			tf = new TextField();
			tf.selectable = false;
			tf.defaultTextFormat = format;
			tf.width = width;
			tf.height = 20;
			tf.htmlText = text;
			tf.y = thumb.height;
			
			addChild(tf);
		}
		
		
		private function drawBg():void {
			bg = new TSprite();
			bg.graphics.beginFill(bgColor);
			bg.graphics.lineStyle(4, bgColor, 1, true, "normal", "round", "round");
			bg.graphics.drawRect( -1, -1, thumb.width + 2, thumb.height + 20);
			bg.graphics.endFill();
			
			addChildAt(bg, 0);
		}
		
		private function addVideoPlayButton():void {
			var pb:playbutton = new playbutton();
			pb.x = Math.round(thumb.width / 2 - pb.width / 2);
			pb.y = Math.round(thumb.height / 2 - pb.height / 2);
			addChild(pb);
		}
		
	}
	
}