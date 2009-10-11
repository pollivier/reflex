package flame.simple
{
	import flame.behaviors.Click;
	import flame.behaviors.Drag;
	
	import reflex.core.Component;
	
	public class Divider extends Component
	{
		public function Divider()
		{
			var b1:Click = new Click();
			var b2:Drag = new Drag();
		}
		
	}
}