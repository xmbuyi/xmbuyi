package  
{
	import br.com.stimuli.loading.BulkErrorEvent;
	import com.tomez.Background;
	import com.tomez.GridLayout.GridLayout;
	import com.tomez.scroll.PageScroll;
	import com.tomez.StageSetup;
	import com.tomez.TSprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	import br.com.stimuli.loading.BulkLoader;
	
	/**
	* ...
	* @author Tomez
	*/
	public class text extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private static var stageref:Stage;
		
		private var xmldoc:XML;
		private var loader:URLLoader;
		
		private static var contentPath:String;
		
		private var grid:GridLayout;
		
		private var scroll:PageScroll;
		
		private var exloader:BulkLoader;
		
		public static var useEmbedFont:Boolean = false;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function text() 
		{
			if (stage != null) {
				init("../../content/text/basic page");
			}
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onStageResize(e:Event):void {
			grid.y = 0;
			
			try {
				scroll.resize(getDefinitionByName("main").stageRect.height);
			} catch (e:Error) {
				scroll.resize(stageref.stageHeight);
			}
			scroll.x = stageref.stageWidth - scroll.width;
		}
		
		private function onComplete(e:Event):void {
			trace("xml: ok");
			xmldoc = new XML(loader.data);

			useEmbedFont = xmldoc.text.@embedFonts == "true";
			
			loadExternals();
		}
		
		private function onIOError(e:IOErrorEvent):void {
			trace(e);
		}
		
		private function onAllLoaded(e:Event):void {
			
			trace("Externals loaded.");
			
			initGridLayout();
		}
		
		private function onError(evt:BulkErrorEvent):void {
			trace("an error ocurred when loading");
			for each (var loadingItem:* in evt.errors) {
				trace(loadingItem, "has failed to load");
			}
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
		
		private function initGridLayout():void {
			
			try {
				getDefinitionByName("main").hideLoader(getDefinitionByName("main").getContent().startTransition);
			} catch (e:Error) { };
			
			grid = new GridLayout(stage, xmldoc.text);
			
			grid.resize();
			
			addChild(grid);
			
			scroll = new PageScroll(grid, stageref.stageHeight);
			
			scroll.x = stageref.stageWidth - scroll.width;
			addChild(scroll);
			
			try {
				scroll.resize(getDefinitionByName("main").stageRect.height);
			} catch (e:Error) {
				scroll.resize(stageref.stageHeight);
			}
		}
		
		private function loadExternals():void {
			
			exloader = new BulkLoader("exloader");
			
			var list:XMLList = xmldoc..block..imageblock;
			
			var ar:Array = new Array();
			
			for each(var item:XML in list) {
				var filename:String = contentPath + "/" + item.@src.toString();
				if (ar.indexOf(filename) == -1) {
					exloader.add(filename, {id:filename });
					ar.push(filename);
				}
			}
			//trace(ar);
			if (ar.length > 0) {
				exloader.addEventListener(BulkLoader.COMPLETE, onAllLoaded);
				exloader.addEventListener(BulkLoader.ERROR, onError);
				exloader.start();
			} else {
				initGridLayout();
			}
			
		}
		
		public static function getContentPath():String {
			return contentPath;
		}
		
		public static function getStage():Stage {
			return stageref;
		}
		
		public function destroy():void {
			stageref.removeEventListener(Event.RESIZE, onStageResize);
			
			exloader.clear();
			exloader = null;
			
			grid.removeAllEventListeners(true);
			grid.cleanup();
			
			removeAllEventListeners(true);
			grid = null;
		}
		
	}
	
}