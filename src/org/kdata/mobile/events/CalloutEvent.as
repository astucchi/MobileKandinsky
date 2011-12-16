package org.kdata.mobile.events
{
	import flash.events.Event;
	
	public class CalloutEvent extends Event
	{
		public static const OPEN_CALLOUT:String = "open_callout";
		public static const CLOSE_CALLOUT:String = "close_callout";
		
		public var params:Object;
		
		public function CalloutEvent(type:String,obj:Object=null)
		{
			super(type);
			this.params=obj;
		}
	}
}