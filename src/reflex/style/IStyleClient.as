package reflex.style
{
	public interface IStyleClient extends IStylable
	{
		function getStyle(name:String):*;
		function setStyle(name:String, value:*);
	}
}