package com.tomez.imagegallery 
{
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
		
		private var controller:Controller;
		private var maxImagesPerPage:uint = 20;
		
		private var bigScreen:BigScreen;
		
		private var xml:XML;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function ImageGallery(xml:XML) 
		{
			this.xml = xml;
			
			init(xml);
		}
		
		private function onResize(e:Event):void {
			holder.x = Math.round(gallery.getStage().stageWidth / 2 - holder.visibleWidth / 2);
			try {
				holder.y = Math.round(getDefinitionByName("main").stageRect.height / 2 - holder.visibleHeight / 2);
			} catch (e:Error) {
				holder.y = Math.round(gallery.getStage().stageHeight / 2 - holder.visibleHeight / 2);
			}
			
			holder.reset();
			holder.setVariables();
			
			if (controller) {
				controller.x = Math.round(gallery.getStage().stageWidth / 2 - controller.width / 2);
				controller.y = holder.y + holder.visibleHeight + 60;
			}
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init(xml:XML):void {
			holder = new ThumbnailsHolder(xml);
			holder.x = Math.round(gallery.getStage().stageWidth / 2 - holder.visibleWidth / 2);
			try {
				holder.y = Math.round(getDefinitionByName("main").stageRect.height / 2 - holder.visibleHeight / 2);
			} catch (e:Error) {
				holder.y = Math.round(gallery.getStage().stageHeight / 2 - holder.visibleHeight / 2);
			}
			holder.addEventListener("Thumbs Loaded", initController);
			addChild(holder);
			
			gallery.getStage().addEventListener(Event.RESIZE, onResize);
		}
		
		private function initBigScreen():void {
			bigScreen = new BigScreen();
			
			addChild(bigScreen);
		}
		
		private function initController(e:Event):void {
			var len:uint = xml.images.i.length();
			var numOfPages:uint = len % maxImagesPerPage == 0 ? len/maxImagesPerPage : 1 + Math.floor(len/maxImagesPerPage);
			
			if (numOfPages > 1) {
				controller = new Controller(numOfPages);
			
				controller.x = Math.round(gallery.getStage().stageWidth / 2 - controller.width / 2);
				try {
					controller.y = getDefinitionByName("main").stageRect.height + 100;
				} catch (e:Error) {
					controller.y = gallery.getStage().stageHeight + 100;
				}
				
				addChild(controller);
				
				TweenLite.to(controller, 0.5, { y:(holder.y + holder.visibleHeight + 60), delay:0.85, ease:Elastic.easeOut, easeParams:[1.5, 2.05] } );
			}
			
			addEventListener("Show Page", holder.showPage);
				
			initBigScreen();
			
			holder.addEventListener("Thumb Click", bigScreen.show);
			
			try {
				getDefinitionByName("main").hideLoader(getDefinitionByName("main").getContent().showContent);
			} catch (e:Error) { };
		}
		
		public function destroy():void {
			gallery.getStage().removeEventListener(Event.RESIZE, onResize);
			removeChild(holder);
			holder = null;
			
			removeChild(controller);
			controller = null;
			
			removeChild(bigScreen);
			bigScreen.destroy();
			bigScreen = null;
		}
		
	}
	
}