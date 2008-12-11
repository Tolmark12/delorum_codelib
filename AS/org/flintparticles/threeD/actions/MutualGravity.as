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
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The MutualGravity Action applies forces to attract each particle towards the other particles.
	 */
	public class MutualGravity extends ActionBase
	{
		private var _power:Number;
		private var _maxDistance:Number;
		private var _maxDistanceSq:Number;
		private var _epsilonSq:Number;
		private var _gravityConst:Number = 1000; // scale sthe power
		
		/*
		 * Temporary variables created as class members to avoid creating new objects all the time
		 */
		private var d:Vector3D;
		
		/**
		 * The constructor creates a MutualGravity action for use by 
		 * an emitter. To add a MutualGravity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the gravitational pull between the particles.
		 * @param maxDistance The maximum distance between particles for the gravitational
		 * effect to be calculated. You can speed up this action by reducing the maxDistance
		 * since often only the closest other particles have a significant effect on the 
		 * motion of a particle.
		 */
		public function MutualGravity( power:Number, maxDistance:Number, epsilon:Number = 1 )
		{
			this.power = power;
			this.maxDistance = maxDistance;
			this.epsilon = epsilon;
			d = new Vector3D();
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
		 * The maximum distance between particles for the gravitational
		 * effect to be calculated. You can speed up this action by reducing the maxDistance
		 * since often only the closest other particles have a significant effect on the 
		 * motion of a particle.
		 */
		public function get maxDistance():Number
		{
			return _maxDistance;
		}
		public function set maxDistance( value:Number ):void
		{
			_maxDistance = value;
			_maxDistanceSq = value * value;
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
		 * 
		 * <p>Returns a value of 10, so that the MutualGravity action executes before other actions.</p>
		 */
		override public function getDefaultPriority():Number
		{
			return 10;
		}

		/**
		 * @inheritDoc
		 */
		override public function addedToEmitter( emitter:Emitter ) : void
		{
			Emitter3D( emitter ).spaceSort = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter : Emitter, particle : Particle, time : Number ) : void
		{
			if( particle.mass == 0 )
			{
				return;
			}
			var p:Particle3D = Particle3D( particle );
			var e:Emitter3D = Emitter3D( emitter );
			var particles:Array = e.particles;
			var sortedX:Array = e.spaceSortedX;
			var other:Particle3D;
			var i:int;
			var len:int = particles.length;
			var factor:Number;
			var distance:Number;
			var distanceSq:Number;
			for( i = p.sortID + 1; i < len; ++i )
			{
				other = particles[sortedX[i]];
				if( other.mass == 0 )
				{
					continue;
				}
				if( ( d.x = other.position.x - p.position.x ) > _maxDistance ) break;
				d.y = other.position.y - p.position.y;
				if( d.y > _maxDistance || d.y < -_maxDistance ) continue;
				d.z = other.position.z - p.position.z;
				if( d.z > _maxDistance || d.z < -_maxDistance ) continue;
				distanceSq = d.lengthSquared;
				if( distanceSq <= _maxDistanceSq && distanceSq > 0 )
				{
					distance = Math.sqrt( distanceSq );
					if( distanceSq < _epsilonSq )
					{
						distanceSq = _epsilonSq;
					}
					factor = ( _power * time ) / ( distanceSq * distance );
					p.velocity.incrementBy( d.scaleBy( factor * other.mass ) );
					other.velocity.decrementBy( d.scaleBy( p.mass / other.mass ) );
				} 
			}
		}
	}
}
