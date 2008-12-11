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

package org.flintparticles.threeD.zones 
{
	import org.flintparticles.threeD.geom.Matrix3D;
	import org.flintparticles.threeD.geom.Vector3D;				

	/**
	 * The BoxZone zone defines a cuboid or box shaped zone.
	 */

	public class BoxZone implements Zone3D 
	{
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		private var _center:Vector3D;
		private var _upAxis:Vector3D;
		private var _depthAxis:Vector3D;
		private var _transformTo:Matrix3D;
		private var _transformFrom:Matrix3D;
		private var _dirty:Boolean;
		
		/**
		 * The constructor creates a BoxZone 3D zone.
		 * 
		 * @param width The width of the box.
		 * @param height The height of the box.
		 * @param depth The depth of the box.
		 * @param center The point at the center of the box.
		 * @param upAxis The axis along which the height is measured. The box is rotated
		 * so that the height is in this direction.
		 * @param depthAxis The axis along which the depth is measured. The box is rotated
		 * so that the depth is in this direction.
		 */
		public function BoxZone( width:Number, height:Number, depth:Number, center:Vector3D, upAxis:Vector3D, depthAxis:Vector3D )
		{
			_width = width;
			_height = height;
			_depth = depth;
			_center = center.clone();
			_center.w = 1;
			_upAxis = upAxis.unit();
			_upAxis.w = 0;
			_depthAxis = depthAxis.unit();
			_depthAxis.w = 0;
			_dirty = true;
		}
		
		private function init():void
		{
			_transformFrom = Matrix3D.newBasisTransform( _upAxis.crossProduct( _depthAxis ), _upAxis, _depthAxis );
			_transformFrom.appendTranslation( _center.x, _center.y, _center.z );
			_transformFrom.prependTranslation( -_width/2, -_height/2, -_depth/2 );
			_transformTo = _transformFrom.inverse;
			_dirty = false;
		}
		
		/**
		 * The width of the box.
		 */
		public function get width() : Number
		{
			return _width;
		}
		public function set width( value : Number ) : void
		{
			_width = value;
			_dirty = true;
		}
		
		/**
		 * The height of the box.
		 */
		public function get height() : Number
		{
			return _height;
		}
		public function set height( value : Number ) : void
		{
			_height = value;
			_dirty = true;
		}
		
		/**
		 * The depth of the box.
		 */
		public function get depth() : Number
		{
			return _depth;
		}
		public function set depth( value : Number ) : void
		{
			_depth = value;
			_dirty = true;
		}

		/**
		 * The point at the center of the box.
		 */
		public function get center() : Vector3D
		{
			return _center.clone();
		}
		public function set center( value : Vector3D ) : void
		{
			_center = value.clone();
			_center.w = 1;
			_dirty = true;
		}

		/**
		 * The axis along which the height is measured. The box is rotated
		 * so that the height is in this direction.
		 */
		public function get upAxis() : Vector3D
		{
			return _upAxis.clone();
		}
		public function set upAxis( value : Vector3D ) : void
		{
			_upAxis = value.unit();
			_upAxis.w = 0;
			_dirty = true;
		}

		/**
		 * The axis along which the depth is measured. The box is rotated
		 * so that the depth is in this direction.
		 */
		public function get depthAxis() : Vector3D
		{
			return _depthAxis.clone();
		}
		public function set depthAxis( value : Vector3D ) : void
		{
			_depthAxis = value.unit();
			_depthAxis.w = 0;
			_dirty = true;
		}

		/**
		 * The contains method determines whether a point is inside the box.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( p:Vector3D ):Boolean
		{
			if( _dirty )
			{
				init();
			}
			var q:Vector3D = _transformTo.transformVector( p );
			return q.x >= 0 && q.x <= _width && q.y >= 0 && q.y <= _height && q.z >= 0 && q.z <= _depth;
		}
		
		/**
		 * The getLocation method returns a random point inside the box.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Vector3D
		{
			if( _dirty )
			{
				init();
			}
			var p:Vector3D = new Vector3D( Math.random() * _width, Math.random() * _height, Math.random() * _depth, 1 );
			return _transformFrom.transformVectorSelf( p );
		}
		
		/**
		 * The getArea method returns the volume of the box.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return the volume of the box.
		 */
		public function getVolume():Number
		{
			return _width * _height * _depth;
		}
	}
}
