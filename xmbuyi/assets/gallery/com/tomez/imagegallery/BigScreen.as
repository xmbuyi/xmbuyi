package com.tomez.imagegallery 
{
	import com.tomez.TSprite;
	import com.tomez.videoplayer.VideoPlayer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.utils.getDefinitionByName;
	
	import gs.TweenLite;
	import gs.easing.*;
	
	/**
	* ...
	* @author Tomez
	*/
	public class BigScreen extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var bg:TSprite;
		private var bgColor:Number = 0xffffff;
		
		private var closeRect:TSprite;
		
		private var image:BigScreenImage;
		private var borderSize:Number = 3;
		
		private var video:VideoPlayer;
		private var videoHolder:TSprite;
		private const videoDefaultWidth:uint = 720;
		private const videoDefaultHeight:uint = 405;
		
		private var nextContentType:String = "image";
		
		private var content:*;
		
		private var format:TextFormat;
		private var tf:TextField;
		private var format2:TextFormat;
		private var tf2:TextField;
		
		private var tfBg:TSprite;
		private var tfBgColor:Number = 0x333333;
		
		private var leftArrow:TSprite;
		private var rightArrow:TSprite;
		
		private var stageHeight:Number;
		
		private var xmlinfo:Object;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function BigScreen() 
		{
			init();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onClick(e:MouseEvent):void {
			hide();
		}
		
		private function onShowComplete():void {
			
		}
		
		private function onHideComplete():void {
			visible = false;
		}
		
		private function onResize(e:Event):void {
			
			try	{
				stageHeight = getDefinitionByName("main").stageRect.height;
			} catch (e:Error) {
				stageHeight = gallery.getStage().stageHeight;
			}
			
			redrawCloseRect();
			
			bg.x = Math.round(gallery.getStage().stageWidth / 2 - bg.width / 2);
			bg.y = Math.round(stageHeight / 2 - bg.height / 2);
			
			try {
				content.x = Math.round(gallery.getStage().stageWidth / 2 - content.width / 2);
				content.y = Math.round(stageHeight / 2 - content.height / 2);
			} catch (e:Error) {
				
			}
			
			drawText();
			
			// arrows repos
			leftArrow.x = 20;
			leftArrow.y = Math.round(stageHeight / 2 - leftArrow.height / 2);
			rightArrow.x = gallery.getStage().stageWidth - rightArrow.width - 2;
			rightArrow.y = Math.round(stageHeight / 2 - rightArrow.height / 2);
		}
		
		private function onComplete(e:Event):void {
			resizeBg(image.width + borderSize * 2, image.height + borderSize * 2);
		}
		
		private function onBgResizeComplete():void {
			
			showContent();
			
		}
		
		private function onImageMouseOver(e:Event):void {
			showText();
		}
		
		private function onImageMouseOut(e:Event):void {
			hideText();
		}
		
		private function onLeftArrowClick(e:Event):void {
			if (xmlinfo.prevThumb) {
				xmlinfo.prevThumb.clickHandler();
			}
		}
		
		private function onLeftArrowOver(e:Event):void {
			TweenLite.to(leftArrow, 0.5, { alpha:1 } );
		}
		
		private function onLeftArrowOut(e:Event):void {
			TweenLite.to(leftArrow, 0.5, { alpha:0.65 } );
		}
		
		private function onRightArrowClick(e:Event):void {
			if (xmlinfo.nextThumb) {
				xmlinfo.nextThumb.clickHandler();
			}
		}
		
		private function onRightArrowOver(e:Event):void {
			TweenLite.to(rightArrow, 0.5, { alpha:1 } );
		}
		
		private function onRightArrowOut(e:Event):void {
			TweenLite.to(rightArrow, 0.5, { alpha:0.65 } );
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function init():void {
			
			alpha = 0;
			visible = false;
			
			try	{
				stageHeight = getDefinitionByName("main").stageRect.height;
			} catch (e:Error) {
				stageHeight = gallery.getStage().stageHeight;
			}
			
			drawCloseRect();
			
			drawBg();
			
			gallery.getStage().addEventListener(Event.RESIZE, onResize);
			
			initBigScreenImage();
			
			videoHolder = new TSprite();
			addChild(videoHolder);
			
			content = image;
			
			initTexts();
			
			drawArrows();
		}
		
		private function initBigScreenImage():void {
			image = new BigScreenImage();
			
			image.x = bg.x + 10;
			image.y = bg.y + 10;
			addChild(image);
			
			addEventListener(Event.COMPLETE, onComplete);
		}
		
		private function initTexts():void {
			
			format = new TextFormat();
			format.font = "Tahoma";
			
			format2 = new TextFormat();
			format2.font = "Verdana";
			
			tf = new TextField();
			tf.embedFonts = true;
			tf.defaultTextFormat = format;
			tf.autoSize = "left";
			tf.selectable = false;
			tf.textColor = 0xffffff;
			tf.htmlText = "<font size=\"20\">Image Title</font>";
			tf.x = bg.x + 10;
			tf.y = bg.y  - tf.height - 5;
			tf.alpha = 0;
			addChild(tf);
			
			var gf:GlowFilter = new GlowFilter();
			gf.alpha = 0;
			
			tf2 = new TextField();
			tf.embedFonts = true;
			tf2.defaultTextFormat = format2;
			tf2.multiline = true;
			tf2.wordWrap = true;
			tf2.autoSize = "left";
			tf2.selectable = false;
			tf2.textColor = 0xffffff;
			tf2.htmlText = "<font size=\"12\">Description</font>";
			tf2.x = bg.x + borderSize + 10;
			tf2.width = bg.width - (borderSize * 2 + 10 * 2);
			tf2.y = bg.y + bg.height - (borderSize * 2 + tf2.height);
			tf2.alpha = 0;
			
			tf2.filters = [gf];
			
			tfBg = new TSprite();
			tfBg.graphics.beginFill(tfBgColor, 0.8);
			tfBg.graphics.drawRect(0, 0, bg.width - borderSize * 2, tf2.height + borderSize * 2);
			tfBg.graphics.endFill();
			tfBg.x = bg.x + borderSize;
			tfBg.y = bg.y + bg.height - borderSize - tfBg.height;
			
			tf2.mouseEnabled = false;
			tfBg.mouseEnabled = false;
			
			addChild(tfBg);
			addChild(tf2);
		}
		
		private function drawText():void {
			tf.x = bg.x + 10;
			tf.y = bg.y  - tf.height - 5;
			
			// description text
			
			tf2.x = bg.x + borderSize + 10;
			tf2.width = bg.width - (borderSize * 2 + 10 * 2);
			if (nextContentType != "video") {
				tf2.y = bg.y + bg.height - (borderSize * 2 + tf2.height);
			} else {
				tf2.y = bg.y + borderSize * 2;
			}
			
			// text bg		
			
			tfBg.graphics.clear();
			tfBg.graphics.beginFill(tfBgColor, 0.8);
			tfBg.graphics.drawRect(0, 0, bg.width - borderSize * 2, tf2.height + borderSize * 2);
			tfBg.graphics.endFill();
			if (tf2.htmlText.length < 1) {
				tfBg.graphics.clear();
			}
			tfBg.x = bg.x + borderSize;
			if (nextContentType != "video") {
				tfBg.y = bg.y + bg.height - borderSize - tfBg.height;
			} else {
				tfBg.y = bg.y + borderSize;
			}
		}
		
		private function showText():void {
			
			drawText();
			
			TweenLite.to(tf, 0.5, { autoAlpha:1 } );
			TweenLite.to(tf2, 0.5, { autoAlpha:1 } );
			TweenLite.to(tfBg, 0.4, { autoAlpha:1 } );
		}
		
		private function hideText():void {
			TweenLite.to(tf, 0.3, { autoAlpha:0 } );
			TweenLite.to(tf2, 0.3, { autoAlpha:0 } );
			TweenLite.to(tfBg, 0.3, { autoAlpha:0 } );
		}
		
		public function show(e:BigScreenEvent):void {
			
			//
			// Init -----------------------------------------------------------------------
			//
			
			xmlinfo = e.info;
			
			removeListeners();
			
			TweenLite.to(content, 0, { autoAlpha:0 } );
			
			hideText();
			
			visible = true;
			closeRect.buttonMode = true;
			TweenLite.to(this, 0.4, { alpha:1, onComplete:onShowComplete } );
			
			tf.htmlText = "<font size=\"20\">" + xmlinfo.xml.title + "</font>";
			tf2.htmlText = "<font size=\"12\">" + xmlinfo.xml.description + "</font>";
			
			// ----------------------------------------------------------------------------
			
			//
			// Load content
			//
			
			loadContent();
			
			//
			// Loader
			//
			
			try {
				getDefinitionByName("main").showLoader(0x000000);
			} catch (e:Error) { };
		}
		
		public function hide():void {
			cleanUpVideo();
			
			closeRect.buttonMode = false;
			TweenLite.to(this, 0.4, {alpha:0, onComplete:onHideComplete } );
		}
		
		private function loadContent():void {
			if (xmlinfo.xml.hasOwnProperty("video")) {
				
				nextContentType = "video";
				loadVideo();
				
			} else if (xmlinfo.xml.hasOwnProperty("flash")) {
				
				nextContentType = "flash";
				loadSwf();
				
			} else {
				
				nextContentType = "image";
				loadImage();
				
			}
		}
		
		private function loadImage():void {
			image.image.load(xmlinfo.bigImageSource);
		}
		
		private function loadSwf():void {
			image.image.load(xmlinfo.swfPath + xmlinfo.xml.flash);
		}
		
		private function loadVideo():void {
			cleanUpVideo();
			
			var video_width:uint = Number(xmlinfo.xml.video.@width);
			var video_height:uint = Number(xmlinfo.xml.video.@height);
			
			if (video_width == 0) video_width = videoDefaultWidth;
			if (video_height == 0) video_height = videoDefaultHeight;
			
			video = new VideoPlayer(video_width, video_height);
			resizeBg(video_width + borderSize * 2, video_height + 30 + borderSize * 2);
		}
		
		private function cleanUpVideo():void {
			if (video != null) {
				removeListeners();
				videoHolder.removeChild(video);
				video.removeAllEventListeners(true);
				video.destroy();
				video = null;
			}
		}
		
		private function showContent():void {
			
			if (nextContentType == "video") {
				
				videoHolder.alpha = 0;
				videoHolder.addChild(video);
				content = videoHolder;
				
			} else if (nextContentType == "flash") {
				content = image;
			} else {
				content = image;
			}
			
			content.x = Math.round(gallery.getStage().stageWidth / 2 - content.width / 2);
			content.y = Math.round(stageHeight / 2 - content.height / 2);
			
			content.alpha = 0;
			
			TweenLite.to(content, 0, { tint:0xffffff } );
			TweenLite.to(content, 0, { autoAlpha:1 } );
			TweenLite.to(content, 0.7, { tint:null } );
			//TweenLite.to(content, 0.5, { alpha:1 } );
			
			drawText();
			
			removeListeners();
			
			
			if (nextContentType == "video") {
				video.getVideoWindow().addEventListener(MouseEvent.MOUSE_OVER, onImageMouseOver);
				video.getVideoWindow().addEventListener(MouseEvent.MOUSE_OUT, onImageMouseOut);
				video.getVideoWindow().addEventListener(MouseEvent.CLICK, onClick);
				video.getVideoWindow().buttonMode = true;
			} else {
				content.addEventListener(MouseEvent.MOUSE_OVER, onImageMouseOver);
				content.addEventListener(MouseEvent.MOUSE_OUT, onImageMouseOut);
				content.addEventListener(MouseEvent.CLICK, onClick);
				content.buttonMode = true;
			}
			
			if (bg.mouseX >= 0 && bg.mouseX <= bg.width && bg.mouseY >=0 && bg.mouseY <= bg.height) {
				showText();
			}
			
			if (nextContentType == "video") {
				video.playVideo(xmlinfo.videoPath + xmlinfo.xml.video);
			}
			
		}
		
		private function removeListeners():void {
			if (content.hasEventListener(MouseEvent.MOUSE_OVER)) {
				content.removeEventListener(MouseEvent.MOUSE_OVER, onImageMouseOver);
			}
			if (content.hasEventListener(MouseEvent.MOUSE_OUT)) {
				content.removeEventListener(MouseEvent.MOUSE_OUT, onImageMouseOut);
			}
			if (content.hasEventListener(MouseEvent.CLICK)) {
				content.removeEventListener(MouseEvent.CLICK, onClick);
			}
			//video
			if (video) {
				if (video.getVideoWindow().hasEventListener(MouseEvent.MOUSE_OVER)) {
					video.getVideoWindow().removeEventListener(MouseEvent.MOUSE_OVER, onImageMouseOver);
				}
				if (video.getVideoWindow().hasEventListener(MouseEvent.MOUSE_OUT)) {
					video.getVideoWindow().removeEventListener(MouseEvent.MOUSE_OUT, onImageMouseOut);
				}
				if (video.getVideoWindow().hasEventListener(MouseEvent.CLICK)) {
					video.getVideoWindow().removeEventListener(MouseEvent.CLICK, onClick);
				}
			}			
		}
		
		private function drawBg():void {
			bg = new TSprite();
			bg.graphics.beginFill(bgColor);
			bg.graphics.drawRect(0, 0, 720, 405);
			bg.graphics.endFill();
			
			bg.x = Math.round(gallery.getStage().stageWidth / 2 - bg.width / 2);
			bg.y = Math.round(stageHeight / 2 - bg.height / 2);
			
			addChild(bg);
			
			bg.addEventListener(MouseEvent.CLICK, onClick);
			bg.buttonMode = true;
		}
		
		private function resizeBg(targetWidth:Number, targetHeight:Number):void {
			var tx:Number = Math.round(gallery.getStage().stageWidth / 2 - targetWidth / 2);
			var ty:Number = Math.round(stageHeight / 2 - targetHeight / 2);
			
			TweenLite.to(bg, 0.5, { width:targetWidth, height:targetHeight, x:tx, y:ty, ease:Cubic.easeOut, onComplete:onBgResizeComplete } );
			
			try {
				getDefinitionByName("main").hideLoader(null, 0x000000);
			} catch (e:Error) { };
		}
		
		private function drawCloseRect():void {
			closeRect = new TSprite();
			redrawCloseRect();
			
			closeRect.buttonMode = true;
			closeRect.mouseChildren = false;
			
			addChild(closeRect);
			
			closeRect.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function redrawCloseRect():void {
			closeRect.graphics.clear();
			closeRect.graphics.beginFill(0x000000, 0.8);
			closeRect.graphics.drawRect(0, 0, gallery.getStage().stageWidth, gallery.getStage().stageHeight);
			closeRect.graphics.endFill();
		}
		
		private function drawArrows():void {
			var arrowSize:Number = 26;
			
			var mouseCatch:TSprite = new TSprite();
			mouseCatch.graphics.beginFill(0xcccccc, 0);
			mouseCatch.graphics.drawRect(-10, -10, arrowSize + 5, arrowSize + 20);
			mouseCatch.graphics.endFill();
			
			var mouseCatch2:TSprite = new TSprite();
			mouseCatch2.graphics.beginFill(0xcccccc, 0);
			mouseCatch2.graphics.drawRect(-10, -10, arrowSize + 5, arrowSize + 20);
			mouseCatch2.graphics.endFill();
			
			// left arrow
			leftArrow = new TSprite();
			leftArrow.graphics.lineStyle(5, 0xffffff);
			leftArrow.graphics.moveTo(arrowSize / 2, 0);
			leftArrow.graphics.lineTo(0, arrowSize / 2);
			leftArrow.graphics.lineTo(arrowSize / 2, arrowSize);
			leftArrow.addChild(mouseCatch);
			leftArrow.alpha = 0.65;
			
			leftArrow.x = 20;
			leftArrow.y = Math.round(stageHeight / 2 - leftArrow.height / 2);
			addChild(leftArrow);
			
			// right arrow
			rightArrow = new TSprite();
			rightArrow.graphics.lineStyle(5, 0xffffff);
			rightArrow.graphics.lineTo(arrowSize / 2, arrowSize / 2);
			rightArrow.graphics.lineTo(0, arrowSize);
			rightArrow.addChild(mouseCatch2);
			rightArrow.alpha = 0.65;
			
			rightArrow.x = gallery.getStage().stageWidth - rightArrow.width - 2;
			rightArrow.y = Math.round(stageHeight / 2 - rightArrow.height / 2);
			addChild(rightArrow);
			
			leftArrow.buttonMode = true;
			leftArrow.mouseChildren = false;
			rightArrow.buttonMode = true;
			rightArrow.mouseChildren = false;
			
			leftArrow.addEventListener(MouseEvent.CLICK, onLeftArrowClick);
			leftArrow.addEventListener(MouseEvent.MOUSE_OVER, onLeftArrowOver);
			leftArrow.addEventListener(MouseEvent.MOUSE_OUT, onLeftArrowOut);
			
			rightArrow.addEventListener(MouseEvent.CLICK, onRightArrowClick);
			rightArrow.addEventListener(MouseEvent.MOUSE_OVER, onRightArrowOver);
			rightArrow.addEventListener(MouseEvent.MOUSE_OUT, onRightArrowOut);
		}
		
		public function destroy():void {
			image = null;
			cleanUpVideo();
		}
		
	}
	
}