package com.tomez.GridLayout 
{
	import com.tomez.TSprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	* ...
	* @author Tomez
	*/
	public class Block extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		public var size:Size;
		
		public var options:BlockOptions;
		
		private var xml:XML;
		
		private var parentWidth:Number;
		
		private var blocksWidth:WidthCalc;
		
		private var blocks:Array;
		
		private var bg:TSprite;
		
		private var textBlock:TextBlock;
		private var imageBlock:ImageBlock;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Block(size:Size, xml:XML, parentWidth:Number) 
		{
			this.size = size;
			this.xml = xml;
			this.parentWidth = parentWidth;
			//trace(xml);
			
			//trace("block width:", size.width);
			
			setOptions();
			//trace(options);
			
			bg = new TSprite();
			
			blocks = new Array();
			build();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onClick(e:Event):void {
			navigateToURL(new URLRequest(options.link), options.target);
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function build():void {
			
			if (xml.hasOwnProperty("imageblock")) {
				addImageBlock();
			}
			
			if (xml.block.length() > 0) {
				calculateBlocksWidth();
				buildBlocks();
			}
			
			// add textblock or imageblock if available
			if (xml.hasOwnProperty("textblock")) {
				addTextBlock();
			}
			
			// draw background
			drawBg();
			addChildAt(bg, 0);
		}
		
		private function addTextBlock():void {
			// auto padding if not defined
			if (!xml.hasOwnProperty("@padding")) {
				options.padding = 10;
			}
			
			textBlock = new TextBlock(xml.textblock, size.width - options.padding * 2);
			textBlock.x = options.padding;
			textBlock.y = options.padding;
			addChild(textBlock);
			
			mouseChildren = false;
		}
		
		private function addImageBlock():void {
			imageBlock = new ImageBlock(xml.imageblock.@src, xml);
			imageBlock.x = options.padding;
			imageBlock.y = options.padding;
			addChild(imageBlock);
		}
		
		private function calculateBlocksWidth():void {
			var i:uint;
			var len:uint = xml.block.length();
			var block_width:Number;
			var xml_width:String;
			
			if (options.layout == "horizontal") {
				blocksWidth = new WidthCalc(this.size.width - options.spacing * (len + 1));
				
				for (i = 0; i < len; i++) 
				{
					xml_width = xml.block[i].hasOwnProperty("@width") ? xml.block[i].@width : "NaN";
					if (xml_width.indexOf("%") > -1) {
						xml_width = xml_width.replace("%", "");
						block_width = Number(xml_width) * this.size.width / 100;
					} else {
						block_width = Number(xml_width);
					}
					
					blocksWidth.addSize(block_width);
				}
				
				blocksWidth.calculate();
				
			} else {
				blocksWidth = new WidthCalc(size.width - options.spacing * (len + 0));
				
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
			var ax:uint = options.spacing;
			var ay:uint = options.spacing;
			
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
			
			if (imageBlock) {
				targetWidth = this.size.width;
				targetHeight = height + options.spacing * 2 + options.padding * 2;
			} else if (textBlock) {
				targetWidth = this.size.width;
				targetHeight = height + options.padding * 2;
			} else {
				targetWidth = this.size.width;
				targetHeight = height + options.spacing * 2;
			}
			if (options.ellipseWidth > 0) {
				bg.graphics.drawRoundRect(ax, ay, targetWidth, targetHeight, options.ellipseWidth);
			} else {
				bg.graphics.drawRect(ax, ay, targetWidth, targetHeight);
			}
			bg.graphics.endFill();
		}
		
		public function resize(width:Number):void {
			size.setWidth(width, 100);
			blocksWidth = null;
			calculateBlocksWidth();
			
			var i:uint;
			var len:uint = blocks.length;
			var ax:uint = options.spacing;
			var ay:uint = options.spacing;
			
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
			
			if (xml.hasOwnProperty("textblock")) {
				textBlock.setWidth(this.size.width - options.padding * 2);
			} else if (xml.hasOwnProperty("imageblock")) {
				
			}
			
			drawBg();
		}
		
		private function setOptions():void {
			
			var align:String = xml.hasOwnProperty("@align") ? xml.@align : "left";
			var layout:String = xml.hasOwnProperty("@layout") ? xml.@layout : "horizontal";
			
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
			
			var link:String = xml.hasOwnProperty("@href") ? xml.@href : "";
			var target:String = xml.hasOwnProperty("@target") ? xml.@target : "";
			
			if (target == "") {
				target = "_blank";
			}
			
			if (link != "") {
				makeClickable();
			}
			
			options = new BlockOptions(align, layout, bgColor, bgAlpha, borderSize, borderColor, borderAlpha, ellipseWidth, padding, spacing, link, target);
		}
		
		private function makeClickable():void {
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function cleanup():void {
			
			if (hasEventListener(MouseEvent.CLICK)) {
				removeEventListener(MouseEvent.CLICK, onClick);
			}
			
			var b:Block;
			for (var i:uint = 0; i < blocks.length; i++) 
			{
				b = (blocks[i] as Block);
				b.cleanup();
			}
			
			imageBlock = null;
			textBlock = null;
		}
		
	}
	
}