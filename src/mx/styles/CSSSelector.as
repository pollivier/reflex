package mx.styles
{
	import reflex.style.IStylable;
	
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class CSSSelector
	{
		protected var _type:String;
		protected var _conditions:Array;
		protected var _ancestor:CSSSelector;
		protected var _specificity:uint;
		
		public function CSSSelector(type:String, conditions:Array = null, ancestor:CSSSelector = null)
		{
			if (!type || type == "global") type = "*";
			_type = type;
			_conditions = conditions;
			_ancestor = ancestor;
			_specificity = (type == "*" ? 1 : 0);
			init();
		}
		
		protected function init():void
		{
			if (_conditions) {
				for each (var condition:CSSCondition in _conditions) {
					_specificity += condition.specificity;
				}
				_conditions.sortOn("value");
				_conditions.sortOn("type");
				_conditions.sortOn("specificity", Array.NUMERIC);
			}
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get conditions():Array
		{
			return _conditions;
		}
		
		public function get ancestor():CSSSelector
		{
			return _ancestor;
		}
		
		public function get specificity():uint
		{
			return _specificity;
		}
		
		public function match(obj:Object, matchAncestors:Boolean = true, matchPseudos:Boolean = false):Boolean
		{
			var match:Boolean = false;
			var condition:CSSCondition;
			
			if (_type != "*" && getTypes(obj).indexOf(_type) == -1) {
				return false;
			}
			
			if (conditions) {
				// must be IStylable to match any of the conditions
				for each (condition in conditions) {
					if (!matchPseudos && condition.kind == "pseudo") break;
					if (!condition.match(obj)) return false;
				}
			}
			
			if (ancestor && matchAncestors && obj is DisplayObject) {
				var parent:DisplayObject = obj as DisplayObject;
				var selector:CSSSelector = ancestor;
				while (selector != null) {
					parent = parent.parent;
					while (parent != null) {
						if (selector.match(parent, false)) {
							selector = selector.ancestor;
							break;
						}
						parent = parent.parent;
					}
					// if we didn't match all the ancestors
					if (parent == null) return false;
				}
			}
			
			return true;
		}
		
		public function getTypes(obj:Object):Array
		{
			var className:String = getQualifiedClassName(obj);
			var types:Array = [className.split("::").pop()];
			
			while (className != "Object") {
				className = getQualifiedSuperclassName(obj);
				types.push(className.split("::").pop());
				obj = getDefinitionByName(className);
			}
			
			return types;
		}
		
		public function toString():String
		{
			var selectors:Array = [];
			var selector:CSSSelector = this;
			while (selector) {
				var str:String = selector.type;
				if (conditions) {
					for each (var condition:CSSCondition in conditions) {
						str += condition;
					}
				}
				selectors.unshift(str);
				selector = selector.ancestor;
			}
			return selectors.join(" ");
		}
	}
}