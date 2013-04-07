package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author iam
	 */
	public class Restart extends Event 
	{
		
		public static const RESTART:String = "restart";
		
		public function Restart(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new Restart(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("Restart", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}