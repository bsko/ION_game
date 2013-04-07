package  
{
	import Events.Destroying;
	import Events.PauseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author iam
	 */
	public class CommingText extends Sprite
	{
		public static var Layer:DisplayObjectContainer;
		
		private var _textfield:MovieClip = new commingText();
		private var _parent:DisplayObjectContainer;
		
		public function CommingText() 
		{
			
		}
		
		public function Init():void
		{
			_textfield.gotoAndPlay(1);
			_textfield.scaleX = _textfield.scaleY = 20;
			addChild(_textfield);
			this.x = -130;
			this.y = -70;
			
			_parent = Layer;
			_parent.addChild(this);
			_textfield.addEventListener("ended", Destroy1, false, 0, true);
			App.universe.addEventListener(Destroying.DESTROYING, Destroy, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		private function onUnpauseEvent(e:PauseEvent):void 
		{
			if (!App.isOnPause) {
				_textfield.play();
			}
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			if (App.isOnPause) {
				_textfield.stop();
			}
		}
		
		private function Destroy1(e:Event):void 
		{
			Destroy();
		}
		
		public function Destroy(e:Destroying = null):void
		{
			_textfield.removeEventListener("ended", Destroy1, false);
			
			_textfield.gotoAndStop(1);
			removeChild(_textfield);
			
			if (_parent) {
				if (_parent.contains(this)) {
					_parent.removeChild(this);
				}
			}
			
			App.universe.removeEventListener(Destroying.DESTROYING, Destroy, false);
			App.userInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.userInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
		}
		
	}

}