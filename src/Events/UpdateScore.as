package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author iam
	 */
	public class UpdateScore extends Event 
	{
		
		public static const UPDATE:String = "updatescore";
		private var _score:uint;
		
		public function UpdateScore(type:String, score:uint, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			_score = score;
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new UpdateScore(type, score, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("UpdateScore", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get score():uint { return _score; }
		
	}
	
}