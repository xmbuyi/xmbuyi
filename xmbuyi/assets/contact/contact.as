package  
{
	import com.tomez.contact.Contact;
	import com.tomez.StageSetup;
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	/**
	* ...
	* @author Tomez
	*/
	public class contact extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var bg:TSprite;
		
		private static var contentPath:String;
		
		private var loader:Loader;
		
		private var image:Bitmap;
		
		private var c:Contact;
		
		private var stageref:Stage;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function contact() 
		{
			if (stage != null) {
				stageref = stage;
			} else {
				stageref = getDefinitionByName("main").getStage();
			}
			
			var stageSetup:StageSetup = new StageSetup(stageref);
			
			if (stage != null) {
				init("assets/");
			}
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onResize(e:Event):void {
			drawBg();
			
			c.x = stageref.stageWidth / 2 - c.width / 2;
			
			try {
				c.y = getDefinitionByName("main").stageRect.height / 2 - c.height / 2;
			} catch(e:Error) {
				c.y = stageref.stageHeight / 2 - c.height / 2;
			}
		}
		
		private function onComplete(e:Event):void {
			image = loader.content as Bitmap;
			
			build();
			
			try {
				getDefinitionByName("main").hideLoader(getDefinitionByName("main").getContent().startTransition);
			} catch (e:Error) { };
		}
		
		private function onIOError(e:IOErrorEvent):void {
			
		}
		
		// METHODS ________________________________________________________________________________________
		
		public function init(path:String):void {
			
			contentPath = path;
			
			loadAssets();
			
		}
		
		private function build():void {
			bg = new TSprite();
			drawBg();
			addChild(bg);
			
			c = new Contact(image, stage);
			
			c.x = stageref.stageWidth / 2 - c.width / 2;
			try {
				c.y = getDefinitionByName("main").stageRect.height / 2 - c.height / 2;
			} catch(e:Error) {
				c.y = stageref.stageHeight / 2 - c.height / 2;
			}
			addChild(c);
			
			stageref.addEventListener(Event.RESIZE, onResize);
		}
		
		private function loadAssets():void {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(new URLRequest(contentPath + "contact_image.png"));
		}
		
		private function drawBg():void {
			bg.graphics.clear();
			bg.graphics.beginFill(0x111111);
			bg.graphics.drawRect(0, 0, stageref.stageWidth, stageref.stageHeight);
			bg.graphics.endFill();
		}
		
		public function destroy():void {
			stageref.removeEventListener(Event.RESIZE, onResize);
			c.removeAllEventListeners(true);
		}
		
	}
	
}