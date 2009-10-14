package flame.simple
{
	import flame.behaviors.Click;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	
	import reflex.core.Component;
	
	public class Button extends Component
	{
		public function Button()
		{
			var b1:Click = new Click();
				b1.target = this;
			Bind.addListener(onStateChange, b1, "state");
			//var b2:Select = new Select();
		}
		
		private function onStateChange(event:PropertyEvent):void
		{
			trace(event.newValue);
		}
		
	}
}