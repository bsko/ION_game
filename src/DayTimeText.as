package  
{
	import Events.Destroying;
	import Events.PauseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author iam
	 */
	public class DayTimeText extends Sprite
	{
		public static var Layer:DisplayObjectContainer;
		
		private var _movie:MovieClip = new daytimetext();
		private var _tf:TextField;
		private var _parent:DisplayObjectContainer;
		
		public function DayTimeText() 
		{
			_tf = _movie.text as TextField;
			_tf.autoSize = TextFieldAutoSize.RIGHT;
		}
		
		public function Init(text:String):void
		{
			_parent = Layer;
			
			_tf.text = text;
			_movie.gotoAndPlay(1);
			
			this.x = 0;
			this.y = 230;
			
			addChild(_movie);
			
			_parent.addChild(this);
			_movie.addEventListener("ended", Destroy1, false, 0, true);
			App.universe.addEventListener(Destroying.DESTROYING, Destroy, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		private function onUnpauseEvent(e:PauseEvent):void 
		{
			if (!App.isOnPause) {
				_movie.play();
			}
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			if (App.isOnPause) {
				_movie.stop();
			}
		}
		
		private function Destroy1(e:Event):void 
		{
			Destroy();
		}
		
		private function Destroy(e:Destroying = null):void 
		{
			_movie.removeEventListener("ended", Destroy1, false);
			App.universe.removeEventListener(Destroying.DESTROYING, Destroy, false);
			
			if (_parent != null) {
				if (_parent.contains(this)) {
					_parent.removeChild(this);
				}
			}
			
			_movie.gotoAndStop(1);
			removeChild(_movie);
			
			App.userInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.userInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
		}
		
	}

}