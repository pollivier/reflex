package flame.behaviors
{
	import flash.events.MouseEvent;
	
	import reflex.behaviors.Behavior;
	
	[Bindable]
	public class Select extends Behavior
	{
		public var selected:Boolean = false;
		
		public function Select()
		{
		}
		
		override public function set target(value:Object):void
		{
			value.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function toggle():void
		{
			selected = !selected;
		}
		
		// ====== Event Listeners ====== //
		
		private function onClick(event:MouseEvent):void
		{
			toggle();
		}
	}
}