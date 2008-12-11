/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord (Big Room)
 * Copyright (c) Big Room Ventures Ltd. 2008
 * http://flintparticles.org
 * 
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.flintparticles.twoD.zones 
{
	import flash.geom.Point;

	/**
	 * The LineZone zone defines a zone that contains all the points on a line.
	 */

	public class LineZone implements Zone2D 
	{
		private var _point1:Point;
		private var _point2:Point;
		private var _length:Point;
		
		/**
		 * The constructor creates a LineZone zone.
		 * 
		 * @param point1 The point at one end of the line.
		 * @param point2 The point at the other end of the line.
		 */
		public function LineZone( point1:Point, point2:Point )
		{
			_point1 = point1;
			_point2 = point2;
			_length = point2.subtract( point1 );
		}
		
		/**
		 * The point at one end of the line.
		 */
		public function get point1() : Point
		{
			return _point1;
		}

		public function set point1( value : Point ) : void
		{
			_point1 = value;
			_length = point2.subtract( point1 );
		}

		/**
		 * The point at the other end of the line.
		 */
		public function get point2() : Point
		{
			return _point2;
		}

		public function set point2( value : Point ) : void
		{
			_point2 = value;
			_length = point2.subtract( point1 );
		}

		/**
		 * The contains method determines whether a point is inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			// not on line if dot product with perpendicular is not zero
			if ( ( x - _point1.x ) * _length.y - ( y - _point1.y ) * _length.x != 0 )
			{
				return false;
			}
			// is it between the points, dot product of the vectors towards each point is negative
			return ( x - _point1.x ) * ( x - _point2.x ) + ( y - _point1.y ) * ( y - _point2.y ) <= 0;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Point
		{
			var ret:Point = _point1.clone();
			var scale:Number = Math.random();
			ret.x += _length.x * scale;
			ret.y += _length.y * scale;
			return ret;
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getArea():Number
		{
			// treat as one pixel tall rectangle
			return _length.length;
		}
	}
}
