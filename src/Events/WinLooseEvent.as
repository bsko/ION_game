package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author iam
	 */
	public class WinLooseEvent extends Event 
	{
		
		public static const WIN:String = "winevent";
		public static const LOOSE:String = "looseevent";
		
		public function WinLooseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new WinLooseEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("WinLooseEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}