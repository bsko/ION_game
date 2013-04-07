package  
{
	import Events.Destroying;
	import Events.PauseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author iam
	 */
	public class FlyingPlayboy extends Sprite
	{
		public static const FLYING_TIME:int = 300; // время во фреймах 
		public static const CENTER_POINT:Point = new Point(165, 120);
		public static const BOTTOM_LEFT_ANGLE:int = 185;
		public static const BOTTOM_LEFT_RADIUS:int = 105;
		public static const BOTTOM_LEFT_ROTATION:int = 20;
		public static const UPPER_LEFT_ANGLE:int = 210;
		public static const UPPER_LEFT_RADIUS:int = 125;
		public static const UPPER_LEFT_ROTATION:int = 20;
		public static const UPPER_RIGHT_ANGLE:int = 320;
		public static const UPPER_RIGHT_RADIUS:int = 125;
		public static const UPPER_RIGHT_ROTATION:int = -20;
		public static const BOTTOM_RIGHT_ANGLE:int = 340;
		public static const BOTTOM_RIGHT_RADIUS:int = 105;
		public static const BOTTOM_RIGHT_ROTATION:int = -20;
		
		public static const MAX_RADIUS:Number = 120;
		public static const MIN_RADIUS:Number = 60;
		
		public static const MAX_SCALE:Number = 8;
		public static const MIN_SCALE:Number = 1;
		
		public static const MAX_ANGLE_DELAY:Number = 15 * App.DEG_TO_RAD;
		public static const MIN_ANGLE_DELAY:Number = 5 * App.DEG_TO_RAD;
		
		public static const MAX_RADIUS_DELAY:Number = 3;
		public static const MIN_RADIUS_DELAY:Number = 0.2;
		
		public static const MAX_SCALE_DELAY:Number = 0.2;
		public static const MIN_SCALE_DELAY:Number = 0.05;
		
		public static const MAX_ROTATION_DELAY:Number = 15;
		public static const MIN_ROTATION_DELAY:Number = 5;
		
		public static var MaskW:int;
		public static var MaskH:int;
		public static var MaskX:int;
		public static var MaskY:int;
		
		public static var Layer:DisplayObjectContainer;
		
		private var _movingArray:Array;
		private var _radius:Number = 120;
		private var _flyingMovie:MovieClip = new flyingPB_mc();
		
		private var _counter:int = 0;
		
		private var _currentAngle:Number;
		private var _currentRadius:Number;
		private var _currentRotation:Number;
		private var _currentScale:Number;
		
		private var _angleDelay:Number;
		private var _radiusDelay:Number;
		private var _rotationDelay:Number;
		private var _scaleDelay:Number;
		private var _radius_changing_direction:int = 1;
		private var _scale_changing_direction:int = 1;
		private var _mask:Sprite = new Sprite();
		
		private var _direction:int;
		
		public function FlyingPlayboy()
		{
			
		}
		
		public static function SetUniverseSize():void
		{
			MaskX = App.universe.x;
			MaskY = App.universe.y;
			MaskW = 400;
			MaskH = App.universe.height;
		}
		
		public function Init(direction:int):void
		{
			switch(direction) {
				case Bonus.DIRECTION_UPPER_LEFT:
				_currentAngle = UPPER_LEFT_ANGLE * App.DEG_TO_RAD;
				_currentRadius = UPPER_LEFT_RADIUS;
				_currentRotation = UPPER_LEFT_ROTATION;
				break;
				case Bonus.DIRECTION_UPPER_RIGHT:
				_currentAngle = UPPER_RIGHT_ANGLE * App.DEG_TO_RAD;
				_currentRadius = UPPER_RIGHT_RADIUS;
				_currentRotation = UPPER_RIGHT_ROTATION;
				break;
				case Bonus.DIRECTION_BOTTOM_LEFT:
				_currentAngle = BOTTOM_LEFT_ANGLE * App.DEG_TO_RAD;
				_currentRadius = BOTTOM_LEFT_RADIUS;
				_currentRotation = BOTTOM_LEFT_ROTATION;
				break;
				case Bonus.DIRECTION_BOTTOM_RIGHT:
				_currentAngle = BOTTOM_RIGHT_ANGLE * App.DEG_TO_RAD;
				_currentRadius = BOTTOM_RIGHT_RADIUS;
				_currentRotation = BOTTOM_RIGHT_ROTATION;
				break;
			}
			
			_mask.x = MaskX;
			_mask.y = MaskY;
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0, 0, MaskW, MaskH);
			_mask.graphics.endFill();
			this.mask = _mask;
			
			_angleDelay = (Math.random() * ( MAX_ANGLE_DELAY - MIN_ANGLE_DELAY )) + MIN_ANGLE_DELAY;
			_radiusDelay = (Math.random() * ( MAX_RADIUS_DELAY - MIN_RADIUS_DELAY )) + MIN_RADIUS_DELAY;
			_rotationDelay = (Math.random() * ( MAX_ROTATION_DELAY - MIN_ROTATION_DELAY )) + MIN_ROTATION_DELAY;
			_scaleDelay = (Math.random() * (MAX_SCALE_DELAY - MIN_SCALE_DELAY)) + MIN_SCALE_DELAY;
			_direction = (Math.random() > 0.5) ? 1 : -1;
			_currentScale = 1.05;
			
			this.x = CENTER_POINT.x + _currentRadius * Math.cos(_currentAngle);
			this.y = CENTER_POINT.y + _currentRadius * Math.sin(_currentAngle);
			addChild(_flyingMovie);
			Layer.addChild(this);
			
			_counter = 0;
			
			addEventListener(Event.ENTER_FRAME, onUpdate, false, 0, true);
			App.universe.addEventListener(Destroying.DESTROYING, Destroy, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.userInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		private function onUnpauseEvent(e:PauseEvent):void 
		{
			if (!App.isOnPause) {
				addEventListener(Event.ENTER_FRAME, onUpdate, false, 0, true);
			}
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			if (App.isOnPause) {
				removeEventListener(Event.ENTER_FRAME, onUpdate, false);
			}
		}
		
		private function onUpdate(e:Event):void 
		{
			_counter++;
			if (_counter >= FLYING_TIME) {
				Destroy();
				return;
			}
			
			_currentAngle += _angleDelay * _direction;
			_currentRadius += _radiusDelay * _direction * _radius_changing_direction;
			_currentRotation += _rotationDelay * _direction;
			_currentScale += _scaleDelay * _scale_changing_direction;
			if (_currentRadius >= MAX_RADIUS) {
				_radius_changing_direction *= -1;
			} else if (_currentRadius <= MIN_RADIUS) {
				_radius_changing_direction *= -1;
			}
			if (_currentScale >= MAX_SCALE) {
				_scale_changing_direction *= -1;
			} else if (_currentScale <= MIN_SCALE) {
				_scale_changing_direction *= -1;
			}
			
			this.x = CENTER_POINT.x + _currentRadius * Math.cos(_currentAngle);
			this.y = CENTER_POINT.y + _currentRadius * Math.sin(_currentAngle);
			this.rotation = _currentRotation;
			_flyingMovie.scaleX = _flyingMovie.scaleY = _currentScale;
		}
		
		private function Destroy(e:Destroying = null):void 
		{
			removeEventListener(Event.ENTER_FRAME, onUpdate, false);
			
			if (contains(_flyingMovie)) {
				removeChild(_flyingMovie);
			}
			if (Layer){
				if (Layer.contains(this)) {
					Layer.removeChild(this);
				}
			}
			
			App.universe.removeEventListener(Destroying.DESTROYING, Destroy, false);
			App.userInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.userInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
		}
		
	}

}