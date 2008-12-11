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

package org.flintparticles.common.actions
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;	

	/**
	 * The Action interface must be implemented by all particle actions.
	 * 
	 * <p>An Action is a class that is used to continuously modify an aspect 
	 * of a particle by updating the particle every frame. Actions may, for 
	 * example, move the particle or modify its velocity.</p>
	 * 
	 * <p>Actions are directly associated with emitters and act on all
	 * particles created or added to that emitter. Actions are applied to 
	 * all particles created by an emitter by using the emitter's addAction 
	 * method. Actions are removed from the emitter by using the emitter's
	 * removeAction method.<p>
	 * 
	 * <p>The key method in the Action interface is the update method.
	 * This is called every frame, for every particle and is where the
	 * action modifies the particle's properties.</p>
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * @see org.flintparticles.common.emitters.Emitter#removeAction()
	 */
	public interface Action
	{
		/**
		 * The getDefaultPriority method is used to order the execution of actions.
		 * It should return a number indicating the priority for the execution of
		 * the action. Actions with a higher priority are run before actions with
		 * a lower priority.
		 * 
		 * <p>The actions within the Flint library use 0 as the default priority. Some
		 * actions that need to be called early have priorities of 10 or 20. Actions
		 * that need to be called late have priorities of -10 or -20.</p>
		 * 
		 * <p>For example, the move action has a priority of -20 because the movement
		 * should be performed last, after other actions have made any changes
		 * to the particle's velocity.</p>
		 * 
		 * <p>The default priority can be overridden when adding an action to
		 * an emitter by setting a new priority in the second parameter of the
		 * addAction method of the emitter.</p>
		 * 
		 * <p>The method is called internally by the emitter and need not be called 
		 * directly by the user.</p>
	 	 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 */
		function getDefaultPriority():Number;
		
		/**
		 * The addedToEmitter method is called by the emitter when the Action is 
		 * added to it. It is an opportunity for an action to do any initializing
		 * that is relative to the emitter. Only a few actions make use of this
		 * method. It is called within the emitter's addAction method and need not 
		 * be called by the user.
		 * 
		 * @param emitter The Emitter that the Action was added to.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 */
		function addedToEmitter( emitter:Emitter ):void;
		
		/**
		 * The removedFromEmitter method is called by the emitter when the Action 
		 * is removed from it. It is an opportunity for an action to do any
		 * finalizing that is relative to the emitter. Only a few actions make 
		 * use of this method. It is called within the  emitter's removeAction 
		 * method and need not be called by the user.
		 * 
		 * @param emitter The Emitter that the Action was removed from.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#removeAction()
		 */
		function removedFromEmitter( emitter:Emitter ):void;
		
		/**
		 * The update method is used by the emitter to apply the action
		 * to every particle. It is the key feature of the actions and is
		 * used to update the state of every particle every frame. This method 
		 * is called within the emitter's update loop for every particle 
		 * and need not be called by the user.
		 * 
		 * <p>Because the method is called for every particle, every frame it is
		 * a key area for optimization of the code. When creating a custom action
		 * it is usually worth making this method as efficient as possible.</p>
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be updated.
		 * @param time The duration of the frame - used for time based updates.
		 */
		function update( emitter:Emitter, particle:Particle, time:Number ):void;
	}
}