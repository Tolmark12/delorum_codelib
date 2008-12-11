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

	/**
	 * The Initializer interface must be implemented by all particle initializers.
	 * 
	 * <p>An Initializer is a class that is used to set properties of a particle 
	 * when it is created. Initializers may, for example, set an initial velocity
	 * for a particle.</p>
	 * 
	 * <p>Initializers are directly associated with emitters and act on all
	 * particles created by that emitter. Initializers are applied to 
	 * all particles created by an emitter by using the emitter's addInitializer 
	 * method. Initializers are removed from the emitter by using the emitter's
	 * removeInitializer method.<p>
	 * 
	 * <p>The key method in the Initializer interface is the initiaize method.
	 * This is called for every particle and is where the initializer modifies 
	 * the particle's properties.</p>
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 * @see org.flintparticles.common.emitters.Emitter#removeInitializer()
	 */
	public interface Initializer
	{
		/**
		 * The getDefaultPriority method is used to order the execution of 
		 * initializers. It should return a number indicating the priority 
		 * for the execution of the initializer. Initializers with a higher 
		 * priority are run before initializers with a lower priority.
		 * 
		 * <p>The initializers within the Flint library use 0 as the default 
		 * priority. Initializers that need to be called early may have 
		 * priorities of 10 or 20. Initializers that need to be called late 
		 * would have priorities of -10 or -20.</p>
		 * 
		 * <p>The default priority can be overridden when adding an initializer to
		 * an emitter by setting a new priority in the second parameter of the
		 * addInitalizer method of the emitter.</p>
		 * 
		 * <p>The method is called internally by the emitter and need not be called 
		 * directly by the user.</p>
	 	 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitalizer()
		 */
		function getDefaultPriority():Number;
		
		/**
		 * The addedToEmitter method is called by the emitter when the Initializer 
		 * is added to it. It is an opportunity for the initializer to do any
		 * initializing that is relative to the emitter. Only a few initializers
		 * make use of this method. It is called within the emitter's addInitializer 
		 * method and need not be called by the user.
		 * 
		 * @param emitter The Emitter that the Initializer was added to.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		function addedToEmitter( emitter:Emitter ):void;
		
		/**
		 * The removedFromEmitter method is called by the emitter when the Initializer 
		 * is removed from it. It is an opportunity for an initializer to do any
		 * finalizing that is relative to the emitter. Only a few initializers make 
		 * use of this method. It is called within the  emitter's removeInitializer 
		 * method and need not be called by the user.
		 * 
		 * @param emitter The Emitter that the Initializer was removed from.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#removeInitializer()
		 */
		function removedFromEmitter( emitter:Emitter ):void;
		
		/**
		 * The initialize method is used by the emitter to apply the initialization
		 * to every particle. It is the key feature of the initializers and is
		 * used to initialize the state of every particle. This method 
		 * is called within the emitter's createParticle met6hod for every particle 
		 * and need not be called by the user.
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be initialized.
		 */
		function initialize( emitter:Emitter, particle:Particle ):void;
	}
}