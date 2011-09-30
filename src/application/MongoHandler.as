package application
{
	import mx.utils.object_proxy;
	import infrastructure.MongoQuery;
	import presentation.MainPresentationModel;

	public class MongoHandler
	{
		[Inject] public var mongoQuery:MongoQuery;
		[Inject] [Bindable] public var model:MainPresentationModel;
		
		
		[MessageHandler] public function mongoHandler(evt:MongoEvent):void
		{
			switch(evt.type)
			{
				case MongoEvent.SEND_GET_ALL :
					mongoQuery.getAll(evt.params);
					break;
				case MongoEvent.REPLY_GET_ALL :
					model.documents=evt.params.result;
					break;
				case MongoEvent.SEND_GET_ONE :
					mongoQuery.getOne(evt.params);
					break;
				case MongoEvent.REPLY_GET_ONE :
					model.selectedDocument=evt.params.result;
					break;
					
			}				
		}
	}
}