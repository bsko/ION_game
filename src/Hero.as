package  
{
	import Events.Destroying;
	import Events.PauseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author iam
	 */
	public class Hero extends Sprite
	{
		
		public static const STATE_UPPER_LEFT:int = 101;
		public static const STATE_UPPER_RIGHT:int = 102;
		public static const STATE_BOTTOM_LEFT:int = 103;
		public static const STATE_BOTTOM_RIGHT:int = 104;
		public static const EATING_TIME:int = 5000;
		public static const START_LIFES:int = 3;
		
		private var _hero_state:int;
		private var _hero_movie:MovieClip = new hero_mc();
		private var _parent:DisplayObjectContainer;
		private var _hero_is_eating:Boolean = false;
		private var _eatingTimer:Timer = new Timer(EATING_TIME);
		private var _lifes:int;
		
		public function Hero() 
		{
			_hero_movie.gotoAndStop(1);
			_hero_state = STATE_UPPER_LEFT;
		}
		
		public function Init(parent:DisplayObjectContainer):void 
		{
			_lifes = START_LIFES;
			App.userInterface.ChangeLifesCount(_lifes);
			_parent = parent;
			_parent.addChild(this);
			
			addChild(_hero_movie);
			
			App.universe.addEventListener(Destroying.DESTROYING, Destroy, false, 0, true);
			App.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		private function onUnpauseEvent(e:PauseEvent):void 
		{
			if (!App.isOnPause) {
				App.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent, false, 0, true);
			}
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			if (App.isOnPause) {
				App.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent, false);
			}
		}
		
		private function onKeyboardEvent(e:KeyboardEvent):void 
		{
			switch(e.keyCode) {
				case 81:
					ChangeState(STATE_UPPER_LEFT);
				break;
				case 65:
					ChangeState(STATE_BOTTOM_LEFT);
				break;
				case 79:
					ChangeState(STATE_UPPER_RIGHT);
				break;
				case 76:
					ChangeState(STATE_BOTTOM_RIGHT);
				break;
			}
		}
		
		public function ChangeState(state:int):void 
		{
			if (_hero_is_eating) { return; }
			if (state == _hero_state) { return; }
			
			if((state == STATE_UPPER_LEFT) || (state == STATE_UPPER_RIGHT) || (state == STATE_BOTTOM_LEFT) || (state = STATE_BOTTOM_RIGHT)) {
				_hero_state = state;
				UpdateVisualState();
			}
		}
		
		public function StartEating():void 
		{
			if (!_hero_is_eating) {
				_hero_is_eating = true;
				
				_eatingTimer.reset();
				_eatingTimer.start();
				_eatingTimer.addEventListener(TimerEvent.TIMER, onStopEating, false, 0, true);
				
				if (_hero_state == STATE_UPPER_LEFT || _hero_state == STATE_BOTTOM_LEFT) {
					_hero_movie.gotoAndStop(6);
				} else if (_hero_state == STATE_UPPER_RIGHT || _hero_state == STATE_BOTTOM_RIGHT) {
					_hero_movie.gotoAndStop(5);
				}
			}
		}
		
		public function ChangeLifeCount(arg1:Number):void 
		{
			_lifes += arg1;
			if (lifes <= 0) {
				App.universe.DispatchLoose();
			} else {
				App.userInterface.ChangeLifesCount(_lifes);
			}
		}
		
		private function onStopEating(e:TimerEvent):void 
		{
			_hero_is_eating = false;
			
			_eatingTimer.reset();
			_eatingTimer.removeEventListener(TimerEvent.TIMER, onStopEating, false);
			
			UpdateVisualState();
		}
		
		private function UpdateVisualState():void 
		{
			switch(_hero_state)
			{
				case STATE_UPPER_LEFT:
					_hero_movie.gotoAndStop(1);
				break;
				case STATE_UPPER_RIGHT:
					_hero_movie.gotoAndStop(2);
				break;
				case STATE_BOTTOM_LEFT:
					_hero_movie.gotoAndStop(3);
				break;
				case STATE_BOTTOM_RIGHT:
					_hero_movie.gotoAndStop(4);
				break;
			}
		}
		
		private function Destroy(e:Destroying = null):void 
		{
			App.universe.removeEventListener(Destroying.DESTROYING, Destroy, false);
			App.userInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.userInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
		}
		
		public function get hero_state():int { return _hero_state; }
		
		public function get hero_is_eating():Boolean { return _hero_is_eating; }
		
		public function get lifes():int { return _lifes; }
		
		public function set lifes(value:int):void 
		{
			_lifes = value;
		}
		
	}

}