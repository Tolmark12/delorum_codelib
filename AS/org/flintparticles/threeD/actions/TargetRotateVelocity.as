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
	 * The TargetRotateVelocity action adjusts the angular velocity of the particle towards the target angular velocity.
	 */
	public class TargetRotateVelocity extends ActionBase
	{
		private var _vel:Vector3D;
		private var _rate:Number;
		
		/**
		 * The constructor creates a TargetRotateVelocity action for use by 
		 * an emitter. To add a TargetRotateVelocity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param axis The axis the velocity acts around.
		 * @param angVelocity The target angular velocity, in radians per second.
		 * @param rate Adjusts how quickly the particle reaches the target angular velocity.
		 * Larger numbers cause it to approach the target angular velocity more quickly.
		 */
		public function TargetRotateVelocity( axis:Vector3D, angVelocity:Number, rate:Number = 0.1 )
		{
			_vel = axis.unit().scaleBy( angVelocity );
			_rate = rate;
		}
		
		/**
		 * The target angular velocity, in radians per second.
		 */
		public function setTargetVelocity( axis:Vector3D, angVelocity:Number ):void
		{
			_vel = axis.unit().scaleBy( angVelocity );
		}
		
		/**
		 * Adjusts how quickly the particle reaches the target angular velocity.
		 * Larger numbers cause it to approach the target angular velocity more quickly.
		 */
		public function get rate():Number
		{
			return _rate;
		}
		public function set rate( value:Number ):void
		{
			_rate = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			p.angVelocity.incrementBy( _vel.subtract( p.angVelocity ).scaleBy( _rate * time ) );
		}
	}
}
