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

package org.flintparticles.common.initializers 
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.PriorityArray;	

	/**
	 * The InitializerGroup initializer collects a number of initializers into a single 
	 * larger initializer that applies all the grouped initializers to a particle. It is
	 * commonly used with the ChooseInitializer initializer to choose from different
	 * groups of initializers when initializing a particle.
	 * 
	 * @see org.flintparticles.common.initializers.ChooseInitializer
	 */

	public class InitializerGroup extends InitializerBase
	{
		private var _initializers:PriorityArray;
		private var _emitter:Emitter;
		
		/**
		 * The constructor creates a MassesInit initializer for use by 
		 * an emitter. To add a MassesInit to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param colors An array containing the Colors to use for 
		 * each particle created by the emitter, as 32bit ARGB values.
		 * @param weights The weighting to apply to each color. If no weighting
		 * values are passed, the colors are all assigned a weighting of 1.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function InitializerGroup( ...initializers )
		{
			_initializers = new PriorityArray();
		}
		
		public function addInitializer( initializer:Initializer, priority:Number = NaN ):void
		{
			if( isNaN( priority ) )
			{
				priority = initializer.getDefaultPriority();
			}
			_initializers.add( initializer, priority );
			if( _emitter )
			{
				initializer.addedToEmitter( _emitter );
			}
		}
		
		public function removeScale( initializer:Initializer ):void
		{
			if( _initializers.remove( initializer ) )
			{
				if( _emitter )
				{
					initializer.removedFromEmitter( _emitter );
				}
			}
		}
		
		override public function addedToEmitter( emitter:Emitter ):void
		{
			_emitter = emitter;
			var len:uint = _initializers.length;
			for( var i:uint = 0; i < len; ++i )
			{
				Initializer( _initializers[i] ).addedToEmitter( emitter );
			}
		}

		override public function removedFromEmitter( emitter:Emitter ):void
		{
			var len:uint = _initializers.length;
			for( var i:uint = 0; i < len; ++i )
			{
				Initializer( _initializers[i] ).removedFromEmitter( emitter );
			}
			_emitter = null;
		}

		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			var len:uint = _initializers.length;
			for( var i:uint = 0; i < len; ++i )
			{
				Initializer( _initializers[i] ).initialize( emitter, particle );
			}
		}
	}
}
