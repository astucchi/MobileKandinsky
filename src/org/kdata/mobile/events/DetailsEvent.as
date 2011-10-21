package org.kdata.mobile.events
{
	import flash.events.Event;
	
	public class DetailsEvent extends Event
	{
		
		public static const FILTER_CHANGE:String = "filter_change";
		public static const DETAILS_CHANGE:String = "details_change";
		
		public function DetailsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}