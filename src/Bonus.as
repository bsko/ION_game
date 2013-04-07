package  
{
	import Events.Destroying;
	import Events.PauseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author iam
	 */
	public class Bonus extends Sprite
	{
		
		public static const BONUS_TYPES:Array = ["ipod", "flash", "photo", "phone", "ear-phones", "ipad", "food", "cmc", "playboy", "mygadget", "boom", "life"];
		public static const BONUS_POINTS:Array = [ 15, 10, 15, 20, 10, 25, -50, -50, -50, 50, 0, 0];
		public static const BONUS_FAILED_POINTS:Array = [5, 5, 5, 10, 5, 15, 0, 0, 0, 0, 0, 0];
		public static const BONUS_FOR_FOOD_IN_DINNER:int = 15;
		
		public static const DIRECTION_UPPER_LEFT:int = 101;
		public static const DIRECTION_UPPER_RIGHT:int = 102;
		public static const DIRECTION_BOTTOM_LEFT:int = 103;
		public static const DIRECTION_BOTTOM_RIGHT:int = 104;
		
		public static const BASE_BAD_BONUS_POSSIBILITY:Number = 0.2;
		public static const BASE_EPIC_BONUS_POSSIBILITY:Number = 0.07;
		
		private var _bonus_type:String;
		private var _bonus_score_added:uint;
		private var _bonus_score_lost:uint;
		private var _bonus_type_index:int;
		
		private var _bonus_movie:MovieClip = new bonuses_mc();
		
		private var _parent:DisplayObjectContainer;
		
		private var _bg:BonusGenerator;
		private var _direction:int;
		
		private var _real_X:Number;
		private var _real_Y:Number;
		
		private var _start_Point:Point;
		private var _destination_Point:Point;
		private var _distance:Number;
		private var _current_step:Number = 0;
		private var _isMovingToDestinationPoint:Boolean = false;
		private var _speed:Number;
		private var _isFallingDown:Boolean = false;
		private var _fallingSpeed:Number = 2;
		private var _fallingSpeedDelay:Number = 0.5;
		
		public function Bonus() 
		{
			_bonus_movie.stop();
		}
		
		public function Init(parent:DisplayObjectContainer, direction:int, bg:BonusGenerator, speed:Number = 1, bbAvailable:Boolean = true, addedBadBonusPossibility:Number = 0):void 
		{
			_direction = direction;
			_bg = bg;
			_parent = parent;
			_speed = speed;
			
			switch(direction)
			{
				case DIRECTION_UPPER_LEFT:
				_start_Point = BonusGenerator.UPPER_LEFT_START_LOCATION;
				_destination_Point = BonusGenerator.UPPER_LEFT_DEST_LOCATION;
				_distance = Point.distance(BonusGenerator.UPPER_LEFT_START_LOCATION, BonusGenerator.UPPER_LEFT_DEST_LOCATION);
				_bonus_movie.rotation = 20;
				break;
				case DIRECTION_UPPER_RIGHT:
				_start_Point = BonusGenerator.UPPER_RIGHT_START_LOCATION;
				_destination_Point = BonusGenerator.UPPER_RIGHT_DEST_LOCATION;
				_distance = Point.distance(BonusGenerator.UPPER_RIGHT_START_LOCATION, BonusGenerator.UPPER_RIGHT_DEST_LOCATION);
				_bonus_movie.rotation = -20;
				break;
				case DIRECTION_BOTTOM_LEFT:
				_start_Point = BonusGenerator.BOTTOM_LEFT_START_LOCATION;
				_destination_Point = BonusGenerator.BOTTOM_LEFT_DEST_LOCATION;
				_distance = Point.distance(BonusGenerator.BOTTOM_LEFT_START_LOCATION, BonusGenerator.BOTTOM_LEFT_DEST_LOCATION);
				_bonus_movie.rotation = 20;
				break;
				case DIRECTION_BOTTOM_RIGHT:
				_start_Point = BonusGenerator.BOTTOM_RIGHT_START_LOCATION;
				_destination_Point = BonusGenerator.BOTTOM_RIGHT_DEST_LOCATION;
				_distance = Point.distance(BonusGenerator.BOTTOM_RIGHT_START_LOCATION, BonusGenerator.BOTTOM_RIGHT_DEST_LOCATION);
				_bonus_movie.rotation = -20;
				break;
			}
			
			_real_X = _start_Point.x;
			_real_Y = _start_Point.y;
			this.x = _real_X;
			this.y = _real_Y;
			_isMovingToDestinationPoint = true;
			
			_parent.addChild(this);
			
			var bad_bonus_possibility:Number = (bbAvailable) ? (BASE_BAD_BONUS_POSSIBILITY + addedBadBonusPossibility) : 0;
			
			if (Math.random() < bad_bonus_possibility) {
				_bonus_type_index = 6 + int(Math.random() * 3);
			} else if ( Math.random() < BASE_EPIC_BONUS_POSSIBILITY ) {
				if (App.universe.hero.lifes == Hero.START_LIFES ) {
					_bonus_type_index = 9 + int(Math.random() * 2);
				} else {
					_bonus_type_index = 9 + int(Math.random() * 3);
				}
			} else {
				_bonus_type_index = int(Math.random() * 6);
			}
			
			_bonus_type = BONUS_TYPES[_bonus_type_index];
			_bonus_score_added = BONUS_POINTS[_bonus_type_index];
			_bonus_score_lost = BONUS_FAILED_POINTS[_bonus_type_index];
			
			_bonus_movie.scaleX = _bonus_movie.scaleY = 0.5;
			_bonus_movie.gotoAndStop(_bonus_type);
			addChild(_bonus_movie);
			
			addEventListener(Event.ENTER_FRAME, onUpdateMovement, false, 0, true);
			App.universe.addEventListener(Destroying.DESTROYING, Destroy, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		private function onUnpauseEvent(e:PauseEvent):void 
		{
			if (!App.isOnPause) {
				if (_isMovingToDestinationPoint) {
					addEventListener(Event.ENTER_FRAME, onUpdateMovement, false, 0, true);
				} else if (_isFallingDown) {
					addEventListener(Event.ENTER_FRAME, onFallingDown, false, 0, true);
				}
			}
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			if (App.isOnPause) {
				if (_isMovingToDestinationPoint) {
					removeEventListener(Event.ENTER_FRAME, onUpdateMovement, false);
				} else if (_isFallingDown) {
					removeEventListener(Event.ENTER_FRAME, onFallingDown, false);
				}
			}
		}
		
		private function onUpdateMovement(e:Event):void 
		{
			if (_isMovingToDestinationPoint) 
			{
				var step:Number = _speed / _distance;
				_current_step += step;				
				if (_current_step < 1) {
					var tmpPoint:Point = Point.interpolate(_destination_Point, _start_Point, _current_step);
					_real_X = tmpPoint.x;
					_real_Y = tmpPoint.y;
					
					this.x = _real_X;
					this.y = _real_Y;
					
				} else {
					_real_X = _destination_Point.x;
					_real_Y = _destination_Point.y;
					
					this.x = _real_X;
					this.y = _real_Y;
					
					_isMovingToDestinationPoint = false;
					removeEventListener(Event.ENTER_FRAME, onUpdateMovement, false);
					_isFallingDown = true;
					addEventListener(Event.ENTER_FRAME, onFallingDown, false, 0, true);
				}
				if (_current_step >= 0.9) {
					CheckIfHeroTookIt();
				}
			}
		}
		
		private function onFallingDown(e:Event):void 
		{
			_real_Y += _fallingSpeed;
			_fallingSpeed += _fallingSpeedDelay;
			this.x = _real_X;
			this.y = _real_Y;
			if (_direction == 101 || _direction == 103) {
				_bonus_movie.rotation += 3;
				if (this.y >= 210) {
					FallDownAndDie();
				}
			} else {
				_bonus_movie.rotation -= 3;
				if (this.y >= 230) {
					FallDownAndDie();
				}
			}
		}
		
		private function FallDownAndDie():void 
		{
			if (_bonus_type == "ipod" ||
			_bonus_type == "flash" ||
			_bonus_type == "photo" ||
			_bonus_type == "phone" ||
			_bonus_type == "ear-phones" ||
			_bonus_type == "ipad") {
				App.universe.hero.ChangeLifeCount( -1);
			}
			App.SoundMngr.playSound("prize_break");
			AddBangMovie();
			Destroy();
		}
		
		private function AddBangMovie():void 
		{
			App.universe.ChangeScore( -_bonus_score_lost);
			
			var movie:MovieClip = new bang_movie();
			movie.scaleX = movie.scaleY = 2;
			movie.x = this.x;
			movie.y = 210;
			_parent.addChild(movie);
		}
		
		private function CheckIfHeroTookIt():void 
		{
			if (App.universe.hero.hero_is_eating) { return; }
			if(App.universe.hero.hero_state == _direction) {
				
				if (_bonus_type == "boom") {
					App.SoundMngr.playSound("bad_prize");
					App.universe.score = 0;
					App.universe.DispatchLoose();
				} else if (_bonus_type == "food") {
					if (App.universe.current_level.type == App.NORMAL_LEVEL) {
						App.SoundMngr.playSound("bad_prize");
						App.universe.hero.StartEating();
					} else if(App.universe.current_level.type == App.DINNER_LEVEL) {
						App.universe.ChangeScore(BONUS_FOR_FOOD_IN_DINNER);
						Destroy();
						return;
					}
				} else if (_bonus_type == "playboy") {
					App.SoundMngr.playSound("bad_prize");
					var flyingPB:FlyingPlayboy = new FlyingPlayboy();
					flyingPB.Init(_direction);
				} else if (_bonus_type == "cmc") {
					App.SoundMngr.playSound("bad_prize");
					var hugeText:CommingText = new CommingText();
					hugeText.Init();
				} else if (_bonus_type == "life") {
					App.SoundMngr.playSound("life");
					App.universe.hero.ChangeLifeCount( +1);
				} else if (_bonus_type == "mygadget") {
					App.SoundMngr.playSound("life");
					var txt:String = App.TEXTS_ARRAY[int(Math.random() * App.TEXTS_ARRAY.length)];
					var splash:Splash = new Splash();
					splash.Init(txt);
				} else {
					App.SoundMngr.playSound("good_prize");
				}
				
				App.universe.ChangeScore(_bonus_score_added);
				
				Destroy();
			}
		}
		
		public function Destroy(e:Destroying = null):void 
		{
			if (_parent != null)
			{
				if (_parent.contains(this) )
				{
					_parent.removeChild(this);
				}
			}
			
			_bg.RemoveBonusFromArray(this);
			
			if (_isMovingToDestinationPoint) {
				removeEventListener(Event.ENTER_FRAME, onUpdateMovement, false);
			} if (_isFallingDown) {
				removeEventListener(Event.ENTER_FRAME, onFallingDown, false);
			}
			if (contains(_bonus_movie)) {
				removeChild(_bonus_movie);
			}
			
			_isMovingToDestinationPoint = false;
			_isFallingDown = false;
			
			App.universe.removeEventListener(Destroying.DESTROYING, Destroy, false);
			App.userInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.userInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
		}
	}

}