package flame.behaviors
{
	import reflex.behaviors.Behavior;
	
	public class Slide extends Behavior
	{
		
		
		public function Slide()
		{
		}
		
		override public function set target(value:Object):void
		{
			if (value.track != null) {
//				value.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0xFF);
			}
		}
		
	}
}