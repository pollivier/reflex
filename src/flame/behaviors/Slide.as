package flame.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	import flight.position.IProgress;
	import flight.position.Progress;
	
	import reflex.behaviors.Behavior;
	
	public class Slide extends Behavior
	{
		public var progress:IProgress = new Progress();
		public var horizontal:Boolean = true;
		
		//[SkinPart("track")]
		public var track:InteractiveObject;
		
		public function Slide()
		{
		}
		
		override public function set target(value:Object):void
		{
			if ("track" in value) {
				track = value.track;
			}
			Bind.bindEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, this, "track");
		}
		
		// ====== Event Listeners ====== //
		
		private function onMouseDown(event:MouseEvent):void
		{
			InteractiveObject(target).addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			InteractiveObject(target).addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			onMouseMove(event);
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			var rect:Rectangle = track.getRect(target as InteractiveObject);
			if (horizontal) {
				progress.percent = ( InteractiveObject(target).mouseX - rect.left ) / rect.width;
			} else {
				progress.percent = ( InteractiveObject(target).mouseY - rect.top ) / rect.height;
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			InteractiveObject(target).removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			InteractiveObject(target).removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
	}
}