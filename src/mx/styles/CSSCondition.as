package mx.styles
{
	import reflex.style.IStylable;
	
	import flash.display.DisplayObject;

	public class CSSCondition
	{
		protected static var onSpace:RegExp = new RegExp("\\s+");
		protected var _kind:String;
		protected var _value:String;
		protected var _specificity:uint;
		
		public function CSSCondition(kind:String, value:String)
		{
			_kind = kind;
			_value = value;
			_specificity = (kind == "id" ? 100 : 10);
		}
		
		public function get kind():String
		{
			return _kind;
		}
		
		public function get value():String
		{
			return _value;
		}
		
		public function get specificity():uint
		{
			return _specificity;
		}
		
		public function match(obj:Object):Boolean
		{
			var stylable:IStylable = obj as IStylable;
			var displayObject:DisplayObject = obj as DisplayObject;
			if (_kind == "id" && stylable) return stylable.id == _value;
			if (_kind == "id" && displayObject) return displayObject.name == _value;
			if (_kind == "class") return stylable.styleName.split(onSpace).indexOf(_value) != -1;
			if (_kind == "pseudo") return stylable.state.split(onSpace).indexOf(_value) != -1;
			return false;
		}
		
		public function toString():String
		{
			if (_kind == "id") return "#id" + _value;
			if (_kind == "class") return "." + _value;
			if (_kind == "pseudo") return ":" + _value;
			return "";
		}
	}
}