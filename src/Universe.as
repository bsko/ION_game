package  
{
	import Events.Destroying;
	import Events.PauseEvent;
	import Events.UpdateScore;
	import Events.WinLooseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import structs.DifficultyLevel;
	/**
	 * ...
	 * @author iam
	 */
	public class Universe extends Sprite
	{
		public static const CHANGE_LEVEL_TIME:int = 1000;
		public static const CHANGE_LEVEL_ITERATIONS:int = 60;
		//layers:
		private var _backgroundSprite:MovieClip = new universe_bg_mc();
		private var _bonusesSprite:Sprite = new Sprite();
		private var _textSprite:Sprite = new Sprite();
		private var _heroSprite:Sprite = new Sprite();
		private var _playboySprite:Sprite = new Sprite();
		private var _splashesSprite:Sprite = new Sprite();
		private var _dayTimeTextSprite:Sprite = new Sprite();
		private var _iterator:int = 0;
		
		private var _hero:Hero = new Hero();
		
		private var _bonusGenerator:BonusGenerator = new BonusGenerator();
		private var _level:int = 0;
		
		private var _score:int = 0;
		private var _changeLevelTimer:Timer = new Timer(CHANGE_LEVEL_TIME);
		private var _current_level:DifficultyLevel;
		
		public function Universe()
		{
			addChild(_backgroundSprite);
			addChild(_bonusesSprite);
			addChild(_textSprite);
			addChild(_heroSprite);
			addChild(_playboySprite);
			addChild(_splashesSprite);
			addChild(_dayTimeTextSprite);
			
			DayTimeText.Layer = _dayTimeTextSprite as DisplayObjectContainer;
			CommingText.Layer = _textSprite as DisplayObjectContainer;
			FlyingPlayboy.Layer = _playboySprite as DisplayObjectContainer;
			Splash.Layer = _splashesSprite as DisplayObjectContainer;
		}
		
		public function Init():void 
		{
			_score = 0;
			_level = 0;
			_hero.x = width / 2;
			_hero.y = 150;
			_hero.Init(_heroSprite as DisplayObjectContainer);
			
			_current_level = App.levelsArray[_level];
			
			_bonusGenerator.Init(_bonusesSprite as DisplayObjectContainer, 4000, current_level.delay, current_level.offset, current_level.speed, current_level.badBonusesAvailable, current_level.badBonusesPossibility, current_level.type);
			_changeLevelTimer.addEventListener(TimerEvent.TIMER, onChangeLevel, false, 0, true);
			_changeLevelTimer.start();
			
			var dtt:DayTimeText = new DayTimeText();
			dtt.Init(current_level.string);
			
			FlyingPlayboy.SetUniverseSize();
			
			App.userInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		private function onUnpauseEvent(e:PauseEvent):void 
		{
			if (!App.isOnPause) {
				_changeLevelTimer.start();
			}
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			if (App.isOnPause) {
				_changeLevelTimer.stop();
			}
		}
		
		private function onChangeLevel(e:TimerEvent):void 
		{
			_iterator++;
			
			if (_iterator == CHANGE_LEVEL_ITERATIONS) {
				
				_iterator = 0;
				
				if (_level < 7) {
					_level++;
					_bonusGenerator.Destroy();
					_current_level = App.levelsArray[_level];
					_bonusGenerator.Init(_bonusesSprite as DisplayObjectContainer, 4000, _current_level.delay, _current_level.offset, _current_level.speed, _current_level.badBonusesAvailable, _current_level.badBonusesPossibility, _current_level.type);
					App.userInterface.UpdateLevel(_level + 1);
					
					var dtt:DayTimeText = new DayTimeText();
					dtt.Init(_current_level.string);
					
				} else if (_level == 7) {
					App.Total_SCORE = score;
					dispatchEvent(new WinLooseEvent(WinLooseEvent.WIN));
				}
			}
		}
		
		public function DispatchLoose():void 
		{
			App.Total_SCORE = score;
			dispatchEvent(new WinLooseEvent(WinLooseEvent.LOOSE));
			//Destroy();
		}
		
		public function ChangeScore(arg:int):void 
		{
			score += arg;
		}
		
		public function Destroy():void 
		{
			_changeLevelTimer.reset();
			_changeLevelTimer.removeEventListener(TimerEvent.TIMER, onChangeLevel, false);
			
			App.userInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.userInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
			
			dispatchEvent(new Destroying(Destroying.DESTROYING));
		}
		
		public function get hero():Hero { return _hero; }
		
		public function get score():int { return _score; }
		
		public function set score(value:int):void 
		{
			if (value <= 0) {
				_score = 0;
			} else {
				_score = value;
			}
			dispatchEvent(new UpdateScore(UpdateScore.UPDATE, _score));
		}
		
		public function get current_level():DifficultyLevel { return _current_level; }
	}

}