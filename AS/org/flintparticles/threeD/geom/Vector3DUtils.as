package org.flintparticles.threeD.geom 
{

	/**
	 * @author user
	 */
	public class Vector3DUtils 
	{
		public static function getPerpendiculars( normal:Vector3D ):Array
		{
			var p1:Vector3D = getPerpendicular( normal );
			var p2:Vector3D = normal.crossProduct( p1 ).normalize();
			return [ p1, p2 ];
		}
		
		public static function getPerpendicular( v:Vector3D ):Vector3D
		{
			if( v.x == 0 )
			{
				return new Vector3D( 1, 0, 0 );
			}
			else
			{
				return new Vector3D( v.y, -v.x, 0 ).normalize();
			}
		}
	}
}
