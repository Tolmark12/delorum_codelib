/*
 * FLINT PARTICLE SYSTEM
 * http://org.flintparticles.twoD.org/
 * ..........................
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
	import org.flintparticles.threeD.geom.Quaternion;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.geom.Vector3DUtils;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The RotateToDirection action updates the rotation of the particle 
	 * so that it always points in the direction it is traveling.
	 */

	public class RotateToDirection extends ActionBase
	{
		/**
		 * The constructor creates a RotateToDirection action for use by 
		 * an emitter. To add a RotateToDirection to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 */
		public function RotateToDirection()
		{
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter : Emitter, particle : Particle, time : Number ) : void
		{
			var p:Particle3D = Particle3D( particle );
			if( p.velocity.equals( Vector3D.ZERO ) )
			{
				return;
			}
			var target:Vector3D = p.velocity.unit();
			if( target.equals( p.faceAxis ) )
			{
				p.rotation = Quaternion.IDENTITY.clone();
				return;
			}
			if( target.equals( p.faceAxis.negative ) )
			{
				var v:Vector3D = Vector3DUtils.getPerpendicular( p.faceAxis );
				p.rotation = new Quaternion( 0, v.x, v.y, v.z );
				return;
			}
			var axis:Vector3D = target.crossProduct( p.faceAxis );
			var angle:Number = Math.acos( p.faceAxis.dotProduct( target ) );
			p.rotation.setFromAxisRotation( axis, angle );
		}
	}
}
