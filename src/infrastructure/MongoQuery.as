package infrastructure
{
	import application.Config;
	import application.MongoConfig;
	import application.MongoEvent;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.events.ModuleEvent;
	import mx.rpc.mxml.Concurrency;
	
	import org.db.mongo.Cursor;
	import org.db.mongo.DB;
	import org.db.mongo.Document;
	import org.db.mongo.Mongo;
	import org.db.mongo.auth.Authentication;
	import org.db.mongo.auth.Credentials;
	import org.db.mongo.mwp.OpReply;
	import org.serialization.bson.ObjectID;
	import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;

	public class MongoQuery
	{
		
		[MessageDispatcher] public var dispatcheMessage : Function;
		[Inject] public var mongoConfig:MongoConfig;
		
		private var cursor:Cursor; 
		
		private var _skip:int = 0;
		
		public var db:DB;
		
		public function getAll(params:Object=null):void
		{
			var mongo:Mongo = new Mongo(mongoConfig.dbHost, mongoConfig.dbPort);
			if(db==null)
			{
				db = mongo.getDB(mongoConfig.dbName);
				db.connect();
				var credential:Credentials = new Credentials(mongoConfig.dbUser,mongoConfig.dbPassword);
				var auth:Authentication = new Authentication(db,credential);
				auth.login(loginHandler);

			}
			else
			{
				try
				{
					if(params!=null)
						_skip=params.indexToSkip;
					cursor=db.getCollection(mongoConfig.dbCollection).find(new Document(),null,readAll,_skip,-Config.LIMIT);
					
				}catch(e:Error)
				{
					trace(e.message, "Errore connessione DB");
				}
			}

		}
		
		public function getOne(params:Object):void
		{
			try
			{
				cursor=db.getCollection(mongoConfig.dbCollection).findOne(params as Document,null,readOne);
			}catch(e:Error)
			{
				trace(e.message, "Errore connessione DB");
			}
		}
		
		private function readAll():void
		{
			var documents:ArrayCollection=new ArrayCollection();
			for each(var reply:OpReply in cursor.replies)
			{
				documents.addAll(new ArrayCollection(reply.documents));
			}
			
			for (var i:int=0 ; i<documents.length ; i++ )
			{
				documents[i].index=i+_skip;
				documents[i].UIScale = 100;
				documents[i].x = 0;
				documents[i].y = 0;
			}
			
			var obj:Object=new Object();
			obj.result=documents;
	
			dispatcheMessage(MongoEvent.replyGetAll(obj))
		}
		
		
		private function readOne():void
		{
			var obj:Object=new Object();
			var documents:ArrayCollection=new ArrayCollection();
			
			for each(var reply:OpReply in cursor.replies)
			{
				obj.result=reply.documents[0];
			}
			// gestire caso null ////
			dispatcheMessage(MongoEvent.replyGetOne(obj));
		}
		
		private function loginHandler(logged:Boolean):void
		{
			if(logged)
			{
				trace("login OK");
				cursor=db.getCollection(mongoConfig.dbCollection).find(new Document(),null,readAll,_skip,-Config.LIMIT);
			}
				
				//dispatcheMessage(MongoQueryEvent.getMongoLoginResult());
			else
				trace("login FAIL");
				//dispatcheMessage(MongoQueryEvent.getMongoLoginFault());
		}
	}
}