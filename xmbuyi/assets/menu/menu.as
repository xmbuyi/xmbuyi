package  
{
	import com.tomez.menu.MenuHolder;
	import com.tomez.menu.MenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	
	/**
	* ...
	* @author Tomez
	*/
	public class menu extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		//only for testing!!!
		private var test_menu:XML = <menu startContent="home" paddingLeft="0.8" controlButtonsPaddingRight="0.8">
			<m>
				<text>Home</text>
				<content>assets/slideshow/slideshow.swf</content>
				<content_path>content/slideshow</content_path>
				<transition>LeftToRight</transition>
				<deepLink>home</deepLink>
				<submenu>
					<m>
						<text>Welcome</text>
						<content>assets/text/text.swf</content>
						<content_path>content/text/welcome</content_path>
						<content_handle_loader>true</content_handle_loader>
						<bg isPattern="true">content/text/simple page/bg1.gif</bg>
						<transition>Zoom</transition>
						<deepLink>welcome</deepLink>
					</m>
				</submenu>
			</m>
			<m>
				<text>Image Gallery</text>
				<content>assets/gallery/gallery.swf</content>
				<content_path>content/gallery/3dabstract</content_path>
				<content_handle_loader>true</content_handle_loader>
				<deepLink>image-gallery</deepLink>
				<submenu>
					<m>
						<text>Nature</text>
						<content>assets/gallery/gallery.swf</content>
						<content_path>content/gallery/nature_wm</content_path>
						<content_handle_loader>true</content_handle_loader>
						<deepLink>nature</deepLink>
					</m>
					<m>
						<text>Animals</text>
						<content>assets/gallery/gallery.swf</content>
						<content_path>content/gallery/animals_wm</content_path>
						<content_handle_loader>true</content_handle_loader>
						<deepLink>animals</deepLink>
					</m>
					<m>
						<text>Architecture</text>
						<content>assets/gallery/gallery.swf</content>
						<content_path>content/gallery/architecture_wm</content_path>
						<content_handle_loader>true</content_handle_loader>
						<deepLink>architecture</deepLink>
					</m>
				</submenu>
			</m>
			<m>
				<text>Horizontal Gallery</text>
				<content>assets/hgallery/hgallery.swf</content>
				<content_path>content/horizontal-gallery/3dabstract</content_path>
				<deepLink>horizontal-gallery</deepLink>
			</m>
			<m>
				<text>Video Gallery</text>
				<content>assets/gallery/gallery.swf</content>
				<content_path>content/video/gallery1</content_path>
				<content_handle_loader>true</content_handle_loader>
				<deepLink>video-gallery</deepLink>
				<submenu>
					<m>
						<text>Gallery 1</text>
						<content>assets/gallery/gallery.swf</content>
						<content_path>content/video/gallery1</content_path>
						<content_handle_loader>true</content_handle_loader>
						<deepLink>gallery-1</deepLink>
					</m>
					<m>
						<text>Gallery 2</text>
						<content>assets/gallery/gallery.swf</content>
						<content_path>content/video/gallery1</content_path>
						<content_handle_loader>true</content_handle_loader>
						<deepLink>gallery-2</deepLink>
					</m>
					<m>
						<text>Gallery 3</text>
						<content>assets/gallery/gallery.swf</content>
						<content_path>content/video/gallery1</content_path>
						<content_handle_loader>true</content_handle_loader>
						<deepLink>gallery-3</deepLink>
					</m>
				</submenu>
			</m>
			<m>
				<text>Video Player</text>
				<content>assets/video player/videoplayer.swf</content>
				<content_path>content/video/sample1/CLOUD 4.flv</content_path>
				<deepLink>video</deepLink>
			</m>
			<m>
				<text>Text</text>
				<content>assets/text/text.swf</content>
				<content_path>content/text/simple page</content_path>
				<content_handle_loader>true</content_handle_loader>
				<bg isPattern="true">content/text/simple page/bg1.gif</bg>
				<transition>LeftToRight</transition>
				<deepLink>text</deepLink>
				<submenu>
					<m>
						<text>Basic Resizable Page Sample</text>
						<content>assets/text/text.swf</content>
						<content_path>content/text/basic page</content_path>
						<content_handle_loader>true</content_handle_loader>
						<transition>CircleZoom</transition>
						<deepLink>basic-page</deepLink>
					</m>
					<m>
						<text>Two-Column Resizable Page Sample</text>
						<content>assets/text/text.swf</content>
						<content_path>content/text/two column page</content_path>
						<content_handle_loader>true</content_handle_loader>
						<transition>BottomToTop</transition>
						<deepLink>two-column-page</deepLink>
					</m>
					<m>
						<text>Three-Column Resizable Page Sample</text>
						<content>assets/text/text.swf</content>
						<content_path>content/text/three column page</content_path>
						<content_handle_loader>true</content_handle_loader>
						<transition>LeftToRight</transition>
						<deepLink>three-column-page</deepLink>
					</m>
					<m>
						<text>Text with Images Sample</text>
						<content>assets/text/text.swf</content>
						<content_path>content/text/image sample</content_path>
						<content_handle_loader>true</content_handle_loader>
						<transition>CircleZoom</transition>
						<deepLink>text-with-images</deepLink>
					</m>
					<m>
						<text>Vertical Image Gallery</text>
						<content>assets/text/text.swf</content>
						<content_path>content/text/image sample 2</content_path>
						<content_handle_loader>true</content_handle_loader>
						<transition>CircleZoom</transition>
						<deepLink>vertical-image-gallery</deepLink>
					</m>
					<m>
						<text>Vertical Image Gallery 2</text>
						<content>assets/text/text.swf</content>
						<content_path>content/text/image sample 3</content_path>
						<content_handle_loader>true</content_handle_loader>
						<transition>CircleZoom</transition>
						<deepLink>vertical-image-gallery-2</deepLink>
					</m>
					<m>
						<text>Dynamic Layout</text>
						<content>assets/text/text.swf</content>
						<content_path>content/text/dynamic</content_path>
						<content_handle_loader>true</content_handle_loader>
						
						<transition>TopToBottom</transition>
						<deepLink>Dynamic-Layout</deepLink>
					</m>
					<m>
						<text>Dynamic Layout with bg</text>
						<content>assets/text/text.swf</content>
						<content_path>content/text/dynamic</content_path>
						<content_handle_loader>true</content_handle_loader>
						<bg isPattern="true">content/text/dynamic/pattern.gif</bg>
						<transition>TopToBottom</transition>
						<deepLink>Dynamic-Layout-with-Background</deepLink>
					</m>
				</submenu>
			</m>
			<m>
				<text>Contact</text>
				<content>assets/contact/contact.swf</content>
				<content_path>assets/contact/assets/</content_path>
				<content_handle_loader>true</content_handle_loader>
				<transition>RightToLeft</transition>
				<deepLink>contact</deepLink>
			</m>
			<m>
				<text>More Features</text>
				<content>content/gallery/3dabstract/w720/abstract04.jpg</content>
				<align>center</align>
				<deepLink>more-features</deepLink>
				<submenu>
					<m>
						<text>Single External Image Page</text>
						<content>content/gallery/3dabstract/w720/abstract04.jpg</content>
						<align>center</align>
						<deepLink>single-external-image-page</deepLink>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
					<m>
						<text>Just for auto scroll</text>
					</m>
				</submenu>
			</m>
		</menu>;
		// --- end of test xml ---
		
		private static var stageref:Stage;
		
		private var m:MenuHolder;
		
		private var source:XMLList;
		
		private var path:String;
		
		private var _height:uint = 56;
		
		public static var lastPressed:MenuItem = null;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function menu() 
		{
			if (stage != null) {
				stageref = stage;
			} else {
				stageref = getDefinitionByName("main").getStage();
			}

			if (stage != null) {
				init(new XMLList(test_menu));
			}
		}
		
		// METHODS ________________________________________________________________________________________
		
		public function init(source:XMLList):void {
			this.source = source;
			this.path = "assets/menu/";
			
			m = new MenuHolder(source);
			addChild(m);
		}
		
		public function setSelectedItem(id:Number, subitem_id:Number):void {
			if (subitem_id == -1) {
				m.getItem(id).makeSelected();
			} else {
				m.getItem(id).getSubmenuItem(subitem_id).makeSelected();
			}
		}
		
		public function getHeight():uint {
			return _height;
		}
		
		public static function getStage():Stage {
			return stageref;
		}
		
	}
	
}