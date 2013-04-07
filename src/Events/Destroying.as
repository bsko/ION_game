package Events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author iam
	 */
	public class Destroying extends Event 
	{
		
		public static const DESTROYING:String = "destroying";
		
		public function Destroying(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new Destroying(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("Destroy", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}