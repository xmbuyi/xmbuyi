package com.tomez.menu
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.utils.getDefinitionByName;
	
	public class MenuHolder extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var text_color:Number = 0xcccccc;
		private var text_rollover_color:Number = 0xffffff;
		
		private var ax:uint = 0;
		private var bg:Sprite;
		private var bgWidth:uint;
		
		private var items:XMLList;
		
		private var _stage:Object;
		private var _content:Object;
		
		private var holder:Sprite;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function MenuHolder(source:XMLList) 
		{
			_stage = getDefinitionByName("menu").getStage();
			try {
				_content = getDefinitionByName("main").getContent();
			} catch(e:Error) {
				_content = null;
			}
			
			if (source.m.length() > 0) {
				items = source;
				bgWidth = _stage.stageWidth;
				drawBg();
				buildItems();
				_stage.addEventListener(Event.RESIZE, onResize);
			}
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onResize(e:Event):void {
			bgWidth = _stage.stageWidth;
			
			/*if (items.hasOwnProperty("@paddingLeft")) {
				holder.x = Math.round(_stage.stageWidth / 2 - _stage.stageWidth * Number(items.@paddingLeft) / 2);
			}*/
			holder.x = 5;
		}
		
		
		// METHODS ________________________________________________________________________________________
		
		private function drawBg():void {
			bg = new Sprite();
			addChild(bg);
		}
		
		private function buildItems():void {
			
			holder = new Sprite();
			
			var sh:DropShadowFilter = new DropShadowFilter();
			sh.distance = 1;
			sh.quality = 3;
			
			holder.filters = [sh];
			
			/*if (items.hasOwnProperty("@paddingLeft")) {
				holder.x = Math.round(_stage.stageWidth / 2 - _stage.stageWidth * Number(items.@paddingLeft) / 2);
			}*/
			holder.x = 5;
			
			for (var i:uint = 0; i < items.m.length(); i++) {
				var obj:Object = new Object();
				
				obj.color = text_color;
				obj.rollover_color = text_rollover_color;
				obj.content = items.m[i].content;
				obj.link = items.m[i].link;
				obj.sub_items = items.m[i].submenu;
				obj.ax = holder.x + ax;
				
				var menu:MenuItem = new MenuItem(items.m[i], obj, this);
				menu.x = ax;
				ax += menu.getWidth() + 2;
				holder.addChild(menu);
			}
			
			addChild(holder);
		}
		
		public function getItem(id:Number):MenuItem {
			return (holder.getChildAt(id) as MenuItem);
		}
		
	}
	
}