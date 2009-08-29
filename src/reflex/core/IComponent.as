package reflex.core
{
	import flash.events.IEventDispatcher;
	
	import reflex.style.IStyleClient;

	public interface IComponent extends IEventDispatcher, IStyleClient
	{
		
		function get skin():ISkin;
		function set skin(value:ISkin):void;
		
		function get state():String;
		function set state(value:String):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		
	}
}