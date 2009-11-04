package flame.simple
{
	import flame.behaviors.Click;
	import flame.behaviors.Select;
	
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	
	import reflex.core.Component;
	
	public class CheckBox extends Component
	{
		public var label:String;
		
		public var click:Click = new Click();
		public var select:Select = new Select();
		
		public function CheckBox()
		{
			click.target = this; 
			select.target = this;
			
			Bind.addListener(onChange, click, "state");
			Bind.addListener(onChange, select, "selected");
			Bind.addListener(onChange, this, "width");
			Bind.addListener(onChange, this, "height");
		}
		
		// ====== Cheap Skin for testing/building Behaviors ====== //
		
		private function onChange(event:PropertyEvent):void
		{
			switch (click.state) {
				case Click.UP :
					draw(select.selected ? 0xBB8899 : 0x999999);
					break;
				case Click.OVER :
					draw(select.selected ? 0xEEBBCC : 0xCCCCCC);
					break;
				case Click.DOWN :
					draw(select.selected ? 0x885566 : 0x666666);
					break;
			}
		}
		
		private function draw(color:Number):void
		{
			var g:Graphics = graphics;
				g.clear();
				var box:Matrix = new Matrix();
				box.createGradientBox(width, height, Math.PI/2, 0, 0);
				g.beginGradientFill("linear", [0xFFFFFF, color], [1, 1], [0, 0xFF], box);
				g.drawRoundRect(0, 0, width, height, 6, 6);
				g.beginGradientFill("linear", [color, 0x000000], [1, 1], [0, 0xFF], box);
				g.drawRoundRect(0, 0, width, height, 6, 6);
				g.drawRoundRect(1, 1, width-2, height-2, 4, 4);
		}
		
	}
}