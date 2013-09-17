package  
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import com.tomez.TSprite;
	import com.tomez.videoplayer.VideoPlayer;
	
	/**
	* ...
	* @author Tomez
	*/
	public class player extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private static var stageref:*;
		
		private var video:VideoPlayer;
		
		private static var contentPath:String;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function player() 
		{
			if (stage != null) {
				init("../../content/video/sample1/CLOUD 4.flv");
			}
		}
		
		private function onResize(e:Event):void {
			video.x = stageref.stageWidth/2 - video.width/2;
			video.y = getDefinitionByName("main").stageRect.height/2 - video.height/2;
		}
		
		// METHODS ________________________________________________________________________________________
		
		public function init(path:String):void {
			
			contentPath = path;
			
			if (stage != null) {
				stageref = stage;
			} else {
				stageref = getDefinitionByName("main").getStage();
			}
			
			stageref.addEventListener(Event.RESIZE, onResize);
			
			video = new VideoPlayer(700, 500);
			video.x = stageref.stageWidth/2 - video.width/2;
			try {
				video.y = getDefinitionByName("main").stageRect.height/2 - video.height/2;
			} catch (e:Error) {
				video.y = stageref.stageHeight/2 - video.height/2;
			}
			addChild(video);
			
			video.playVideo(contentPath);
		}
		
		public static function getStage():Stage {
			return stageref;
		}
		
		public function destroy():void {
			stageref.removeEventListener(Event.RESIZE, onResize);
			video.removeAllEventListeners(true);
			video.destroy();
			video = null;
			removeChild(video);
		}
		
	}
	
}