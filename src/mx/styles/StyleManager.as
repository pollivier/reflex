package mx.styles
{
	import reflex.style.StyleType;
	import reflex.style.Style;

	public class StyleManager
	{
		public static var styleTypes:Object = {
			"behavior": StyleType.ARRAY_ADD
		};
		
		
		protected static var collapseSpace:RegExp = new RegExp("\\t+| {2,}", "g");
		protected static var addMissingTypes:RegExp = new RegExp("(^| )(#|.)", "g");
		protected static var selectors:Object = {};
		protected static var declarations:Array = [];
		
		
		public static function getStyles(obj:Object):Array
		{
			var declaration:CSSStyleDeclaration;
			
			var matches:Array = [];
			for each (declaration in declarations) {
				if (declaration.selector.match(obj)) {
					matches.push(declaration);
				}
			}
			matches.sortOn("specificity", Array.NUMERIC);
			return matches;
		}
		
		public static function getStyleDeclaration(selector:String):CSSStyleDeclaration
		{
			selector = selector.replace(collapseSpace, " ").replace(addMissingTypes, "$1*$2");
			if (selector in selectors) {
				return selectors[selector];
			}
			return null;
		}
		
		
		public static function setStyleDeclaration(selector:String, styleDeclaration:CSSStyleDeclaration):void
		{
			selector = selector.replace(collapseSpace, " ").replace(addMissingTypes, "$1*$2");
			
			if (selector in selectors) {
				var oldDeclaration:CSSStyleDeclaration = selectors[selector];
				declarations.splice(declarations.indexOf(oldDeclaration), 1);
			}
			
			selectors[selector] = styleDeclaration;
			declarations.push(styleDeclaration);
		}
		
		
		public static function clearStyleDeclaration(selector:String, unload:Boolean):void
		{
			if (selector in selectors) {
				var oldDeclaration:CSSStyleDeclaration = selectors[selector];
				declarations.splice(declarations.indexOf(oldDeclaration), 1);
				delete selectors[selector];
			}
		}
	}
}