package com.tomez.main 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getDefinitionByName;
	
	/**
	* ...
	* @author Tomez
	*/
	public class RightClickMenu 
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var cm:ContextMenu;
		
		private var ref:DisplayObjectContainer;
		
		private var _stage:Stage;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function RightClickMenu(ref:DisplayObjectContainer) 
		{
			this.ref = ref;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function menuSelectHandler(e:ContextMenuEvent):void {
			if (_stage.displayState == StageDisplayState.NORMAL) {
				e.target.customItems[0].enabled = true;
				e.target.customItems[1].enabled = false;
			} else {
				e.target.customItems[0].enabled = false;
				e.target.customItems[1].enabled = true;
			}
		}
		
		private function onGoFullScreen(e:ContextMenuEvent):void {
			_stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		private function onExitFullScreen(e:ContextMenuEvent):void {
			_stage.displayState = StageDisplayState.NORMAL;
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			cm = new ContextMenu();
			cm.hideBuiltInItems();
			cm.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
			
			addCustomMenuItems();
			
			_stage = getDefinitionByName("main").getStage();
			
			ref.contextMenu = cm;
		}
		
		private function addCustomMenuItems():void {
			var item:ContextMenuItem = new ContextMenuItem("Go Full Screen");
			var item2:ContextMenuItem = new ContextMenuItem("Exit Full Screen", false, false);
			
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onGoFullScreen);
			item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onExitFullScreen);
			
			cm.customItems.push(item, item2);
		}
		
	}
	
}