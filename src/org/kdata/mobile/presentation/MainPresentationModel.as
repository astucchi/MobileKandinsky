package org.kdata.mobile.presentation
{
	import mx.collections.ArrayCollection;
	
	import org.db.mongo.Document;
	import org.kdata.mobile.application.InitEvent;
	import org.kdata.mobile.application.MongoEvent;
	import org.serialization.bson.ObjectID;

	public class MainPresentationModel
	{
		
		private var dp:ArrayCollection=new ArrayCollection();
		
		[Bindable] public var documents:ArrayCollection=new ArrayCollection();
		[Bindable] public var selectedDocument:Object;
		[Bindable] public var docSelected:Document = new Document();
		[Bindable] public var index:int = -1;
		[Bindable] public var isLoading:Boolean = true;
		[Bindable] public var filters:Object = new Object();
		[Bindable] public var isNewFilter:Boolean = false;
		
		[MessageDispatcher] public var dispatchMessage:Function;
		
		public function getInitialImgList():void
		{
			dispatchMessage(InitEvent.getAppReady());
			isNewFilter=true;
		}
		
		public function getDetails(id:ObjectID):void
		{
			var params:Document=new Document();
			params.put("_id",id);
			dispatchMessage(MongoEvent.sendGetOne(params))
		}
		
		public function load(skip:int=0):void
		{
			isLoading=true;
			var params:Object = new Object();
			params.indexToSkip = skip;
			params.doc = docSelected;
			dispatchMessage(MongoEvent.sendGetAll(params));
		}
		
		
	}
}