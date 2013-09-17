package com.tomez 
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	* ...
	* @author Tomez
	*/
	public class StageSetup
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var stageref:Stage;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function StageSetup(stage:Stage) 
		{
			stageref = stage;
			
			stageref.align = StageAlign.TOP_LEFT;
			stageref.scaleMode = StageScaleMode.NO_SCALE;
		}
		
	}
	
}