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
	import org.flintparticles.threeD.geom.Vector3D;	

	/**
	 * The AntiGravity action applies a force to the particle to push it away from
	 * a single point - the center of the effect. The force applied is inversely 
	 * proportional to the square of the distance from the particle to the point.
	 */

	public class AntiGravity extends GravityWell
	{
		/**
		 * The constructor creates an AntiGravity action for use by an emitter. 
		 * To add an AntiGravity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the force - larger numbers produce a 
		 * stronger force.
		 * @param position The point in 3D space that the force pushes the 
		 * particles away from.
		 * @param epsilon The minimum distance for which the anti-gravity force is 
		 * calculated. Particles closer than this distance experience the 
		 * anti-gravity as it they were this distance away. This stops the 
		 * anti-gravity effect blowing up as distances get very small.
		 */
		public function AntiGravity( power:Number, position:Vector3D, epsilon:Number = 1 )
		{
			super( -power, position, epsilon );
		}
		
		/**
		 * The strength of the anti-gravity force - larger numbers produce a 
		 * stronger force.
		 */
		override public function get power():Number
		{
			return -super.power;
		}
		override public function set power( value:Number ):void
		{
			super.power = -value;
		}
	}
}
