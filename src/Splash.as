package  
{
	import adobe.utils.ProductManager;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * ...
	 * @author iam
	 */
	public class Splash extends Sprite
	{
		public static var IsWatchingSplash:Boolean = false;
		public static var Layer:DisplayObjectContainer;
		private var _movieclip:MovieClip = new splashmovie();
		private var _textfield:TextField;
		
		public function Splash() 
		{
			addChild(_movieclip);
			_movieclip.gotoAndStop(1);
			_textfield = _movieclip.mc.text as TextField;
		}
		
		public function Init(text:String):void 
		{
			IsWatchingSplash = true;
			if (!App.isOnPause) {
				App.userInterface.Pause();
			}
			
			this.x = 0;
			this.y = 40;
			if (text != "") { _textfield.text = text; }
			_movieclip.gotoAndPlay(1);
			Layer.addChild(this);
			_movieclip.addEventListener("die", onDestroy, false, 0, true);
		}
		
		private function onDestroy(e:Event):void 
		{
			Destroy();
		}
		
		public function Destroy():void 
		{
			IsWatchingSplash = false;
			if (App.isOnPause && !Interface.IsWathcingMenu) {
				App.userInterface.Pause();
			}
			
			if (Layer) {
				if (Layer.contains(this)) {
					Layer.removeChild(this);
				}
			}
			
			_movieclip.gotoAndStop(1);
		}
	}

}