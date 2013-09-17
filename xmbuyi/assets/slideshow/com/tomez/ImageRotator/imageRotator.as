package com.tomez.ImageRotator
{
	import com.tomez.TSprite;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.net.navigateToURL;
	
	import gs.TweenLite;
	import gs.easing.*;
	
	/**
	* ...
	* @author Tomez
	*/
	public class imageRotator extends TSprite 
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var loader:Loader;
		private var loader2:Loader;
		
		private var holder:TSprite;
		
		private var idx:uint;
		private var current_holder:uint = 0;
		
		private var numbers_holder:TSprite;
		
		private var intervalId:uint;
		
		private var xml:XML;
		
		private var swnd:slideshowwindow;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function imageRotator(xml, swnd:slideshowwindow) {
			this.xml = xml;
			this.swnd = swnd;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onComplete(e:Event):void {
			loader.alpha = 0;
			holder.setChildIndex(loader, 1);
			TweenLite.to(loader, 0.8, { alpha:1 } );
			rotate();
		}
		
		private function onComplete2(e:Event):void {
			loader2.alpha = 0;
			holder.setChildIndex(loader2, 1);
			TweenLite.to(loader2, 0.8, { alpha:1 } );
			rotate();
		}
		
		private function onIOError(e:IOErrorEvent):void {
			trace(e);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init() {
			
			holder = new TSprite();
			addChild(holder);
			
			holder.buttonMode = true;
			holder.mouseChildren = false;
			holder.addEventListener(MouseEvent.CLICK, onImageClick);
			
			idx = 0;
			
			initNumbers();
			
			loader = new Loader();
			holder.addChild(loader);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			//
			loader2 = new Loader();
			holder.addChild(loader2);
			
			loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete2);
			loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			//start
			loadNext();
		}
		
		private function rotate() {
			clearInterval(intervalId);
			intervalId = setInterval(loadNext, 4000);
		}
		
		private function loadNext():void {
			
			if (current_holder == 0) {
				current_holder = 1;
				loader2.load(new URLRequest(getPath(idx)));
			} else {
				current_holder = 0;
				loader.load(new URLRequest(getPath(idx)));
			}
			
			(numbers_holder.getChildAt(idx) as MovieClip).gotoAndPlay(2);
			if (idx > 0) {
				(numbers_holder.getChildAt(idx - 1) as MovieClip).gotoAndStop(1);
			}
			if (idx == 0) {
				(numbers_holder.getChildAt(numbers_holder.numChildren - 1) as MovieClip).gotoAndStop(1);
			}
			
			//swnd.headtext.x = -swnd.headtext.width - 10;
			swnd.headtext.alpha = 0;
			swnd.headtext.d_text.htmlText = getTitle(idx);
			
			//swnd.desctext.x = swnd.desctext.width + 10;
			swnd.desctext.alpha = 0;
			swnd.desctext.d_text.htmlText = getDescription(idx);
			swnd.desctext.d_text.autoSize = "left";
			swnd.desctext.bg.height = swnd.desctext.d_text.height + 10;
			
			TweenLite.to(swnd.headtext, 1.0, { alpha: 1, delay: 1 } );
			TweenLite.to(swnd.desctext, 1.0, { alpha: 1 , delay: 1} );
			
			if (idx + 1 < xml.images.i.length()) {
				idx++;
			} else {
				idx = 0;
			}
		}
		
		private function getPath(index:uint):String {
			return slideshow.getContentPath() + "/" + xml.images.i[index].filename;
		}
		
		private function getLink(index:uint):String {
			return xml.images.i[index].link;
		}
		
		private function onImageClick(e:MouseEvent):void {
			var i:Number = idx == 0 ? xml.images.i.length() - 1: idx - 1;
			if (getLink(i).length > 0) {
				navigateToURL(new URLRequest(getLink(i)));
			}
		}
		
		//Text
		
		private function getTitle(index:uint):String {
			return xml.images.i[index].title;
		}
		
		private function getDescription(index:uint):String {
			return xml.images.i[index].description;
		}
		
		//Numbers
		
		private function initNumbers():void {
			var ax:Number = 0;
			
			numbers_holder = new TSprite();
			
			for (var i:uint = 0; i < xml.images.i.length(); i++) {
				var n:ssnumber = new ssnumber();
				n.x = ax;
				n.id = i;
				n.anim.d_text.text = String(i + 1);
				n.anim.d_text.autoSize = "left";
				n.mouseChildren = false;
				n.buttonMode = true;
				
				ax += n.width + 10;
				
				numbers_holder.addChild(n);
				
				n.addEventListener(MouseEvent.CLICK, onClick);
			}
			
			numbers_holder.x = Math.round(swnd.buttons.bg.width / 2 - numbers_holder.width / 2);
			numbers_holder.y = Math.round(swnd.buttons.bg.height / 2 - numbers_holder.height / 2) + 0;
			swnd.buttons.addChild(numbers_holder);
			
			swnd.buttons.left_arrow.x = numbers_holder.x - 19;
			swnd.buttons.right_arrow.x = numbers_holder.x + numbers_holder.width + 14;
			
			swnd.buttons.left_arrow.mouseChildren = false;
			swnd.buttons.left_arrow.buttonMode = true;
			swnd.buttons.left_arrow.addEventListener(MouseEvent.CLICK, onLeftArrowClick);
			
			swnd.buttons.right_arrow.mouseChildren = false;
			swnd.buttons.right_arrow.buttonMode = true;
			swnd.buttons.right_arrow.addEventListener(MouseEvent.CLICK, onRightArrowClick);
		}
		
		private function onClick(e:MouseEvent):void {
			var tidx = idx;
			idx = (e.target as ssnumber).id;
			try {
				(numbers_holder.getChildAt(tidx - 1) as MovieClip).gotoAndStop(1);
			} catch (e:Error) {
				
			}
			
			loadNext();
			rotate();
		}
		
		private function onLeftArrowClick(e:MouseEvent):void {
			var tidx = idx;
			
			try {
				(numbers_holder.getChildAt(tidx - 1) as MovieClip).gotoAndStop(1);
			} catch (e:Error) {
				
			}
			
			if (idx == 0) {
				idx = xml.images.i.length() - 2;
				(numbers_holder.getChildAt(xml.images.i.length() - 1) as MovieClip).gotoAndStop(1);
			} else if (idx > 1) {
				idx -= 2;
			} else {
				idx = xml.images.i.length() - 1;
			}
			
			
			loadNext();
			rotate();
		}
		
		private function onRightArrowClick(e:MouseEvent):void {
			var tidx = idx;
			
			try {
				(numbers_holder.getChildAt(tidx - 1) as MovieClip).gotoAndStop(1);
			} catch (e:Error) {
				
			}
			if (idx < xml.images.i.length()) {
				
			} else {
				idx = 0;
			}
			
			loadNext();
			rotate();
		}
		
	}
	
}