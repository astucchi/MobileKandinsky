package presentation
{
	import application.InitEvent;
	import application.MongoEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.db.mongo.Document;
	import org.serialization.bson.ObjectID;

	public class MainPresentationModel
	{
		
		private var dp:ArrayCollection=new ArrayCollection();
		
		[Bindable] public var documents:ArrayCollection=new ArrayCollection();
		[Bindable] public var selectedDocument:Object = new Object();
		
		[MessageDispatcher] public var dispatchMessage:Function;
		
		public function getInitialImgList():void
		{
			dispatchMessage(InitEvent.getAppReady());
		}
		
		public function getDetails(id:ObjectID):void
		{
			var params:Document=new Document();
			params.put("_id",id);
			dispatchMessage(MongoEvent.sendGetOne(params))
		}
		
		public function load(skip:int=0):void
		{
			var params:Object = new Object();
			params.indexToSkip=skip;
			dispatchMessage(MongoEvent.sendGetAll(params));
		}
		
		
	}
}