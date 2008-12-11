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
	 * The DiscZone zone defines a circular zone. The zone may
	 * have a hole in the middle, like a doughnut.
	 */

	public class DiscZone implements Zone2D 
	{
		private var _center:Point;
		private var _innerRadius:Number;
		private var _outerRadius:Number;
		private var _innerSq:Number;
		private var _outerSq:Number;
		
		private static const TWOPI:Number = Math.PI * 2;
		
		/**
		 * The constructor defines a DiscZone zone.
		 * 
		 * @param center The centre of the disc.
		 * @param outerRadius The radius of the outer edge of the disc.
		 * @param innerRadius If set, this defines the radius of the inner
		 * edge of the disc. Points closer to the center than this inner radius
		 * are excluded from the zone. If this parameter is not set then all 
		 * points inside the outer radius are included in the zone.
		 */
		public function DiscZone( center:Point, outerRadius:Number, innerRadius:Number = 0 )
		{
			if( outerRadius < innerRadius )
			{
				throw new Error( "The outerRadius (" + outerRadius + ") can't be smaller than the innerRadius (" + innerRadius + ") in your DiscZone. N.B. the outerRadius is the second argument in the constructor and the innerRadius is the third argument." );
			}
			_center = center;
			_innerRadius = innerRadius;
			_outerRadius = outerRadius;
			_innerSq = _innerRadius * _innerRadius;
			_outerSq = _outerRadius * _outerRadius;
		}
		
		/**
		 * The centre of the disc.
		 */
		public function get center() : Point
		{
			return _center;
		}

		public function set center( value : Point ) : void
		{
			_center = value;
		}

		/**
		 * The radius of the inner edge of the disc.
		 */
		public function get innerRadius() : Number
		{
			return _innerRadius;
		}

		public function set innerRadius( value : Number ) : void
		{
			_innerRadius = value;
			_innerSq = _innerRadius * _innerRadius;
		}

		/**
		 * The radius of the outer edge of the disc.
		 */
		public function get outerRadius() : Number
		{
			return _outerRadius;
		}

		public function set outerRadius( value : Number ) : void
		{
			_outerRadius = value;
			_outerSq = _outerRadius * _outerRadius;
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
			x -= _center.x;
			y -= _center.y;
			var distSq:Number = x * x + y * y;
			return distSq <= _outerSq && distSq >= _innerSq;
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
			var rand:Number = Math.random();
			var point:Point =  Point.polar( _innerRadius + (1 - rand * rand ) * ( _outerRadius - _innerRadius ), Math.random() * TWOPI );
			point.x += _center.x;
			point.y += _center.y;
			return point;
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
			return Math.PI * ( _outerSq - _innerSq );
		}
	}
}
