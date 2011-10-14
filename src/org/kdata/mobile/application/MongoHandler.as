package org.kdata.mobile.application
{
	import flash.events.Event;
	
	import mx.utils.object_proxy;
	
	import org.kdata.mobile.infrastructure.MongoQuery;
	import org.kdata.mobile.presentation.CoverFlow;
	import org.kdata.mobile.presentation.MainPresentationModel;
	import org.serialization.bson.ObjectID;

	public class MongoHandler
	{
		[Inject] public var mongoQuery:MongoQuery;
		[Inject] [Bindable] public var model:MainPresentationModel;
		
		private var _skip:int=0;
		
		[MessageDispatcher] public var dispatchMessage:Function;
		
		[MessageHandler] public function mongoHandler(evt:MongoEvent):void
		{
			switch(evt.type)
			{
				case MongoEvent.SEND_GET_ALL :
					mongoQuery.getAll(evt.params);
					break;
				case MongoEvent.REPLY_GET_ALL :
					model.documents=evt.params.result;
					if(model.selectedDocument)
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
						model.selectedDocument=model.documents.getItemAt(Math.floor(Config.LIMIT/2));
						dispatchMessage(new Event("initComplete"));
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
					
			}				
		}
	}
}