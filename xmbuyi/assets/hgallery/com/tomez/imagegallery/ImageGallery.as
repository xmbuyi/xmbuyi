package com.tomez.imagegallery 
{
	import com.tomez.scroll.GalleryScroll;
	import com.tomez.TSprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import gs.TweenLite;
	import gs.easing.*;
	
	/**
	* ...
	* @author Tomez
	*/
	public class ImageGallery extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var holder:ThumbnailsHolder;
		
		private var xml:XML;
		
		private var sc:GalleryScroll;
		
		private var default_height:Number = 395.2;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function ImageGallery(xml:XML) 
		{
			this.xml = xml;
			
			init(xml);
		}
		
		private function onResize(e:Event):void {
			try {
				holder.y = Math.round(getDefinitionByName("main").stageRect.height / 2 - holder.height / 2);
				if (sc) {
					sc.resize(getDefinitionByName("main").stageRect.height, getDefinitionByName("main").stageRect.width);
				}
			} catch (e:Error) {
				holder.y = Math.round(hgallery.getStage().stageHeight / 2 - holder.height / 2);
				if (sc) {
					sc.resize(hgallery.getStage().stageHeight, hgallery.getStage().stageWidth);
				}
			}
			//trace(holder.height);
			
			holder.reset();
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init(xml:XML):void {
			holder = new ThumbnailsHolder(xml);
			try {
				holder.y = Math.round(getDefinitionByName("main").stageRect.height / 2 - default_height / 2);
			} catch(e:Error) {
				holder.y = Math.round(hgallery.getStage().stageHeight / 2 - default_height / 2);
			}
			
			holder.addEventListener("Thumbs Loaded", onThumbsLoaded);
			holder.addEventListener("needResize", onResize);
			addChild(holder);
			
			hgallery.getStage().addEventListener(Event.RESIZE, onResize);
		}
		
		private function onThumbsLoaded(e:Event):void {
			onResize(null);
			
			try {
				getDefinitionByName("main").hideLoader(getDefinitionByName("main").getContent().startTransition);
			} catch (e:Error) { };
			
			initScroll();
		}
		
		private function initScroll():void {
			try {
				sc = new GalleryScroll(holder, getDefinitionByName("main").stageRect.width, getDefinitionByName("main").stageRect.height);
			} catch (e:Error) {
				sc = new GalleryScroll(holder, hgallery.getStage().stageWidth, hgallery.getStage().stageHeight);
			}
			
			onResize(null);
			addChild(sc);
		}
		
		public function destroy():void {
			hgallery.getStage().removeEventListener(Event.RESIZE, onResize);
			removeChild(holder);
			holder = null;
		}
		
	}
	
}