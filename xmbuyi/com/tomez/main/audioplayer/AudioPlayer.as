package com.tomez.main.audioplayer 
{
	import com.tomez.TSprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Tomez
	*/
	public class AudioPlayer extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var manager:AudioManager;
		
		private var skin:Skin;
		
		private var _stage:Stage;
		
		private var xml:XMLList;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function AudioPlayer(stage:Stage, xml:XMLList) 
		{
			this._stage = stage;
			this.xml = xml;
			
			init();
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			manager = new AudioManager();
			
			skin = new Skin(_stage, xml, this);
			addChild(skin);
		}
		
	}
	
}