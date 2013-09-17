package com.tomez.menu 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	import gs.TweenLite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class SubMenuItem extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var format:TextFormat;
		private var tf:TextField;
		
		private var bg:*;
		private var bgColor:Number = 0x222222;
		private var borderColor:Number = 0x000000;
		
		private var bgRollOverColor:Number = 0x999999;
		
		public var itemWidth:uint = 100;
		private var itemHeight:uint = 22;
		
		private var g:submenu;
		
		private var xml:XML;
		
		private var linkURL:String;
		
		private var mi:MenuItem;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function SubMenuItem(xml:XML, mi:MenuItem) 
		{
			this.xml = xml;
			this.mi = mi;
			
			linkURL = xml.link != "" ? xml.link : "";
			
			init(xml.text, xml.content);
		}
		
		// EVENTS _________________________________________________________________________________________
		
		public function makeSelected():void {
			
			if (menu.lastPressed != null) {
				var tp:* = menu.lastPressed;
			
				menu.lastPressed = null;
			
				try {
					if (tp) tp.mouseOut(null);
				} catch (e:Error) { }
				
				//submenu deselect
				
				var tsubp:* = tp.pressedSubmenu;
					
				tp.pressedSubmenu = null;
				
				try {
					if (tsubp) tsubp.mouseOut(null);
				} catch (e:Error) { }
				
				menu.lastPressed = mi;
				
				mi.makeSelected2();
				
				mi.pressedSubmenu = this;
			} else {
				menu.lastPressed = mi;
				
				mi.makeSelected2();
				
				mi.pressedSubmenu = this;
			}
			
			TweenLite.to(bg, 0.1, { tint: bgRollOverColor } );
			TweenLite.to(tf, 0.1, { tint: 0x000000 } );
			
		}
		
		private function onClick(e:MouseEvent):void {
			
			if(linkURL == "") {
				
				if (mi.pressedSubmenu != this) {
					
					buttonMode = false;
					
					//content.loadContentByXml(xml);
					getDefinitionByName("main").getSWFAddress().setValue(xml.deepLink);
					
					dispatchEvent(new Event("Close SubMenu", true));
				}
			} else {
				navigateToURL(new URLRequest(linkURL), "_blank");
			}
		}
		
		private function mouseOver(e:MouseEvent):void {
			if (mi.pressedSubmenu != this) {
				TweenLite.to(bg, 0.1, { tint: bgRollOverColor } );
				TweenLite.to(tf, 0.1, { tint: 0x000000 } );
				
				buttonMode = true;
			} else {
				buttonMode = false;
			}
			
		}
		
		public function mouseOut(e:MouseEvent):void {
			if (mi.pressedSubmenu != this) {
				TweenLite.to(bg, 0.4, { tint: null } );
				TweenLite.to(tf, 0.4, { tint: null } );
			}
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init(text:String, link:String):void {

			// submenu graphics - you can change it in menu.fla
			g = new submenu();
			bg = g.bg;
			
			tf = g.text.d_text;
			tf.autoSize = "left";
			tf.htmlText = text;
			
			addChild(g);
			
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			
			itemWidth = tf.width >= 85 ? tf.width + 12 * 2 : 120;
			
			drawBg();
		}
		
		private function drawBg():void {
			bg.width = itemWidth;
		}
		
		public function redrawBg():void {
			drawBg();
		}
		
		public function clearFirstLine():void {
			bg.graphics.lineStyle(1, bgColor);
			bg.graphics.moveTo(1, 0);
			bg.graphics.lineTo(itemWidth, 0);			
		}
		
	}
	
}