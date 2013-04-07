package  
{
	import Events.Destroying;
	import Events.PauseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author iam
	 */
	public class BonusGenerator extends Sprite
	{
		
		public static const UPPER_LEFT_START_LOCATION:Point = new Point(-40, 30);
		public static const UPPER_RIGHT_START_LOCATION:Point = new Point(330, 42);
		public static const BOTTOM_LEFT_START_LOCATION:Point = new Point(-40, 95);
		public static const BOTTOM_RIGHT_START_LOCATION:Point = new Point(330, 105);
		
		public static const UPPER_LEFT_DEST_LOCATION:Point = new Point(40, 60);
		public static const UPPER_RIGHT_DEST_LOCATION:Point = new Point(260, 68);
		public static const BOTTOM_LEFT_DEST_LOCATION:Point = new Point(40, 125);
		public static const BOTTOM_RIGHT_DEST_LOCATION:Point = new Point(260, 132);
		
		private var _parent:DisplayObjectContainer;
		private var _delay:int;
		private var _availableOffset:int;
		private var _counter:int = 0;
		private var _time_to_next_bonus:int = 0;
		private var _bonuses_array:Array = [];
		private var _bonuses_speed:Number = 0
		private var _startingTimer:Timer = new Timer(1000);
		private var _notStarted:Boolean = true;
		private var _bbAvailable:Boolean = true;
		private var _bbAddedPos:Number = 0;
		private var _type:int;
		
		public function BonusGenerator() 
		{
			
		}
		
		public function Init(parent:DisplayObjectContainer, startingDelay:int, addingDelay:int = 60, availableOffset:int = 30, bonusSpeed:Number = 1, BBavailable:Boolean = true, BBaddedPos:Number = 0, type:int = App.NORMAL_LEVEL):void
		{
			App.SoundMngr.playSound("levelstart");
			_bonuses_array.length = 0;
			_counter = 0;
			_parent = parent;
			_delay = addingDelay;
			_time_to_next_bonus = _delay;
			_availableOffset = availableOffset;
			_bonuses_speed = bonusSpeed;
			_bbAddedPos = BBaddedPos;
			_bbAvailable = BBavailable
			_type = type;
			
			_startingTimer.delay = startingDelay;
			_startingTimer.addEventListener(TimerEvent.TIMER, onStart, false, 0, true);
			_startingTimer.start();
			
			App.universe.addEventListener(Destroying.DESTROYING, Destroy, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		private function onUnpauseEvent(e:PauseEvent):void 
		{
			if (!App.isOnPause) {
				if (_notStarted) {
					_startingTimer.start();
				} else {
					addEventListener(Event.ENTER_FRAME, onAddBonus, false, 0, true);
				}
			}
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			if (App.isOnPause) {
				if (_notStarted) {
					_startingTimer.stop();
				} else {
					removeEventListener(Event.ENTER_FRAME, onAddBonus, false);
				}
			}
		}
		
		private function onStart(e:TimerEvent):void 
		{
			_notStarted = false;
			_startingTimer.reset();
			_startingTimer.removeEventListener(TimerEvent.TIMER, onStart, false);
			
			_time_to_next_bonus += (int(Math.random() * _availableOffset * 2) - _availableOffset);
			if (_time_to_next_bonus <= 0) { _time_to_next_bonus = 1; }
			addEventListener(Event.ENTER_FRAME, onAddBonus, false, 0, true);
		}
		
		private function onAddBonus(e:Event):void 
		{
			_counter++;
			if (_counter == _time_to_next_bonus) {
				
				var direction:int = int(Math.random() * 4);
				if (direction == 0) {
					direction = 101;
				} else if (direction == 1) {
					direction = 102;
				} else if (direction == 2) {
					direction = 103;
				} else if (direction == 3) {
					direction = 104;
				} else {
					return;
				}
				
				AddBonus(direction);
				
				_counter = 0;
				_time_to_next_bonus = _delay + (int(Math.random() * _availableOffset * 2) - _availableOffset);
				if (_time_to_next_bonus <= 0) { _time_to_next_bonus = 1; }
			}
		}
		
		public function RemoveBonusFromArray(bonus:Bonus):void
		{
			var lenght:int = _bonuses_array.length;
			var tmpBonus:Bonus;
			for (var i:int = 0; i < lenght; i++)
			{
				tmpBonus = _bonuses_array[i];
				if (tmpBonus == bonus) {
					_bonuses_array.splice(i, 1);
					break;
				}
			}
		}
		
		private function AddBonus(direction:int):void 
		{
			var bonus:Bonus = new Bonus();
			bonus.Init(_parent, direction, this, _bonuses_speed, _bbAvailable, _bbAddedPos);
			_bonuses_array.push(bonus);
		}
		
		public function Destroy(e:Destroying = null):void 
		{
			if (_notStarted) {
				_startingTimer.reset();
				_startingTimer.removeEventListener(TimerEvent.TIMER, onStart, false);
			} else {
				removeEventListener(Event.ENTER_FRAME, onAddBonus, false);
			}
			
			_notStarted = true;
			_bonuses_array.length = 0;
			App.universe.removeEventListener(Destroying.DESTROYING, Destroy, false);
			App.userInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.userInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
		}
	}

}