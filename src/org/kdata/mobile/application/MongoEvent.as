package org.kdata.mobile.application
{
	import flash.events.Event;
	
	public class MongoEvent extends Event
	{
		public static const SEND_GET_ALL:String  =	"sendGetAll";
		public static const REPLY_GET_ALL:String =	"replyGetAll";
		public static const SEND_GET_ONE:String  =	"sendGetOne";
		public static const REPLY_GET_ONE:String =	"replyGetOne";
		public static const SEND_GET_BY:String   =	"sendGetBy";

		
		public var params:Object;
		
		public function MongoEvent(type:String,obj:Object=null)
		{
			super(type);
			this.params=obj;
		}
		
		public static function sendGetAll(obj:Object=null):MongoEvent
		{
			return new MongoEvent(SEND_GET_ALL,obj);
		}
		public static function replyGetAll(obj:Object=null):MongoEvent
		{
			return new MongoEvent(REPLY_GET_ALL,obj);
		}
		public static function sendGetOne(obj:Object=null):MongoEvent
		{
			return new MongoEvent(SEND_GET_ONE,obj);
		}
		public static function replyGetOne(obj:Object=null):MongoEvent
		{
			return new MongoEvent(REPLY_GET_ONE,obj);
		}
		public static function sendGetBy(obj:Object=null):MongoEvent
		{
			return new MongoEvent(SEND_GET_BY,obj);
		}
	}
}