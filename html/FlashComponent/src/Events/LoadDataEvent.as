package Events 
{
	import flash.events.Event;
	import nl.demonsters.debugger.MonsterDebugger;
	/**
	 * ...
	 * @author sasky
	 */
	public class LoadDataEvent extends Event 
	{
		public static const DATA_LOADED:String = "data loaded";
		
		public function LoadDataEvent(type:String):void
		{ 
			
			super(type);
			MonsterDebugger.trace(this , "in event");
			
		} 
		
		public override function clone():Event 
		{ 
			return new LoadDataEvent(type);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LoadDataEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}