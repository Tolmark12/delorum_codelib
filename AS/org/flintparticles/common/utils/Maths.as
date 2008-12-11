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

package org.flintparticles.common.utils 
{
	/**
	 * The Maths class contains a coupleof useful methods for use in maths functions.
	 */
	public class Maths 
	{
		private static const RADTODEG:Number = 180 / Math.PI;
		private static const DEGTORAD:Number = Math.PI / 180;
		
		/**
		 * Converts an angle from radians to degrees
		 * 
		 * @param radians The angle in radians
		 * @return The angle in degrees
		 */
		public static function asDegrees( radians:Number ):Number
		{
			return radians * RADTODEG;
		}
		
		/**
		 * Converts an angle from degrees to radians
		 * 
		 * @param radians The angle in degrees
		 * @return The angle in radians
		 */
		public static function asRadians( degrees:Number ):Number
		{
			return degrees * DEGTORAD;
		}
	}
}
