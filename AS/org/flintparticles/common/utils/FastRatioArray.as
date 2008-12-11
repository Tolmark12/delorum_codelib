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
	 * A PriorityArray is a collection of values that are permanently
	 * sorted according to their priority. When values are added to
	 * the PriorityArray their priority is indicated. They are then
	 * placed into the Array in sequence according to this priority.
	 * 
	 * <p>Due to the nature of a PriorityArray, there are no facilities
	 * to push, unshift or splice items into the array. All items are 
	 * added to the PriorityArray using the add method.</p>
	 * 
	 * <p>The array items can be accessed using standard Array access
	 * so the items in the PriorityArray can be looped through in
	 * the same manner as a standard Array.</p>
	 */
	public class FastRatioArray
	{
		private var _values:Array;
		private var _totalRatios:Number;
		
		/**
		 * Then constructor function is used to create a PriorityArray
		 */
		public function FastRatioArray()
		{
			_values = new Array();
			_totalRatios = 0;
		}
		
		/**
		 * Adds a value to the RatioArray.
		 * 
		 * @param value the value to add
		 * @param priority the priority to lpace on the item
		 * @return the length of the PriorityArray
		 */
		public function add( value:*, ratio:Number ):uint
		{
			_totalRatios += ratio;
			_values.push( new Pair( _totalRatios, value ) );
			return _values.length;
		}
		
		/**
		 * Empties the PriorityArray. After calling this method the PriorityArray 
		 * contains no items.
		 */
		public function clear():void
		{
			_values.length = 0;
			_totalRatios = 0;
		}
		
		/**
		 * The number of items in the PriorityArray
		 */
		public function get length():uint
		{
			return _values.length;
		}
		
		public function get totalRatios():Number
		{
			return _totalRatios;
		}

		/**
		 * 
		 */
		public function getRandomValue():*
		{
			var position:Number = Math.random() * _totalRatios;
			var low:uint = 0;
			var mid:uint;
			var high:uint = _values.length;
			while( low < high )
			{
				mid = Math.floor( ( low + high ) * 0.5 );
				if( Pair( _values[ mid ] ).topWeight < position )
				{
					low = mid + 1;
				}
				else
				{
					high = mid;
				}
			}
			return _values[low].value;
		}
	}
}

class Pair
{
	internal var topWeight:Number;
	internal var value:*;
	
	public function Pair( topWeight:Number, value:* )
	{
		this.topWeight = topWeight;
		this.value = value;
	}
}