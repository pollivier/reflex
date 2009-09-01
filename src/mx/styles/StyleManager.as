package mx.styles
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.IMXMLObject;
	
	import reflex.style.IStylable;

	public class StyleManager implements IMXMLObject
	{
		protected static var collapseSpace:RegExp = new RegExp("\\t+| {2,}", "g");
		protected static var addMissingTypes:RegExp = new RegExp("(^| )(#|.)", "g");
		protected static var selectors:Object = {};
		protected static var declarations:Array = [];
		
		/**
		 * Grab a reference to the stage so we can set styles when items are
		 * added.
		 */
		public function initialized(document:Object, id:String):void
		{
			document.stage.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
			document.stage.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, true);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			var displayObject:DisplayObject = event.target as DisplayObject;
			updateStyles(displayObject);
			if (displayObject is IStylable) {
				displayObject.addEventListener("stateChange", onStateChange);
			}
		}
		
		protected function onRemovedFromStage(event:Event):void
		{
			var displayObject:DisplayObject = event.target as DisplayObject;
			if (displayObject is IStylable) {
				displayObject.removeEventListener("stateChange", onStateChange);
			}
		}
		
		protected function onStateChange(event:Event):void
		{
			var displayObject:DisplayObject = event.target as DisplayObject;
			updateStyles(displayObject);
		}
		
		protected function updateStyles(displayObject:DisplayObject):void
		{
			var styles:Object = getStyles(displayObject);
			var properties:Object = styles._properties;
			delete styles._properties;
			var i:String;
			
			// set direct properties
			for (i in styles) {
				var obj:Object = displayObject;
				var props:Array = i.split(".");
				var len:uint = props.length;
				try {
					for (var j:uint = 0; j < len; j++) {
						var name:String = props[j];
						if (j < len - 1) {
							obj = obj[name];
						} else {
							obj[name] = styles[i];
						}
					}
				} catch (e:Error) {
					trace(i, "was not able to be set on", displayObject);
				}
			}
		}
		
		public static function getStyles(obj:Object):Object
		{
			var declaration:CSSStyleDeclaration;
			
			var matches:Array = [];
			for each (declaration in declarations) {
				if (declaration.selector.match(obj)) {
					matches.push(declaration);
				}
			}
			matches.sortOn("specificity", Array.NUMERIC);
			var styles:Object = {};
			for each (declaration in matches) {
				var prefix:String = "";
				if (declaration.selector.property) {
					prefix = declaration.selector.property + ".";
				}
				mergeObjects(styles, declaration.styles, prefix);
			}
			return styles;
		}
		
		protected static function mergeObjects(mergeTo:Object, mergeFrom:Object, prefix:String = ""):Object
		{
			for (var name:String in mergeFrom) {
				mergeTo[prefix + name] = mergeFrom[name];
			}
			return mergeTo;
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