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
		
		private var items_in_row:Number = 5;
		private var items_in_column:Number = 4;
		private var thumb_width:Number = 120;
		private var thumb_height:Number = 90;
		private var maxImagesPerPage:uint = 20;
		
		public var visibleWidth:Number = items_in_row * thumb_width + (items_in_row - 1) * space;
		public var visibleHeight:Number = items_in_column * thumb_height + (items_in_column - 1) * space;
		
		private var targetLeftSide:Number;
		private var targetRightSide:Number;
		
		private var space:Number = 20;
		
		private var W120_path:String = "/w120/";
		private var W720_path:String = "/w720/";
		private var VIDEO_path:String = "/video/";
		private var SWF_path:String = "/swf/";
		
		private var xml:XML;
		
		private var thumbs:TSprite;
		
		private var start_index:uint = 0;
		
		private var direction:String = "left";
		
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
			
			if (start_delay > 0) {
				TweenLite.delayedCall(start_delay, animateThumbsInByRange);
				start_delay = 0;
			} else {
				animateThumbsInByRange();
			}
			
			addChild(thumbs);
		}
		
		public function showPage(e:PageEvent):void {
			
			if (e.page * maxImagesPerPage < start_index) {
				direction = "right";
			} else {
				direction = "left";
			}
			
			animateThumbsOutByRange();
			
			start_index = e.page * maxImagesPerPage;
			TweenLite.delayedCall(0.5, animateThumbsInByRange);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			
			setVariables();
			
			thumbs = new TSprite();
			
			build();
			
		}
		
		public function setVariables():void {
			targetRightSide = gallery.getStage().stageWidth + 100;
			targetLeftSide = gallery.getStage().stageWidth * -1 - 100;
		}
		
		public function reset():void {
			for (i = 0; i < len; i++) {
				var t:Thumbnail = thumbs.getChildAt(i) as Thumbnail;
				if (t.x == targetRightSide) {
					t.x = gallery.getStage().stageWidth + 100;
				}
			}
		}
		
		private function animateThumbsInByRange():void {
			
			ax = 0;
			ay = 0;
			
			for (i = 0; i < len; i++) {
				var t:Thumbnail = thumbs.getChildAt(i) as Thumbnail;
				
				if (i >= start_index && i < (start_index + maxImagesPerPage)) {
					
					if (direction == "left") {
						t.x = targetRightSide;
						t.rotation = randRange( -180, -190);
					} else {
						t.x = targetLeftSide;
						t.rotation = randRange( 180, 190);
					}
					
					t.y = 300;
					
					t.ox = ax;
					t.oy = ay;
					
					if ((i+1) % items_in_row == 0) {
						ax = 0;
						ay += thumb_height + space;
					} else {
						ax += thumb_width + space;
					}
					
					
					TweenLite.to(t, 0.55, { x:t.ox, y:t.oy, rotation:-0, delay:(i - start_index + 1) / 30 } );
					//trace(i);
				}
			}
		}
		
		private function animateThumbsOutByRange():void {
			var max_len:Number = (start_index + maxImagesPerPage) <= len ? (start_index + maxImagesPerPage) : len;
			
			for (i = 0; i < len; i++) {
				var t:Thumbnail;
				
				if (i >= start_index && i < max_len) {
					if (direction == "left") {
						t = thumbs.getChildAt(i) as Thumbnail;
						TweenLite.to(t, 0.75, { x:targetLeftSide, rotation:randRange( -180, -190), delay:(i - start_index + 1) / 30, ease: Linear.easeIn} );
					} else {
						t = thumbs.getChildAt(max_len - i + start_index - 1) as Thumbnail;
						TweenLite.to(t, 0.55, { x:targetRightSide, y:300, rotation:randRange( 80, 90), delay:(i - start_index + 1) / 30, ease: Linear.easeIn} );
					}
				}
			}
		}
		
		private function loadNext(e:Event):void {
			if (i < len) {
				var t:Thumbnail = thumbs.getChildAt(i) as Thumbnail;
				t.thumb.load(t.thumb.source);
				i++;
			} else {
				onComplete();
			}
		}
		
		private function build():void {
			len = xml.images.i.length();
			
			for (i = 0; i < len; i++) {
				var t:Thumbnail = new Thumbnail(xml.images.i[i].title);
				t.x = targetRightSide;
				t.rotation = randRange( -180, -190);
				
				t.thumb.source = gallery.getContentPath() + W120_path +  xml.images.i[i].filename;
				
				t.bigImageInfo = new Object();
				t.bigImageInfo.contentPath = gallery.getContentPath();
				t.bigImageInfo.videoPath = gallery.getContentPath() + VIDEO_path;
				t.bigImageInfo.swfPath = gallery.getContentPath() + SWF_path;
				t.bigImageInfo.bigImageSource = gallery.getContentPath() + W720_path +  xml.images.i[i].filename;
				t.bigImageInfo.xml = xml.images.i[i];
				t.bigImageInfo.prevThumb = i > 0 ? (thumbs.getChildAt(i - 1) as Thumbnail) : null;
				if (i < len && i > 0) {
					(thumbs.getChildAt(i - 1) as Thumbnail).bigImageInfo.nextThumb = t;
				}
				
				thumbs.addChild(t);
				
				t.addEventListener(Event.COMPLETE, loadNext);
				
			}
			
			i = 0;
			loadNext(null);
		}
		
		private function randRange(min:Number, max:Number):Number {
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
		
	}
	
}