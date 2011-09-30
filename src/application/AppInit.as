package application
{
	import flash.profiler.showRedrawRegions;
	import flash.system.Security;
	
	import org.db.mongo.Document;
	
	

	public class AppInit
	{
		
		[MessageDispatcher] public var dispatchMessage : Function;
		
		[Inject] public var mongoConfig : MongoConfig ;
		
		
		/**
		 * @brief Init the entire app environment
		 */
		public function initEnvironment() : void {
			// load the crossdomain policy
			// to gain access to Mongo
//			obtainCrossdomain();
			
			// query the server for data
			//dispatchMessage( MongoQueryEvent.getMongoSendQuery({file:1}) );
			//var params:Document=new Document();
			//params.put("file",1);
			dispatchMessage(MongoEvent.sendGetAll(null) );
		}
		
		/**
		 * @brief Load the cross-domain policy file
		 */
		public function obtainCrossdomain() : void {
			Security.loadPolicyFile( mongoConfig.crossdomainPolicyURL );
		}
		
	}
}