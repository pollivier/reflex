package flame.behaviors
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import flight.events.ButtonEvent;
	
	import reflex.behaviors.Behavior;
	
	[Bindable]
	public class Click extends Behavior
	{
		public static const UP:String = "up";
		public static const OVER:String = "over";
		public static const DOWN:String = "down";
		
		public var state:String = UP;
		public var hover:Boolean = false;
		public var pressed:Boolean = false;
		
		public function Click()
		{
		}
		
		override public function set target(value:Object):void
		{
			if (value is DisplayObjectContainer) {
				DisplayObjectContainer(value).mouseChildren = false;
			}
			ButtonEvent.initialize(value as InteractiveObject);
			value.addEventListener(ButtonEvent.PRESS,				onPress);
			value.addEventListener(ButtonEvent.ROLL_OVER,			onRollOver);
			value.addEventListener(ButtonEvent.ROLL_OUT,			onRollOut);
			value.addEventListener(ButtonEvent.DRAG_OVER,			onDragOver);
			value.addEventListener(ButtonEvent.DRAG_OUT,			onDragOut);
			value.addEventListener(ButtonEvent.RELEASE,				onRelease);
			value.addEventListener(ButtonEvent.RELEASE_OUTSIDE,		onReleaseOutside);
			super.target = value;
		}
		
		public function click():void
		{
			InteractiveObject(target).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		// ====== Event Listeners ====== //
		
		private function onPress(event:MouseEvent):void
		{
			state = DOWN;
			pressed = true;
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			state = OVER;
			hover = true;
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			state = UP;
			hover = false;
		}
		
		private function onDragOver(event:MouseEvent):void
		{
			state = DOWN;
			hover = true;
		}
		
		private function onDragOut(event:MouseEvent):void
		{
			state = OVER;
			hover = false;
		}
		
		private function onRelease(event:MouseEvent):void
		{
			state = OVER;
			pressed = false;
		}
		
		private function onReleaseOutside(event:MouseEvent):void
		{
			state = UP;
			pressed = false;
		}
		
	}
}