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

package org.flintparticles.threeD.geom
{
	/**
	 * Vector3D represents a vector or a point in three-dimensional cartesian 
	 * coordinate space.
	 * 
	 * <p>The interface to this class is based on the interface to the 
	 * flash.geom.Vector3D class included in Flash Player 10, but with some
	 * enhancements.</p>
	 * 
	 * <p>This class has a number of methods that are not in the flash.geom.Vector3D
	 * class. Also, every method returns a reference to the Vector3D object
	 * so that a fluid programming style can be adopted for vector maths.<p>
	 * 
	 * <p>For example</p>
	 * 
	 * <p><code>v.incrementBy( u ).scaleBy( 7 )</code></p>
	 * 
	 * <p>A vector in the Vector3D class actually has four coordinates. The standard
	 * x, y, and z coordinates are used as normal for defining a location or a
	 * vector in 3D space. The forth coordinate (w) can be used in a number of
	 * ways.</p>
	 * 
	 * <p>The most common use for the w cooordinate is to encapsulate the difference 
	 * between a location and a vector. In this case, setting w to 1 indicates a
	 * location and setting it to 0 indicates a vector.</p>
	 * 
	 * <p>This has a number of beneficial side effects, including</p>
	 * 
	 * <ul>
	 * <li>Adding a point and a vector produces a point. Adding two vectors produces 
	 * a vector. Points can't be added together.</li>
	 * <li>Subtracting a vector from a point produces a point. Subtracting a vector 
	 * from a vector produces a vector. Subtracting a point from a point produces
	 * the vector from one point to the other. A point can't be subtracted from 
	 * a vector.</li>
	 * <li>Matrix transformations on vectors don't apply the translation elements.
	 * Matrix transformations on points do apply the translation elements.</li>
	 * </ul>
	 * 
	 * <p>The w coordinate may also be used to indicate a rotation, with w 
	 * representing the angle of rotation and the x, y and z indicating the
	 * axis to rotate around.</p>
	 * 
	 * <p>The w coordinate may be used to represent a projection transform for 
	 * projecting a point onto a 2D surface.</p>
	 */
	public class Vector3D
	{
		/**
		 * Calculates the distance between the points represented by the input 
		 * vectors. The w coordinate is ignored.
		 * 
		 * @param v1 first input vector.
		 * @param v2 second input vector.
		 *
		 * @return the distance between the points.
		 */
		public static function distance( v1:Vector3D, v2:Vector3D ):Number
		{
			return Math.sqrt( Vector3D.distanceSquared( v1, v2 ) );
		}
		
		/**
		 * Calculates the square of the distance between the points represented by 
		 * the input vectors. This is faster than calculating the actual distance.
		 * The w coordinate is ignored.
		 * 
		 * @param v1 first input vector.
		 * @param v2 second input vector.
		 *
		 * @return the square of the distance between the points.
		 */
		public static function distanceSquared( u:Vector3D, v:Vector3D ):Number
		{
			var dx:Number = u.x - v.x;
			var dy:Number = u.y - v.y;
			var dz:Number = u.z - v.z;
			return ( dx * dx + dy * dy + dz * dz );
		}
		
		/**
		 * A zero vector.
		 */
		public static const ZERO:Vector3D = new Vector3D( 0, 0, 0, 0 );
		/**
		 * A unit vector in the direction of the x axis.
		 */
		public static const AXISX:Vector3D = new Vector3D( 1, 0, 0, 0 );
		/**
		 * A unit vector in the direction of the y axis.
		 */
		public static const AXISY:Vector3D = new Vector3D( 0, 1, 0, 0 );
		/**
		 * A unit vector in the direction of the z axis.
		 */
		public static const AXISZ:Vector3D = new Vector3D( 0, 0, 1, 0 );
		/**
		 * A unit vector in the direction of the w axis. May represent a
		 * zero position vector.
		 */
		public static const AXISW:Vector3D = new Vector3D( 0, 0, 0, 1 );
		
		/**
		 * The x coordinate of the vector.
		 */
		public var x:Number;
		
		/**
		 * The y coordinate of the vector.
		 */
		public var y:Number;
		
		/**
		 * The z coordinate of the vector.
		 */
		public var z:Number;
		
		/**
		 * The w coordinate of the vector. The w coordinate may be used for
		 * a number of purposes. For example
		 * 
		 * <ul>
		 * <li>Often, w coordinate of 0 indicates a vector, while a w coordinate
		 * of 1 usually represents a point. When transformed by a matrix, a 
		 * Vector3D object with a zero w coordinate will be rotated and scaled but 
		 * will not be translated.</li>
		 * <li>The w coordinate may represent an angle of rotation about the
		 * vector represented by the x,y,z coordinates.</li>
		 * <li>The w coordinate may represent a projection transform for
		 * projecting a point onto a 2D surface.</li>
		 * </ul>
		 */
		public var w:Number;
		
		/**
		 * Constructor
		 *
		 * @param x the x coordinate of the vector
		 * @param y the y coordinate of the vector
		 * @param z the z coordinate of the vector
		 * @param w the w coordinate of the vector
		 */
		public function Vector3D( x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0 )
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}
		
		/**
		 * Assigns new coordinates to this vector
		 * 
		 * @param x The new x coordinate
		 * @param y The new y coordinate
		 * @param z The new z coordinate
		 * @param w The new w coordinate
		 * 
		 * @return a reference to this Vector3D object
		 */
		public function reset( x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0 ):Vector3D
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
			return this;
		}
		
		/**
		 * Copies another vector into this one.
		 * 
		 * @param v The vector to copy
		 * 
		 * @return a reference to this Vector3D object
		 */
		public function assign( v:Vector3D ):Vector3D
		{
			x = v.x;
			y = v.y;
			z = v.z;
			w = v.w;
			return this;
		}
		
		/**
		 * Makes a copy of this Vector3D object.
		 * 
		 * @return A copy of this Vector3D
		 */
		public function clone():Vector3D
		{
			return new Vector3D( x, y, z, w );
		}
		
		/**
		 * Adds another vector to this one, returning a new vector.
		 * The w coordinate is used.
		 * 
		 * @param v the vector to add
		 * 
		 * @return the result of the addition
		 */
		public function add( v:Vector3D ):Vector3D
		{
			return new Vector3D( x + v.x, y + v.y, z + v.z, w + v.w );
		}
		
		/**
		 * Subtract another vector from this one, returning a new vector. The
		 * w coordinate is used.
		 * 
		 * @param v The vector to subtract
		 * 
		 * @return The result of the subtraction
		 */		
		public function subtract( v:Vector3D ):Vector3D
		{
			return new Vector3D( x - v.x, y - v.y, z - v.z, w - v.w );
		}

		/**
		 * Multiply this vector by a number, returning a new vector.
		 * The w coordinate is unchanged.
		 * 
		 * @param s The number to multiply by
		 * 
		 * @return The result of the multiplication
		 */
		public function multiply( s:Number ):Vector3D
		{
			return new Vector3D( x * s, y * s, z * s, w );
		}
		
		/**
		 * Add another vector to this one. The w coordinate is used.
		 * 
		 * @param v The vector to add
		 * 
		 * @return A reference to this Vector3D object.
		 */
		public function incrementBy( v:Vector3D ):Vector3D
		{
			x += v.x;
			y += v.y;
			z += v.z;
			w += v.w;
			return this;
		}

		/**
		 * Subtract another vector from this one. The w coordinate is used.
		 * 
		 * @param v The vector to subtract
		 * 
		 * @return A reference to this Vector3D object.
		 */
		public function decrementBy( v:Vector3D ):Vector3D
		{
			x -= v.x;
			y -= v.y;
			z -= v.z;
			w -= v.w;
			return this;
		}

		/**
		 * Multiply this vector by a number. The w coordinate is left unchanged.
		 * 
		 * @param s The number to multiply by
		 * 
		 * @return A reference to this Vector3D object.
		 */
		public function scaleBy( s:Number ):Vector3D
		{
			x *= s;
			y *= s;
			z *= s;
			return this;
		}
		
		/**
		 * Compare this vector to another. The w coordinate is used.
		 * 
		 * @param v The vector to compare with
		 * 
		 * @return true if the vectors have the same coordinates, false otherwise
		 */
		public function equals( v:Vector3D ):Boolean
		{
			return x == v.x && y == v.y && z == v.z && w == v.w;
		}

		/**
		 * Compare this vector to another. The w coordinate is not used.
		 * 
		 * @param v The vector to compare with
		 * @param e The distance allowed between the points represented by the
		 * two vectors
		 * 
		 * @return true if the points represented by the vectors are within 
		 * distance e of each other, false otherwise
		 */
		public function nearEquals( v:Vector3D, e:Number ):Boolean
		{
			return Vector3D.distanceSquared( this, v ) <= e * e;
		}
		
		/**
		 * Calculate the dot product of this vector with another. 
		 * The w coordinate is not used.
		 * 
		 * @param v The vector to calculate the dot product with
		 * 
		 * @return The dot product of the two vectors
		 */
		public function dotProduct( v:Vector3D ):Number
		{
			return ( x * v.x + y * v.y + z * v.z );
		}
		
		/**
		 * Calculate the cross product of this vector with another. 
		 * The w coordinate is not used.
		 * 
		 * @param v The vector to calculate the cross product with
		 * 
		 * @return The cross product of the two vectors
		 */
		public function crossProduct( v:Vector3D ):Vector3D
		{
			return new Vector3D( y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x );
		}
		
		/**
		 * The length of this vector. The w coordinate is not used.
		 */
		public function get length():Number
		{
			return Math.sqrt( lengthSquared );
		}
		
		/**
		 * The square of the length of this vector. The w coordinate is not used.
		 */
		public function get lengthSquared():Number
		{
			return ( x * x + y * y + z * z );
		}
		
		/**
		 * Get the negative of this vector - a vector the same length but in the 
		 * opposite direction. The sign of the x, y and z coordinates is chaged.
		 * The w coordinate is unchanged.
		 * 
		 * @return the negative of this vector
		 */
		public function get negative():Vector3D
		{
			return new Vector3D( -x, -y, -z, w );
		}
		
		/**
		 * Negate this vector. The sign of the x, y, and z coordinates is changed.
		 * The w coordinate is unchanged.
		 * 
		 * @return a reference to this Vector3D object.
		 */
		public function negate():Vector3D
		{
			x = -x;
			y = -y;
			z = -z;
			return this;
		}
				
		/**
		 * Convert this vector to have length 1. The w coordinate is not changed.
		 * 
		 * @return A reference to this Vector3D object.
		 */
		public function normalize():Vector3D
		{
			var s:Number = this.length;
			if ( s != 0 )
			{
				s = 1 / s;
				x *= s;
				y *= s;
				z *= s;
			}
			else
			{
				throw new Error( "Cannot make a unit vector from  the zero vector." );
			}
			return this;
		}
		
		/**
		 * Divide all the coordinates in this position vector by the w coordinate, 
		 * producing a vector with a w coordinate of 1.
		 * 
		 * @return The projection of this vector to a vector with a w coordinate 
		 * of 1.
		 */
		public function project():Vector3D
		{
			if( w != 0 )
			{
				return scaleBy( 1/w );
			}
			else
			{
				throw new Error( "Cannot project a vector with a w coordinate of zero." );
			}
		}
		
		/**
		 * Create a unit vector in the same direction as this one. The w coordinate 
		 * is not changed.
		 * 
		 * @return A unit vector in the same direction as this one.
		 */
		public function unit():Vector3D
		{
			return clone().normalize();
		}
		
		/**
		 * Get a string representation of this vector
		 * 
		 * @return a string representation of this vector
		 */
		public function toString():String
		{
			return "(x=" + x + ", y=" + y + ", z=" + z + ", w=" + w + ")";
		}
	}
}
