package com.tomez.imagegallery 
{
	import com.tomez.TSprite;
	import flash.events.Event;
	
	import gs.TweenLite;
	import gs.easing.*;
	
	/**
	* ...
	* @author Tomez
	*/
	public class ThumbnailsHolder extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var ax:Number;
		private var ay:Number;
		private var i:uint;
		private var len:uint;
		private var thumb_width:Number = 500;
		private var thumb_height:Number = 300;
		
		private var space:Number = 20;
		
		private var xml:XML;
		
		private var thumbs:TSprite;
		
		private var start_delay:Number = 1.5;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function ThumbnailsHolder(xml:XML) 
		{
			this.xml = xml;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onComplete():void {
			trace("Thumbs loaded.");
			
			dispatchEvent(new Event("Thumbs Loaded"));
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			
			thumbs = new TSprite();
			
			addChild(thumbs);
			
			if (start_delay > 0) {
				TweenLite.delayedCall(start_delay, build);
				start_delay = 0;
			} else {
				build();
			}			
		}
		
		public function reset():void {
			
		}
		
		private function loadNext(e:Event):void {
			if (i < len) {
				var t:Thumbnail = thumbs.getChildAt(i) as Thumbnail;
				
				if (i == 0) {
					ax = space;
				} else {
					ax = thumbs.width + space * 2;
				}
				
				t.x = ax;
				
				dispatchEvent(new Event("needResize", true));
				
				TweenLite.to(t, 0.4, { alpha:1, delay:0.2 } );
				
				t.thumb.load(t.thumb.source);
				
				i++;
			} else {
				onComplete();
			}
		}
		
		private function build():void {
			len = xml.images.i.length();
			
			for (i = 0; i < len; i++) {
				var t:Thumbnail = new Thumbnail(xml.images.i[i].title, xml.images.i[i].description, xml.images.i[i].link);
				t.alpha = 0;
				t.thumb.source = hgallery.getContentPath() + "/" + xml.images.i[i].filename;
				
				thumbs.addChild(t);
				
				t.thumb.addEventListener(Event.COMPLETE, loadNext);
			}
			
			i = 0;
			loadNext(null);
		}
		
	}
	
}