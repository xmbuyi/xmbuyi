package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	public class loader extends Sprite {
		
		// PROPERTIES _____________________________________________________________________________________
		
		private var holder:Sprite;
		
		private var bmpData:BitmapData = new BitmapData(300, 300, true, 0x000000);
		private var bmp:Bitmap = new Bitmap(bmpData);
		
		private var bf:BlurFilter = new BlurFilter(4, 4, 3);
		private var matrix:Array = new Array();

		private var cmt:ColorMatrixFilter = new ColorMatrixFilter();
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function loader() {
			
			init();
			addChild(bmp);
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onEnterFrame(e:Event):void {
			holder.rotation += 23;
			bmpData.draw(this);
			bmpData.applyFilter(bmpData, bmpData.rect, new Point(0, 0), bf);
			bmpData.applyFilter(bmpData, bmpData.rect, new Point(0, 0), cmt);
			bmpData.scroll(0, -5);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {			
			matrix = matrix.concat([1, 0, 0, 0, 0]); // red
            matrix = matrix.concat([0, 1, 0, 0, 0]); // green
            matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 0.5, 0]); // alpha
			cmt.matrix = matrix;
			
			holder = new Sprite();
			
			draw();
			
			addChild(holder);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function draw():void {
			drawAroundCircle(0, 0, 18, 20);
			holder.x = 150 - 18 / 2;
			holder.y = 150 - 18 / 2;
		}
		
		private function drawSquare(target:*):void {
			target.graphics.beginFill(0x0099ff);
			target.graphics.drawRoundRect(-2, -2, 4, 4, 4);
			target.graphics.endFill();
		}
		
		private function drawAroundCircle(centerX:Number, centerY:Number, radius:Number, sides:Number){
			
			var ax:Number = centerX + radius;
			var ay:Number = centerY;
			
			var s:Sprite = new Sprite();
			drawSquare(s);
			s.x = ax;
			s.y = ay;
			holder.addChild(s);
			
			for(var i:Number=0; i<=sides; i++){
				
				var pointRatio:Number = i/sides;
				
				var xSteps:Number = Math.cos(pointRatio*2*Math.PI);
				var ySteps:Number = Math.sin(pointRatio*2*Math.PI);
				
				var pointX:Number = centerX + xSteps * radius;
				var pointY:Number = centerY + ySteps * radius;
				
				s = new Sprite();
				drawSquare(s);
				
				s.scaleX = s.scaleY = i/20;
				s.x = pointX;
				s.y = pointY;

				holder.addChild(s);
				
			}
		}
		
		private function randRange(min:Number, max:Number):Number {
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}

	}
}