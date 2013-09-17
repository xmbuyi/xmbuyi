package  
{
	import com.tomez.imagegallery.ImageGallery;
	import com.tomez.imagegallery.Thumbnail;
	import com.tomez.StageSetup;
	import com.tomez.TSprite;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Tomez
	 */
	public class hgallery extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private static var stageref:Stage;
		
		private var xmldoc:XML;
		private var loader:URLLoader;
		
		private static var contentPath:String;
		
		private var img_gallery:ImageGallery;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function hgallery() 
		{
			if (stage != null) {
				init("../../content/horizontal-gallery/3dabstract");
				
			}
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onComplete(e:Event):void {
			trace("xml: ok");
			xmldoc = new XML(loader.data);
			
			img_gallery = new ImageGallery(xmldoc);
			addChild(img_gallery);
		}
		
		private function onIOError(e:IOErrorEvent):void {
			trace(e);
		}
		
		// METHODS ________________________________________________________________________________________
		
		public function init(path:String):void {
			
			contentPath = path;
			
			if (stage != null) {
				stageref = stage;
			} else {
				stageref = getDefinitionByName("main").getStage();
			}
			var stageSetup:StageSetup = new StageSetup(stageref);
			
			// load xml
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(new URLRequest(contentPath + "/content.xml"));
		}
		
		public static function getContentPath():String {
			return contentPath;
		}
		
		public static function getStage():Stage {
			return stageref;
		}
		
		public function destroy():void {
			removeAllEventListeners(true);
			img_gallery.destroy();
			img_gallery = null;
		}
		
	}
	
}