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

package org.flintparticles.common.activities
{
	import org.flintparticles.common.emitters.Emitter;
	
	/**
	 * The Activity interface must be implemented by all emitter activities.
	 * 
	 * <p>An Activity is a class that is used to continuously modify an aspect 
	 * of an emitter by updating the emitter every frame. Activities may, for 
	 * example, move or rotate the emitter.</p>
	 * 
	 * <p>Activities are associated with emitters by using the emitter's 
	 * addActivity method. Activities are removed from the emitter by using 
	 * the emitter's removeActivity method.<p>
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addActivity()
	 * @see org.flintparticles.common.emitters.Emitter#removeActivity()
	 */
	public interface Activity
	{
		/**
		 * The getDefaultPriority method is used to order the execution of activities.
		 * It should return a number indicating the priority for the execution of
		 * the activity. Activities with a higher priority are run before activities 
		 * with a lower priority.
		 * 
		 * <p>The activities within the Flint library use 0 as the default priority. 
		 * Activities that need to be called early would have priorities of 10 or 20. 
		 * Activities that need to be called late would have priorities of -10 or -20.</p>
		 * 
		 * <p>The default priority can be overridden when adding an activity to
		 * an emitter by setting a new priority in the second parameter of the
		 * addActivity method of the emitter.</p>
		 * 
		 * <p>The getDefaultPriority method is called internally by the emitter 
		 * and need not be called directly by the user.</p>
	 	 * 
		 * @see org.flintparticles.common.emitters.Emitter#addActivity()
		 */
		function getDefaultPriority():Number;
		
		/**
		 * The addedToEmitter method is called by the emitter when the Activity is 
		 * added to it. It is an opportunity for an activity to do any initializing
		 * that is relative to the emitter. Only a few activities make use of this
		 * method. It is called within the emitter's addActivity method and need not 
		 * be called by the user.
		 * 
		 * @param emitter The Emitter that the Activity was added to.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addActivity()
		 */
		function addedToEmitter( emitter:Emitter ):void;
		
		/**
		 * The removedFromEmitter method is called by the emitter when the Activity 
		 * is removed from it. It is an opportunity for an activity to do any
		 * finalizing that is relative to the emitter. Only a few activities make 
		 * use of this method. It is called within the emitter's removeActivity 
		 * method and need not be called by the user.
		 * 
		 * @param emitter The Emitter that the Activity was removed from.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#removeActivity()
		 */
		function removedFromEmitter( emitter:Emitter ):void;
		
		/**
		 * The initialize method is used by the emitter to start the activity.
		 * It is called within the emitter's start method and need not
		 * be called by the user.
		 * 
		 * @param emitter The Emitter that is using the activity.
		 */
		function initialize( emitter:Emitter ):void;
		
		/**
		 * The update method is used by the emitter to apply the activity.
		 * It is the key feature of the activity and is used to update the state
		 * of the emitter. This method is called within the emitter's update loop 
		 * and need not be called by the user.
		 * 
		 * @param emitter The Emitter that is using the activity.
		 * @param time The duration of the frame (in seconds) - used for time based 
		 * updates.
		 */
		function update( emitter:Emitter, time:Number ):void;
	}
}