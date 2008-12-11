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

package org.flintparticles.twoD.initializers 
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.RatioArray;	

	/**
	 * The ScaleAllsInit initializer sets the scale of the particles image
	 * and adjusts its mass and collision radius accordingly. It selects 
	 * one of multiple scales, using optional weighting values to produce an uneven
	 * distribution for the scales.
	 * 
	 * <p>If you want to adjust only the image size use
	 * the ScaleImageInit initializer.</p>
	 * 
	 * @see org.flintparticles.common.initializers.ScaleImagesInit
	 */

	public class ScaleAllsInit extends InitializerBase
	{
		private var _scales:RatioArray;
		
		/**
		 * The constructor creates a ScaleAllsInit initializer for use by 
		 * an emitter. To add a ScaleAllsInit to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param colors An array containing the scales to use for 
		 * each particle created by the emitter.
		 * @param weights The weighting to apply to each scale. If no weighting
		 * values are passed, the scales are all assigned a weighting of 1.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function ScaleAllsInit( scales:Array, weights:Array = null )
		{
			_scales = new RatioArray;
			var len:int = scales.length;
			var i:int;
			if( weights != null && weights.length == len )
			{
				for( i = 0; i < len; ++i )
				{
					_scales.add( scales[i], weights[i] );
				}
			}
			else
			{
				for( i = 0; i < len; ++i )
				{
					_scales.add( scales[i], 1 );
				}
			}
		}
		
		public function addScale( scale:Number, weight:Number = 1 ):void
		{
			_scales.add( scale, weight );
		}
		
		public function removeScale( scale:Number ):void
		{
			_scales.remove( scale );
		}

		/**
		 * @inheritDoc
		 * 
		 * returns -10 to ensure it occurs after the mass and radius assignment classes 
		 * classes like CollisionRadiusInit and MassInit.
		 */
		override public function getDefaultPriority():Number
		{
			return -10;
		}

		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			var scale:Number = _scales.getRandomValue();
			particle.scale = scale;
			particle.mass *= scale * scale;
			particle.collisionRadius *= scale;
		}
	}
}
