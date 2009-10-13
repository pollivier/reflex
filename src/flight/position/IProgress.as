package flight.position
{
	/**
	 * Base interface for all types that represent a progression.
	 */
	public interface IProgress
	{
		/**
		 * The type of progression represented by this object as a string, for
		 * example: "bytes", "packets" or "pixels".
		 */
		function get type():String;
		
		/**
		 * The current position in the progression, between 0 and
		 * <code>length</code>.
		 */
		function get position():Number;
		
		/**
		 * The percent complete in the progress, as a number between 0 and 1
		 * with 1 being 100% complete.
		 */
		function get percent():Number;
		
		/**
		 * The total length of the progression.
		 */
		function get size():Number;
		
	}
}
