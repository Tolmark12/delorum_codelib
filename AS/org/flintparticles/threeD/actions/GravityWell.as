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

package org.flintparticles.threeD.actions 
{
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The GravityWell action applies a force on the particle to draw it towards
	 * a single point. The force applied is inversely proportional to the square
	 * of the distance from the particle to the point.
	 */

	public class GravityWell extends ActionBase
	{
		private var _position:Vector3D;
		private var _power:Number;
		private var _epsilonSq:Number;
		private var _gravityConst:Number = 10000; // just scales the power to a more reasonable number
		
		/**
		 * The constructor creates a GravityWell action for use by 
		 * an emitter. To add a GravityWell to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the force - larger numbers produce a stringer force.
		 * @param x The x coordinate of the point towards which the force draws the particles.
		 * @param y The y coordinate of the point towards which the force draws the particles.
		 * @param epsilon The minimum distance for which gravity is calculated. Particles closer
		 * than this distance experience a gravity force as it they were this distance away.
		 * This stops the gravity effect blowing up as distances get small. For realistic gravity 
		 * effects you will want a small epsilon ( ~1 ), but for stable visual effects a larger
		 * epsilon (~100) is often better.
		 */
		public function GravityWell( power:Number, position:Vector3D, epsilon:Number = 100 )
		{
			this.power = power;
			this.position = position;
			this.epsilon = epsilon;
		}
		
		/**
		 * The strength of the gravity force.
		 */
		public function get power():Number
		{
			return _power / _gravityConst;
		}
		public function set power( value:Number ):void
		{
			_power = value * _gravityConst;
		}
		
		/**
		 * The x coordinate of the center of the gravity force.
		 */
		public function get position():Vector3D
		{
			return _position;
		}
		public function set position( value:Vector3D ):void
		{
			_position = value.clone();
			_position.w = 1;
		}
		
		/**
		 * The minimum distance for which the gravity force is calculated. 
		 * Particles closer than this distance experience the gravity as it they were 
		 * this distance away. This stops the gravity effect blowing up as distances get 
		 * small.
		 */
		public function get epsilon():Number
		{
			return Math.sqrt( _epsilonSq );
		}
		public function set epsilon( value:Number ):void
		{
			_epsilonSq = value * value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			if( particle.mass == 0 )
			{
				return;
			}
			var p:Particle3D = Particle3D( particle );
			var offset:Vector3D = _position.subtract( p.position );
			var dSq:Number = offset.lengthSquared;
			if( dSq == 0 )
			{
				return;
			}
			var d:Number = Math.sqrt( dSq );
			if( dSq < _epsilonSq ) dSq = _epsilonSq;
			var factor:Number = ( _power * time ) / ( dSq * d );
			p.velocity.incrementBy( offset.scaleBy( factor ) );
		}
	}
}
