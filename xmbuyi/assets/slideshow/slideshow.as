package  
{
	import com.tomez.StageSetup;
	import com.tomez.TSprite;
	import com.tomez.ImageRotator.imageRotator;
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
	public class slideshow extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private static var stageref:Stage;
		
		private var xmldoc:XML;
		private var loader:URLLoader;
		
		private var swnd:slideshowwindow;
		
		private static var contentPath:String;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function slideshow() 
		{
			if (stage != null) {
				init("../../content/slideshow/");
			}
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onStageResize(e:Event):void {
			try {
				swnd.x = stage.stageWidth / 2 - swnd.width / 2;
				swnd.y = getDefinitionByName("main").stageRect.height / 2 - swnd.height / 2;
			} catch (e:Error) {
				swnd.x = stage.stageWidth / 2 - swnd.width / 2;
				swnd.y = stage.stageHeight / 2 - swnd.height / 2;
			}
		}
		
		private function onComplete(e:Event):void {
			trace("xml: ok");
			xmldoc = new XML(loader.data);
			
			initSlideshow();
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
			
			stageref.addEventListener(Event.RESIZE, onStageResize);
			
			// load xml
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(new URLRequest(contentPath + "/content.xml"));
		}
		
		private function initSlideshow():void {
			
			try {
				getDefinitionByName("main").hideLoader(getDefinitionByName("main").getContent().startTransition);
			} catch (e:Error) { };
			
			swnd = new slideshowwindow();
			onStageResize(null);
			var ir = new imageRotator(xmldoc, swnd);
			swnd.holder.addChild(ir);
			addChild(swnd);
			
		}
		
		public static function getContentPath():String {
			return contentPath;
		}
		
		public static function getStage():Stage {
			return stageref;
		}
		
		public function destroy():void {
			stageref.removeEventListener(Event.RESIZE, onStageResize);
			
			removeAllEventListeners(true);
		}
		
	}
	
}