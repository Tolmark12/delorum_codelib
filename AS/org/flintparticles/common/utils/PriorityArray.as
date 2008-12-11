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
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

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
	public class PriorityArray extends Proxy
	{
		private var _values:Array;
		
		/**
		 * Then constructor function is used to create a PriorityArray
		 */
		public function PriorityArray()
		{
			_values = new Array();
		}
		
		/**
		 * Provides Array access to read values from the PriorityArray
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var index:int = int( name );
			if ( index == name && index < _values.length && _values[ index ] )
			{
				return _values[ index ].value;
			}
			else
			{
				return undefined;
			}
    	}
		
		/**
		 * Used to set the value of an existing member of the PriorityArray.
		 * This method cannot be used to set a new member of the ProiorityArray
		 * since this new member won't have a priority setting.
		 */
    	override flash_proxy function setProperty(name:*, value:*):void
		{
			var index:uint = uint( name );
			if ( index == name && index < _values.length )
			{
				_values[index].value = value;
			}
		}

		override flash_proxy function nextNameIndex( index:int ):int
		{
			if( index < _values.length )
			{
				return index + 1;
			}
			else
			{
				return 0;
			}
		}
		
		override flash_proxy function nextName( index:int ):String
		{
			return ( index - 1 ).toString();
		}
		
		override flash_proxy function nextValue( index:int ):*
		{
			return _values[ index - 1 ];
		}
		
		/**
		 * Adds a value to the PriorityArray.
		 * 
		 * @param value the value to add
		 * @param priority the priority to lpace on the item
		 * @return the length of the PriorityArray
		 */
		public function add( value:*, priority:Number ):uint
		{
			var len:uint = _values.length;
			for( var i:uint = 0; i < len; ++i )
			{
				if( _values[i].priority < priority )
				{
					break;
				}
			}
			_values.splice( i, 0, new Pair( priority, value ) );
			return _values.length;
		}
		
		/**
		 * Removes the value from the PriorityArray
		 * @param value The item to remove from the PriorityArray
		 * @return true if the item is removed, false if it doesn't exist in the 
		 * PriorityArray
		 */
		public function remove( value:* ):Boolean
		{
			for( var i:uint = _values.length; i--; )
			{
				if( _values[i].value == value )
				{
					_values.splice( i, 1 );
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Indicates if the value is in the PriorityArray
		 * @param value The item to look for in the PriorityArray
		 * @return true if the item is in the PriorityArray, false if it is not.
		 */
		public function contains( value:* ):Boolean
		{
			for( var i:uint = _values.length; i--; )
			{
				if( _values[i].value == value )
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Removes the item at a particular index from the PriorityArray
		 * 
		 * @param index the index in the PriorityArray of the item to be removed
		 * @return the item that was removed form the PriorityArray
		 */
		public function removeAt( index:uint ):*
		{
			var temp:* = _values[index].value;
			_values.splice( index, 1 );
			return temp;
		}
		
		/**
		 * Empties the PriorityArray. After calling this method the PriorityArray 
		 * contains no items.
		 */
		public function clear():void
		{
			_values.length = 0;
		}
		
		/**
		 * The number of items in the PriorityArray
		 */
		public function get length():uint
		{
			return _values.length;
		}
	}
}

class Pair
{
	internal var priority:Number;
	internal var value:*;
	
	public function Pair( priority:Number, value:* )
	{
		this.priority = priority;
		this.value = value;
	}
}