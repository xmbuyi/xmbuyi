package com.tomez.contact 
{
	import com.tomez.TSprite;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	/**
	* ...
	* @author Tomez
	*/
	public class Contact extends TSprite
	{
		// PROPERTIES _____________________________________________________________________________________
		
		private var image:Bitmap;
		
		private const php_path:String = "assets/send_contact.php";
		
		private const error_str:String = "Required field.";
		private const error_invalid_email:String = "Invalid e-mail address.";
		
		private var format:TextFormat;
		private var status:Text;
		
		private var yourname:LabeledInput;
		private var email:LabeledInput;
		private var msg:LabeledTextArea;
		private var b:QButton;
		
		private var details:Text;
		
		private var _stage:Stage;
		
		// CONSTRUCTOR ____________________________________________________________________________________
		
		public function Contact(image:Bitmap, stage:Stage) 
		{
			this.image = image;
			
			try {
				_stage = getDefinitionByName("main").getStage();
			} catch (e:Error) {
				_stage = stage;
			}
			build();
		}
		
		// EVENTS _________________________________________________________________________________________
		
		private function onComplete(e:Event):void {
			status.text = "Thank you!";
			reset();
		}
		
		private function onIOError(e:IOErrorEvent):void {
			status.text = "Error while sending!";
		}
		
		private function onSendButtonClick(e:MouseEvent):void {
			if (check()) {
				send();
			}
		}
		
		private function onEnterFocus(e:Event):void {
			if (e.target.text == error_str || e.target.text == error_invalid_email) {
				e.target.text = "";
			}
			
			if (_stage.displayState == StageDisplayState.FULL_SCREEN) {
				_stage.displayState = StageDisplayState.NORMAL;
			}
			
		}
		
		private function onExitFocus(e:Event):void {
			
		}
		
		// METHODS ________________________________________________________________________________________
		
		private function build():void {
			
			addChild(image);
			
			var space:Number = image.width * 2 + 75;
			
			details = new Text();
			details.d_text.width = image.width;
			details.d_text.autoSize = "left";
			details.d_text.htmlText = "<font size='16' color='#ffffff'><b>公司名字</b></font><br>橡马布艺<br><br><font color='#ffffff'>Contact Details:</font><br>T: +1 112 233 4455<br>F: +1 112 233 4455<br>E: <a href='mailto:info@company.com'>info@company.com</a></font><br><br><font color='#ffffff'>Address:</font><br>Company Name<br>Street Name<br>City<br>Country<br><br><font color='#ffffff'>Hours of Operation:</font><br>8:00 AM - 4:30 PM";
			details.x = image.width + 40;
			addChild(details);
			
			yourname = new LabeledInput("Name:", 292, 20);
			yourname.y = 6;
			yourname.x = space;
			
			email = new LabeledInput("E-mail:", 292, 20);
			email.x = space;
			email.y = yourname.y + yourname.height + 10;
			
			msg = new LabeledTextArea("Message:", 292, 90);
			msg.x = space;
			msg.y = email.y + email.height + 15;
			
			b = new QButton("Send", 73, 25);
			b.x = space + msg.width - b.width;
			b.y = msg.y + msg.height + 15;
			
			//status
			
			status = new Text();
			status.d_text.selectable = false;
			status.d_text.autoSize = "left";
			status.d_text.multiline = false;
			status.d_text.htmlText = "Please fill out this form.";
			status.x = space;
			status.y = b.y;
			
			addChild(yourname);
			addChild(email);
			addChild(msg);
			addChild(b);
			addChild(status);
			
			yourname.getTextField().addEventListener(FocusEvent.FOCUS_IN, onEnterFocus);
			yourname.getTextField().addEventListener(FocusEvent.FOCUS_OUT, onExitFocus);
			
			email.getTextField().addEventListener(FocusEvent.FOCUS_IN, onEnterFocus);
			email.getTextField().addEventListener(FocusEvent.FOCUS_OUT, onExitFocus);
			
			msg.getTextField().addEventListener(FocusEvent.FOCUS_IN, onEnterFocus);
			msg.getTextField().addEventListener(FocusEvent.FOCUS_OUT, onExitFocus);
			
			b.addEventListener(MouseEvent.CLICK, onSendButtonClick);
		}
		
		private function send():void {
			var req:URLRequest = new URLRequest(php_path);
			var loader:URLLoader = new URLLoader(req);
			
			var vars:URLVariables = new URLVariables();
			vars.fl_name = yourname.text;
			vars.fl_email = email.text;
			vars.fl_msg = msg.text;
			
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			req.data = vars;
			req.method = URLRequestMethod.POST;
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(req);
		}
		
		private function check():Boolean {
			var ok:Boolean = true;
			if (yourname.text.length == 0 || yourname.text == error_str) {
				ok = false;
				yourname.text = error_str;
			}
			if (email.text.length == 0 || email.text == error_str || email.text == error_invalid_email) {
				ok = false;
				email.text = error_str;
			}
			if (!isValidEmail(email.text)) {
				ok = false;
				email.text = error_invalid_email;
			}
			if (msg.text.length == 0 || msg.text == error_str) {
				ok = false;
				msg.text = error_str;
			}
			return ok;
		}
		
		private function isValidEmail(email:String):Boolean {
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(email);
		}
		
		private function reset():void {
			yourname.text = "";
			email.text = "";
			msg.text = "";
		}
		
	}
	
}