package org.kdata.mobile.presentation
{
	import spark.components.CheckBox;
	
	public class LabelCheckBox extends CheckBox
	{
		private var _data:Object;

		public function LabelCheckBox()
		{
			super();
			setStyle("skinClass",LabelCheckBoxSkin);
		}
		
		
		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
			enabled = (data.visible == "true" );
			label = data.text;
			id = data.label;
		}

		
		
		
		
	}
}