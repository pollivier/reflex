package flame.simple
{
	import flame.behaviors.Click;
	import flame.behaviors.Select;
	
	import reflex.core.Component;
	
	public class Button extends Component
	{
		public function Button()
		{
			var b1:Click = new Click();
			var b2:Select = new Select();
		}
	}
}