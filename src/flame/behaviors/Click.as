package flame.behaviors
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import reflex.behaviors.Behavior;
	
	public class Click extends Behavior
	{
		public static const PRESS:String = "press";
		public static const DRAG:String = "drag";
		public static const ROLL_OVER:String = "rollOver";
		public static const ROLL_OUT:String = "rollOut";
		public static const DRAG_OVER:String = "dragOver";
		public static const DRAG_OUT:String = "dragOut";
		public static const RELEASE:String = "release";
		public static const RELEASE_OUTSIDE:String = "releaseOutside";
		
		public static const STATE_UP:String = "stateUp";
		public static const STATE_OVER:String = "stateOver";
		public static const STATE_DOWN:String = "stateDown";
		
		private static var buttonIndex:Dictionary = new Dictionary(true);
		
		public function Click()
		{
		}
		
		override public function set target(value:Object):void
		{
			value.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0xFF);
			value.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0xFF);
			value.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0xFF);
			value.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0xFF);
		}
		
		
		
		private static function dispatchButtonEvent(button:InteractiveObject, type:String, event:MouseEvent = null):void
		{
			if ( !button.hasEventListener(type) ) {
				return;
			}
			
			if (event == null) {
				event = new MouseEvent(type, false, false, button.mouseX, button.mouseY);
			} else {
				event = new MouseEvent(type, false, false, button.mouseX, button.mouseY, event.relatedObject,
									   event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta);
			}
			
			button.dispatchEvent(event);
		}
		
		
		
		private static function onMouseDown(event:MouseEvent):void
		{
			var button:InteractiveObject = event.currentTarget as InteractiveObject;
				button.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				button.stage.addEventListener(MouseEvent.MOUSE_UP, onRelease);
				button.stage.addEventListener(Event.MOUSE_LEAVE, onRelease);
			
			buttonIndex[button] = true;
			dispatchButtonEvent(button, PRESS, event);
			dispatchButtonEvent(button, STATE_DOWN, event);
		}
		
		private static function onMouseMove(event:MouseEvent):void
		{
			for (var i:* in buttonIndex) {
				var button:InteractiveObject = i as InteractiveObject;
				dispatchButtonEvent(button, DRAG, event);
			}
		}
		
		private static function onRollOver(event:MouseEvent):void
		{
			var button:InteractiveObject = event.currentTarget as InteractiveObject;
			
			if (buttonIndex[button] != null) {
				buttonIndex[button] = true;
				dispatchButtonEvent(button, DRAG_OVER, event);
				dispatchButtonEvent(button, STATE_DOWN, event);
			} else if (!event.buttonDown) {
				dispatchButtonEvent(button, STATE_OVER, event);
			}
			
			if (event.buttonDown) {
				event.stopImmediatePropagation();
			}
		}
		
		private static function onRollOut(event:MouseEvent):void
		{
			var button:InteractiveObject = event.currentTarget as InteractiveObject;
			
			if (buttonIndex[button] != null) {
				buttonIndex[button] = false;
				dispatchButtonEvent(button, DRAG_OUT, event);
				dispatchButtonEvent(button, STATE_OVER, event);
			} else if (!event.buttonDown) {
				dispatchButtonEvent(button, STATE_UP, event);
			}
			
			if (event.buttonDown) {
				event.stopImmediatePropagation();
			}
		}
		
		private static function onMouseUp(event:MouseEvent):void
		{
			var button:InteractiveObject = event.currentTarget as InteractiveObject;
			
			if (buttonIndex[button] == null) {
				dispatchButtonEvent(button, ROLL_OVER, event);
				dispatchButtonEvent(button, STATE_OVER, event);
			}
		}
		
		private static function onRelease(event:Event):void
		{
			var stage:Stage = event.currentTarget as Stage;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onRelease);
				stage.removeEventListener(Event.MOUSE_LEAVE, onRelease);
			
			for (var i:* in buttonIndex) {
				var button:InteractiveObject = i as InteractiveObject;
				
				if (buttonIndex[i]) {
					dispatchButtonEvent(button, RELEASE, event as MouseEvent);
					dispatchButtonEvent(button, STATE_OVER, event as MouseEvent);
				} else {
					dispatchButtonEvent(button, RELEASE_OUTSIDE, event as MouseEvent);
					dispatchButtonEvent(button, STATE_UP, event as MouseEvent);
				}
				
				delete buttonIndex[i];
			}
		}
	}
}