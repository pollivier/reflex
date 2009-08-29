package reflex.style
{

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class Style extends EventDispatcher
	{
		protected var _target:Object;
		protected var _displayObject:DisplayObject;
		protected var _stylable:IStylable;
		protected var _explicitStyles:Object = {};
		protected var _styles:Object = {};
		protected var _declarations:Array;
		
		public function Style(target:Object)
		{
			_target = target;
			_stylable = target as IStylable;
			_displayObject = target as DisplayObject;
			init();
		}
		
		protected function init():void
		{
			if (_displayObject) {
				_displayObject.addEventListener(Event.ADDED_TO_STAGE, updateEvent);
				if (_stylable) {
					_displayObject.addEventListener("idChange", updateEvent);
					_displayObject.addEventListener("styleNameChange", updateEvent);
				}
			}
			
			update();
		}
		
		public function getStyle(styleProp:String):*
		{
			return _styles[styleProp];
		}
		
		public function setStyle(styleProp:String, value:*):void
		{
			_explicitStyles[styleProp] = value;
			_styles[styleProp] = value;
		}
		
		/**
		 * Call when state changes.
		 */
		public function refresh():void
		{
			var styles:Object = {};
			for each (var declaration:CSSStyleDeclaration in _declarations) {
				mergeObjects(styles, declaration.styles);
			}
			mergeObjects(styles, _explicitStyles);
			_styles = styles;
		}
		
		public function update():void
		{
			_declarations = StyleManager.getStyles(_target);
			refresh();
			dispatch(Event.CHANGE);
		}
		
		protected function mergeObjects(mergeTo:Object, mergeFrom:Object):Object
		{
			for (var styleProp:String in mergeFrom) {
				var type:String = StyleManager.styleTypes[styleProp];
				var value:* = mergeFrom[styleProp];
				
				if (type == StyleType.ARRAY_ADD && mergeTo[styleProp] is Array) {
					mergeTo[styleProp].push(value);
				} else {
					mergeTo[styleProp] = value;
				}
			}
			return mergeTo;
		}
		
		protected function updateEvent(event:Event):void
		{
			update();
		}
		
		protected function dispatch(type:String):Boolean
		{
			if (hasEventListener(type)) {
				return super.dispatchEvent( new Event(type) );
			}
			return false;
		}
	}
}