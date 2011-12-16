package org.kdata.mobile.application
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.utils.object_proxy;
	
	import org.db.mongo.Document;
	import org.kdata.mobile.events.DetailsEvent;
	import org.kdata.mobile.infrastructure.MongoQuery;
	import org.kdata.mobile.presentation.MainPresentationModel;
	import org.kdata.mobile.presentation.component.CoverFlow;
	import org.serialization.bson.ObjectID;

	public class MongoHandler
	{
		[Inject] public var mongoQuery:MongoQuery;
		[Inject] [Bindable] public var model:MainPresentationModel;
		
		private var _skip:int=0;
		
		private var filtri:Array= new Array("anno","citta","natura","subnatura","collocazione","dimensioni");
		private var count:int=0;
		
		[MessageDispatcher] public var dispatchMessage:Function;
		
		[MessageHandler] public function mongoHandler(evt:MongoEvent):void
		{
			switch(evt.type)
			{
				case MongoEvent.SEND_GET_ALL :
					mongoQuery.getAll(evt.params);
					break;
				case MongoEvent.REPLY_GET_ALL :
					if(evt.params.result.length==0)
						dispatchMessage(new DetailsEvent(DetailsEvent.DETAILS_CHANGE));
						
					model.documents=evt.params.result;
					loadFilter();
					if(!model.isNewFilter)
					{
						for (var ind:int = 0 ; ind <model.documents.length ; ind++)
						{
							if(model.documents[ind].index ==model.selectedDocument.index)
							{
								_skip=0;
								break;
							}
							if(ind == model.documents.length-1)
							{
								_skip++;
								model.load(Config.LIMIT * _skip );
							}
						}
						model.index=ind;
						
					}
					else
					{
						model.selectedDocument=model.documents.getItemAt(Math.floor(model.documents.length/2));
						model.index=-1;
						
					}
						
					break;
				case MongoEvent.SEND_GET_ONE :
					mongoQuery.getOne(evt.params);
					break;
				case MongoEvent.REPLY_GET_ONE :
					model.selectedDocument=evt.params.result;
					break;
				case MongoEvent.SEND_GET_BY:
					mongoQuery.getBy(evt.params);
					break;
				case MongoEvent.SEND_GET_FILTERS :
					var doc:Document=new Document()
					doc.put("distinct", "documents");
					doc.put("key",evt.params);
					mongoQuery.runCommand(doc);
					break;
				case MongoEvent.REPLY_GET_FILTERS :
					model.filters[filtri[count-1]]=evt.params.result;
					loadFilter();
					break;
			}				
		}
		
		private function loadFilter():void
		{
			if(count<filtri.length)
			{
				dispatchMessage(new MongoEvent(MongoEvent.SEND_GET_FILTERS,filtri[count]));
				count++;
			}
				
			
		}
	}
}