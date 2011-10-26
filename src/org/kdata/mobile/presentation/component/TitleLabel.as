package org.kdata.mobile.presentation.component
{
	
	import mx.managers.IFocusManagerComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.core.IDisplayText;
	
	
	
	public class TitleLabel extends SkinnableComponent implements IFocusManagerComponent
	{
		
		public function TitleLabel()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  labelDisplay
		//----------------------------------
		
		[SkinPart(required="true")]
		public var labelDisplay:IDisplayText;
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
		[Bindable("contentChange")]
		[Inspectable(category="General", defaultValue="")]
		public function set label(value:String):void
		{
			// label property is just a proxy to the content.
			// The content setter will dispatch the event.
			labelDisplay.text = value;
		}
		public function get label():String          
		{
			return labelDisplay.text;
		}
	}
}