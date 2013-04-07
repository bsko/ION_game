package structs 
{
	/**
	 * ...
	 * @author iam
	 */
	public class DifficultyLevel 
	{
		
		private var _delay:int;
		private var _offset:int;
		private var _speed:Number;
		private var _badBonusesAvailable:Boolean;
		private var _badBonusesPossibility:Number;
		private var _string:String;
		private var _type:int;
		
		public function DifficultyLevel(delay:int, offset:int, speed:Number, string:String, bbExist:Boolean = false, bbPos:Number = 0, type:int = 201) 
		{
			_delay = delay;
			_offset = offset;
			_speed = speed;
			_string = string;
			_badBonusesPossibility = bbPos;
			_badBonusesAvailable = bbExist;
			_type = type;
		}
		
		public function get delay():int { return _delay; }
		
		public function get offset():int { return _offset; }
		
		public function get speed():Number { return _speed; }
		
		public function get badBonusesPossibility():Number { return _badBonusesPossibility; }
		
		public function get badBonusesAvailable():Boolean { return _badBonusesAvailable; }
		
		public function get string():String { return _string; }
		
		public function get type():int { return _type; }
		
	}

}