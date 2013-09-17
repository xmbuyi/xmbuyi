package com.tomez.menu
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	import gs.TweenLite;
	
	public class MenuItem extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________

		private var text:String;
		private var color:Number;
		private var roll_over_color:Number;
		private var contentURL:String;
		private var linkURL:String;
		
		private var ax:int = -1;
		private var ay:int = -3;
		
		private var holder:Sprite;
		private var button:mbutton;
		
		private var submenu:SubMenu;
		private var hasSubMenu:Boolean = false;
		public var pressedSubmenu:SubMenuItem = null;
		
		private var _parent:Object;
		
		private var _stage:Stage;
		
		private var xml:XML;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function MenuItem(xml:XML, obj:Object, _parent:Object) 
		{
			this.xml = xml;
			this._parent = _parent;
			
			holder = new Sprite();
			
			this._stage = getDefinitionByName("menu").getStage();
			
			hasSubMenu = obj.sub_items.length() > 0;
			
			init(xml.text, obj);
			
			addChild(holder);
			
			if (hasSubMenu) {
				initSubMenu(obj);
			}
		}
		
		// EVENTS _________________________________________________________________________________________
		
		public function makeSelected():void {
			
			if (menu.lastPressed != null) {
				//submenu deselect
			
				var tsubp:SubMenuItem = menu.lastPressed.pressedSubmenu;
				
				menu.lastPressed.pressedSubmenu = null;
				
				try {
					if (tsubp) tsubp.mouseOut(null);
				} catch (e:Error) {}
				
				//
				
				var tp:* = menu.lastPressed;
					
				menu.lastPressed = null;
			
				try {
					if (tp) tp.mouseOut(null);
				} catch (e:Error) { }
				
				menu.lastPressed = this;
				
				makeSelected2();
			} else {
				menu.lastPressed = this;
				
				makeSelected2();
			}
		}
		
		public function makeSelected2():void {
			TweenLite.to(button.text, 0.2, { tint: roll_over_color } );
		}
		
		private function onClick(e:MouseEvent):void {
			
			if(linkURL == "") {
				
				if (menu.lastPressed != this || pressedSubmenu != null) {
					
					holder.buttonMode = false;
					
					if (hasSubMenu) {
						TweenLite.to(submenu, 0.2, { alpha: 0, onComplete:onTweenComplete } );
					}
					
					//content.loadContentByXml(xml);
					getDefinitionByName("main").getSWFAddress().setValue(xml.deepLink);
				}
			} else {
				navigateToURL(new URLRequest(linkURL), "_blank");
			}
		}
		
		private function mouseDown(e:MouseEvent):void {
			if (menu.lastPressed != this) {
				
			}
		}
		
		private function mouseUp(e:MouseEvent):void {
			if (menu.lastPressed != this) {
				
			}
		}
		
		private function mouseOver(e:MouseEvent):void {
			
			if (menu.lastPressed != this || pressedSubmenu != null) {
				TweenLite.to(button.text, 0.2, { tint: roll_over_color } );
				
				holder.buttonMode = true;
			} else {
				holder.buttonMode = false;
			}
			
			if (hasSubMenu) {
				submenu.reset();
				submenu.visible = true;
				TweenLite.to(submenu, 0.1, { alpha: 1 } );
			}
		}
		
		public function mouseOut(e:Event):void {
			
			if (menu.lastPressed != this) {
				TweenLite.to(button.text, 0.3, { tint: null } );
			}
			
			closeSubMenu(null);
		}
		
		private function onTweenComplete():void {
			submenu.visible = false;
		}
		
		private function mouseOut2(e:Event):void {
			if (mouseX < 0 || mouseX > submenu.width || mouseY > (submenu.y + submenu.getHeight())) {
				mouseOut(null);
			}
			if (mouseY < 50 && mouseX > getWidth()) {
				mouseOut(null);
			}
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function initSubMenu(obj:Object):void {
			submenu = new SubMenu(obj.sub_items, this);
			
			submenu.x = 0;
			submenu.y = 40;
			submenu.visible = false;
			submenu.alpha = 0;
			addChild(submenu);
			
			submenu.addEventListener("Close SubMenu", closeSubMenu);
		}
		
		private function closeSubMenu(e:Event):void {
			if (hasSubMenu) {
				TweenLite.to(submenu, 0.2, { alpha: 0, onComplete:onTweenComplete } );
			}
		}
		
		private function init(text:String, obj:Object):void {
			
			this.text = text;
			
			if(obj == null) {
				color = 0xcccccc;
				roll_over_color = 0xffffff;
			} else {
				color = obj.color;
				roll_over_color = obj.rollover_color;
				contentURL = obj.content ? obj.content : null;
				linkURL = obj.link != "" ? obj.link : "";
			}
			
			drawButton(text, color);
			
			holder.buttonMode = true;
			holder.mouseChildren = false;
			
			holder.addEventListener(MouseEvent.CLICK, onClick);
			holder.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			holder.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			holder.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			if (hasSubMenu) {
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseOut2);
			} else {
				holder.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			}
		}
		
		private function drawButton(text:String, color:Number):void {
			
			button = new mbutton();
			button.text.d_text.htmlText = text;			
			button.text.d_text.autoSize = "left";
			button.bg.width = Math.round(button.text.d_text.width + 30);
			button.text.x = Math.round(button.bg.width / 2 - button.text.d_text.width / 2);
			
//			button.x = Math.round(bg.width/2-tf.textWidth/2)+ax;
//			button.y = Math.round(bg.height/2-tf.textHeight/2)+ay;
			
			holder.addChild(button);
		}
		
		public function getSubmenuItem(id:Number):SubMenuItem {
			return submenu.getItem(id);
		}
		
		public function getWidth():Number {
			return holder.width;
		}
		
	}
	
}