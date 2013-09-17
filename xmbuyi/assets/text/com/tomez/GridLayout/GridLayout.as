package com.tomez.GridLayout 
{
	import com.tomez.TSprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	* ...
	* @author Tomez
	*/
	public class GridLayout extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var size:Size;
		
		private static var stageref:Stage;
		
		private var xml:XMLList;
		
		private var options:GridLayoutOptions;
		
		private var blocksWidth:WidthCalc;
		
		private var blocks:Array;
		
		private var bg:TSprite;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function GridLayout(stage:Stage, xml:XMLList) 
		{
			stageref = stage;
			stageref.addEventListener(Event.RESIZE, onStageResize);
			
			this.xml = xml;
			//trace(xml);
			
			setOptions();
			//trace(options);
			
			bg = new TSprite();
			
			blocks = new Array();
			build();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onStageResize(e:Event):void {
			resize();
		}
		
		private function onImageBlockLoaded(e:Event):void {
			resize();
		}
		
		// METHODS ________________________________________________________________________________________
		
		
		private function build():void {
			calculateBlocksWidth();
			buildBlocks();
			
			
			// draw background
			drawBg();
			addChildAt(bg, 0);
		}
		
		private function calculateBlocksWidth():void {
			var i:uint;
			var len:uint = xml.block.length();
			var block_width:Number;
			var xml_width:String;
			
			if (options.layout == "horizontal") {
				blocksWidth = new WidthCalc(size.width - options.spacing * (len + 1));
				
				for (i = 0; i < len; i++) 
				{
					xml_width = xml.block[i].hasOwnProperty("@width") ? xml.block[i].@width : "NaN";
					if (xml_width.indexOf("%") > -1) {
						xml_width = xml_width.replace("%", "");
						block_width = Number(xml_width) * size.width / 100;
					} else {
						block_width = Number(xml_width);
					}
					
					blocksWidth.addSize(block_width);
				}
				
				blocksWidth.calculate();
				
			} else {
				blocksWidth = new WidthCalc(size.width);
				
				for (i = 0; i < len; i++) 
				{
					xml_width = xml.block[i].hasOwnProperty("@width") ? xml.block[i].@width : "NaN";
					if (xml_width.indexOf("%") > -1) {
						xml_width = xml_width.replace("%", "");
						block_width = Number(xml_width) * size.width / 100;
					} else {
						block_width = Number(xml_width);
					}
					
					if (isNaN(block_width)) {
						block_width = this.size.width;
					}
					
					blocksWidth.addSize(block_width);
				}
			}
			
		}
		
		private function buildBlocks():void {
			var i:uint;
			var len:uint = xml.block.length();
			var ax:uint = 0;
			var ay:uint = 0;
			
			if (options.align == "center") {
				ax = this.size.width / 2 - (blocksWidth.width + options.spacing) / 2;
			} else if (options.align == "right") {
				ax = this.size.width - (blocksWidth.width + options.spacing);
			}
			
			for (i = 0; i < len; i++) 
			{
				var size:Size;
				size = new Size(blocksWidth.getSize(i), 100);
				
				var block:Block = new Block(size, xml.block[i], this.size.width);
				block.x = ax;
				block.y = ay;
				
				if (options.layout == "horizontal") {
					ax += block.width + options.spacing;
				} else if (options.layout == "vertical") {
					ay += block.height + options.spacing;
				}
				
				blocks.push(block);
				addChild(block);
			}
		}
		
		private function drawBg():void {
			bg.graphics.clear();
			bg.graphics.lineStyle(options.borderSize, options.borderColor, options.borderAlpha);
			bg.graphics.beginFill(options.bgColor, options.bgAlpha);
			
			var ax:Number = 0;
			var ay:Number = 0;
			var blocks_width:Number = 0;
			try {
				blocks_width = blocksWidth.width;
			} catch(e:Error) {}
			
			var targetWidth:Number;
			var targetHeight:Number;
			
			targetWidth = this.size.width;
			targetHeight = height + options.spacing * 2;
			
			if (options.ellipseWidth > 0) {
				bg.graphics.drawRoundRect(ax, ay, targetWidth, targetHeight, options.ellipseWidth);
			} else {
				bg.graphics.drawRect(ax, ay, targetWidth, targetHeight);
			}
			bg.graphics.endFill();
		}
		
		public function resize():void {
			var width:Number = GridLayout.getStage().stageWidth;
			var target_width:Number;
			
			if (width < options.minimumWidth) {
				target_width = options.minimumWidth;
			}else if (width > options.maximumWidth && !isNaN(options.maximumWidth)) {
				target_width = options.maximumWidth;
			} else {
				target_width = width;
			}
			
			size.setWidth(target_width, 100);
			blocksWidth = null;
			calculateBlocksWidth();
			
			var i:uint;
			var len:uint = blocks.length;
			var ax:uint = 0;
			var ay:uint = 0;
			
			if (options.align == "center") {
				ax = this.size.width / 2 - (blocksWidth.width + options.spacing) / 2;
			} else if (options.align == "right") {
				ax = this.size.width - (blocksWidth.width + options.spacing);
			}
			
			var b:Block;
			for (i = 0; i < len; i++) 
			{
				var size:Size;
				size = new Size(blocksWidth.getSize(i), 100);
				
				b = (blocks[i] as Block);
				b.resize(size.width);
				
				b.x = ax;
				b.y = ay;
				
				if (options.layout == "horizontal") {
					ax += b.width + options.spacing;
				} else if (options.layout == "vertical") {
					ay += b.height + options.spacing;
				}
			}
			
			drawBg();
		}
		
		private function setOptions():void {
			var block_width:Number;
			var xml_width:String = xml.hasOwnProperty("@width") ? xml.@width : "NaN";
			if (xml_width.indexOf("%") > -1) {
				xml_width = xml_width.replace("%", "");
				block_width = Number(xml_width) * GridLayout.getStage().stageWidth / 100;
			} else {
				block_width = Number(xml_width);
			}
			
			if (isNaN(block_width) || block_width > GridLayout.getStage().stageWidth) {
				block_width = GridLayout.getStage().stageWidth;
			}
			
			size = new Size(block_width, 100);
			
			var minimumWidth:Number;
			var xml_minwidth:String = xml.hasOwnProperty("@minwidth") ? xml.@minwidth : "NaN";
			if (xml_minwidth.indexOf("%") > -1) {
				xml_minwidth = xml_minwidth.replace("%", "");
				minimumWidth = Number(xml_minwidth) * GridLayout.getStage().stageWidth / 100;
			} else {
				minimumWidth = Number(xml_minwidth);
			}
			
			var maximumWidth:Number;
			var xml_maxwidth:String = xml.hasOwnProperty("@maxwidth") ? xml.@maxwidth : "NaN";
			if (xml_maxwidth.indexOf("%") > -1) {
				xml_maxwidth = xml_maxwidth.replace("%", "");
				maximumWidth = Number(xml_maxwidth) * GridLayout.getStage().stageWidth / 100;
			} else {
				maximumWidth = Number(xml_maxwidth);
			}
			
			var align:String = xml.hasOwnProperty("@align") ? xml.@align : "left";
			var layout:String = xml.hasOwnProperty("@layout") ? xml.@layout : "vertical";
			
			var bgAlpha:Number = xml.hasOwnProperty("@bgAlpha") ? Number(xml.@bgAlpha) : 0;
			var bgColor:Number;
			if (xml.hasOwnProperty("@bgColor")) {
				bgColor =  Number(xml.@bgColor);
				if (!xml.hasOwnProperty("@bgAlpha")) {
					bgAlpha = 1;
				}
			} else {
				bgColor = 0xffffff;
			}
			
			
			var borderSize:Number = xml.hasOwnProperty("@border") ? Number(xml.@border) : 0;
			var borderAlpha:Number = xml.hasOwnProperty("@borderAlpha") ? Number(xml.@borderAlpha) : 0;
			var borderColor:Number;
			if (xml.hasOwnProperty("@borderColor")) {
				borderColor = Number(xml.@borderColor);
				if (!xml.hasOwnProperty("@borderAlpha")) {
					borderAlpha = 1;
				}
			} else {
				borderColor = 0x000000;
			}
			
			var ellipseWidth:Number = xml.hasOwnProperty("@ellipseWidth") ? Number(xml.@ellipseWidth) : 0;
			
			var padding:Number = xml.hasOwnProperty("@padding") ? Number(xml.@padding) : 0;
			var spacing:Number = xml.hasOwnProperty("@spacing") ? Number(xml.@spacing) : 0;
			
			options = new GridLayoutOptions(minimumWidth, maximumWidth, align, layout, bgColor, bgAlpha, borderSize, borderColor, borderAlpha, ellipseWidth, padding, spacing);
		}
		
		public function cleanup():void {
			var b:Block;
			for (var i:uint = 0; i < blocks.length; i++) 
			{
				b = (blocks[i] as Block);
				b.cleanup();
			}
			
			stageref.removeEventListener(Event.RESIZE, onStageResize);
		}
		
		public static function getStage():Stage {
			return stageref;
		}
		
	}
	
}