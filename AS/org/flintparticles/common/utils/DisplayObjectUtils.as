package org.flintparticles.common.utils 
{
	import flash.display.DisplayObject;	
	
	public class DisplayObjectUtils 
	{
		/**
		 * Converts a rotation in the coordinate system of a display object 
		 * to a global rotation relative to the stage.
		 * 
		 * @param obj The display object
		 * @param rotation The rotation
		 * 
		 * @return The rotation relative to the stage's coordinate system.
		 */
		public static function localToGlobalRotation( obj:DisplayObject, rotation:Number ):Number
		{
			var rot:Number = rotation + obj.rotation;
			for( var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent )
			{
				rot += current.rotation;
			}
			return rot;
		}

		/**
		 * Converts a global rotation in the coordinate system of the stage 
		 * to a local rotation in the coordinate system of a display object.
		 * 
		 * @param obj The display object
		 * @param rotation The rotation
		 * 
		 * @return The rotation relative to the display object's coordinate system.
		 */
		public static function globalToLocalRotation( obj:DisplayObject, rotation:Number ):Number
		{
			var rot:Number = rotation - obj.rotation;
			for( var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent )
			{
				rot -= current.rotation;
			}
			return rot;
		}
	}
}
