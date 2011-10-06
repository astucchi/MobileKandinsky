package org.kdata.mobile.presentation
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.WhiteSpaceCollapse;
	
	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.states.Transition;
	
	import spark.components.supportClasses.GroupBase;
	import spark.events.IndexChangeEvent;
	import spark.layouts.supportClasses.LayoutBase;
	import spark.skins.spark.ScrollBarDownButtonSkin;
	
	[Event(name="loadComplete")]
	public class CoverFlowLayout extends LayoutBase
	{		
		private var _gap:Number=100;
		private var _distance:Number=100;
		[Bindable]
		private var _index:int;
		
		private var matrixs:Vector.<Matrix3D>;
		
		// animation
		private var time:Timer;
		private static const ANIMATION_DURATION:int=700;
		private static const ANIMATION_STEPS:int=24;
		

			
			
		public function CoverFlowLayout()
		{
			super();
		}
		
		// getter & setter		
		[Bindable]
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
			invalidateTarget();
		}
		
		public function get distance():Number
		{
			return _distance;
		}

		public function set distance(value:Number):void
		{
			_distance = value;
			invalidateTarget();
		}

		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			_gap = value;
			invalidateTarget();
		}

		
		// override function
		override public function updateDisplayList(width:Number, height:Number):void
		{
			var elementsNum:Number=target.numElements;
			if(elementsNum>0)
			{
				var selectedIndex:int= index==-1 ? Math.floor(elementsNum/2) : index;
				matrixs=new Vector.<Matrix3D>(elementsNum);
				
				for (var i:int=0;i<elementsNum;i++ )
					{
						var element:ILayoutElement=target.getVirtualElementAt(i);
						element.setLayoutBoundsSize(NaN,NaN,false);
						var elementWidth:Number=element.getLayoutBoundsHeight(false);
						var elementHeight:Number=element.getLayoutBoundsHeight(false);
						var zPosition:Number = Math.abs(selectedIndex - i)*distance;
						var matrix:Matrix3D = new Matrix3D();
						matrix.appendTranslation((width-elementWidth)/2, ( gap + elementHeight ) / 2 * -( selectedIndex - i ),zPosition);
			     		matrix.appendTranslation(0,(height-elementHeight)/2,0);
						
						matrixs[i]=matrix;
					//	element.setLayoutMatrix3D(matrix,false);
						
						if(element is IVisualElement)
							IVisualElement(element).depth=-zPosition;
					}
				playAnimation();
			}
		}
		
		override public function set target(value:GroupBase) : void
		{	
			if ( target != value )
			{
				if ( target )
				{
					target.maintainProjectionCenter = false;
					
					for ( var i:int = 0; i < target.numElements; i++ )
					{
						var e:ILayoutElement = target.getElementAt( i );
						
						// remove any 3D positioning
						e.setLayoutMatrix( new Matrix(), false );
						
						// reset layer to default
						if ( e is IVisualElement )
						{
							IVisualElement( e ).depth = 0;
						}
					}
				}
				
				super.target = value;
				
				if ( target )
				{
					target.maintainProjectionCenter = true;
				}
			}
		}
		
		// protected function
		protected function invalidateTarget():void
		{
			if ( target )
			{
				target.invalidateSize();
				target.invalidateDisplayList();
			}
		}
		
		protected function playAnimation():void{
			if(time)
			{
				time.stop();
				time.reset();
			}else
			{
				time=new Timer(ANIMATION_DURATION/ANIMATION_STEPS,ANIMATION_STEPS);
				time.addEventListener(TimerEvent.TIMER,animation_Handler);
				time.addEventListener(TimerEvent.TIMER_COMPLETE,animation_CompleteHandler);	
			}
			time.start();
		}
		
		protected function animation_Handler(e:TimerEvent):void
		{
			var numElement:int=target.numElements;
			var finalMatrix:Matrix3D;
			var initialMatrix:Matrix3D;
			var element:ILayoutElement;
			
			for(var i:int=0;i<numElement;i++)
			{
				finalMatrix=matrixs[i];
				element=target.getVirtualElementAt(i);
				initialMatrix=UIComponent(element).transform.matrix3D;
				initialMatrix.interpolateTo(finalMatrix,0.2);
				element.setLayoutMatrix3D(initialMatrix,false);
				verticalScrollPosition = 0;
			}
		}
		
		protected function animation_CompleteHandler(e:TimerEvent):void{
			matrixs=null;
			//Alert.show("completeHandler");
			dispatchEvent(new Event("loadComplete"));
		}
	}
}