package com.tomez.imagegallery 
{
	import com.tomez.TSprite;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Tomez
	*/
	public class Controller extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var holder:TSprite;
		
		private var pageOf:Button;
		
		private var ax:Number;
		private var ay:Number;
		
		private var len:uint;
		
		private var currentPage:uint = 0;
		
		public function Controller(numOfPages:uint) 
		{
			this.len = numOfPages;
			
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onClick(e:MouseEvent):void {
			if (currentPage != e.target.id) {
				currentPage = e.target.id;
				showPage(currentPage);
			}
		}
		
		private function onPrev(e:MouseEvent):void {
			if (currentPage > 0) {
				currentPage--;
				showPage(currentPage);
			}
		}
		
		private function onNext(e:MouseEvent):void {
			if (currentPage < len - 1) {
				currentPage++;
				showPage(currentPage);
			}
		}
		
		private function showPage(n:uint):void {
			pageOf.text = "Page " + (currentPage + 1) + " of " + len;
			dispatchEvent(new PageEvent("Show Page", n, true));
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			
			holder = new TSprite();
			build();
			
			addChild(holder);
		}
		
		private function build():void {
			
			ax = 0;
			ay = 0;
			
			buildPageOf();
			buildPrev();
			buildNumbers();
			buildNext();
		}
		
		private function buildPageOf():void {
			pageOf = new Button("Page 1 of " + len, 0x0099ff, 0x000000);
			pageOf.removeListeners();
			holder.addChild(pageOf);
			
			ax += pageOf.width + 5;
		}
		
		private function buildPrev():void {
			var button:Button = new Button("Prev");
			button.x = ax;
			holder.addChild(button);
			
			ax += button.width + 5;
			
			button.addEventListener(MouseEvent.CLICK, onPrev);
		}
		
		private function buildNext():void {
			var button:Button = new Button("Next");
			button.x = ax;
			holder.addChild(button);
			
			ax += button.width + 5;
			
			button.addEventListener(MouseEvent.CLICK, onNext);
		}
		
		private function buildNumbers():void {
			var i:uint;
			
			for (i = 0; i < len; i++) {
				var button:Button = new Button(String(i + 1));
				button.id = i;
				button.x = ax;
				button.y = ay;
				
				ax += button.width + 5;
				
				holder.addChild(button);
				
				button.addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
	}
	
}