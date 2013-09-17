package com.tomez.videoplayer 
{
	import com.tomez.tooltip.ToolTip;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	* ...
	* @author Tomez
	*/
	public class SoundIcon extends Sprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var holder:Sprite;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function SoundIcon() 
		{
			init();
		}
		
		private function init():void {
			holder = new Sprite();
			holder.addChild(new Bitmap(new img_snd_1(0, 0)));
			holder.addChild(new Bitmap(new img_snd_2(0, 0)));
			holder.addChild(new Bitmap(new img_snd_3(0, 0)));
			holder.addChild(new Bitmap(new img_snd_4(0, 0)));
			holder.addChild(new Bitmap(new img_snd_5(0, 0)));
			
			var i:uint;
			for (i = 1; i < holder.numChildren; i++) {
				holder.getChildAt(i).visible = false;
			}
			
			addChild(holder);
		}
		
		public function setVisible(index:uint):void {
			var i:uint;
			
			for (i = 0; i < holder.numChildren; i++) {
				if (i != index) {
					holder.getChildAt(i).visible = false;
				} else {
					holder.getChildAt(i).visible = true;
				}
			}
			
		}
		
	}
	
}