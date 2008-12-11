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
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;			

	/**
	 * The KeyDownAction Action uses another action. It applies the other action
	 * to the particles only if a specified key is down.
	 * 
	 * @see org.flintparticles.common.actions.Action
	 */

	public class KeyDownAction extends ActionBase
	{
		private var _action:Action;
		private var _keyCode:uint;
		private var _isDown:Boolean;
		
		/**
		 * The constructor creates a KeyDownAction action for use by 
		 * an emitter. To add a KeyDownAction to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param action The action to apply when the key is down.
		 * @param keyCode The key code of the key that controls the action.
		 * @param stage A reference to the stage.
		 */
		public function KeyDownAction( action:Action, keyCode:uint, stage:Stage )
		{
			_action = action;
			_keyCode = keyCode;
			_isDown = false;
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true );
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpListener, false, 0, true );
		}
		
		private function keyDownListener( ev:KeyboardEvent ):void
		{
			if( ev.keyCode == _keyCode )
			{
				_isDown = true;
			}
		}
		private function keyUpListener( ev:KeyboardEvent ):void
		{
			if( ev.keyCode == _keyCode )
			{
				_isDown = false;
			}
		}

		/**
		 * The action to apply when the key is down.
		 */
		public function get action():Action
		{
			return _action;
		}
		public function set action( value:Action ):void
		{
			_action = value;
		}
		
		/**
		 * The key code of the key that controls the action.
		 */
		public function get keyCode():uint
		{
			return _keyCode;
		}
		public function set keyCode( value:uint ):void
		{
			_keyCode = value;
		}
		
		/**
		 * Returns the default priority of the action that is applied.
		 * 
		 * @see org.flintparticles.common.actions.Action#getDefaultPriority()
		 */
		override public function getDefaultPriority():Number
		{
			return _action.getDefaultPriority();
		}
		
		/**
		 * Calls the addedToEmitter method of the action that is applied
		 * 
		 * @param emitter The Emitter that the Action was added to.
		 * 
		 * @see org.flintparticles.common.actions.Action#addedToEmitter()
		 */
		override public function addedToEmitter( emitter:Emitter ):void
		{
			_action.addedToEmitter( emitter );
		}
		
		/**
		 * Calls the removedFromEmitter method of the action that is applied
		 * 
		 * @param emitter The Emitter that the Action was removed from.
		 * 
		 * @see org.flintparticles.common.actions.Action#removedFromEmitter()
		 */
		override public function removedFromEmitter( emitter:Emitter ):void
		{
			_action.removedFromEmitter( emitter );
		}

		/**
		 * If the key is down, this method calls the update method of the 
		 * action that is applied.
		 * 
		 * <p>This method is called by the emitter and need not be called by the 
		 * user</p>
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be updated.
		 * @param time The duration of the frame - used for time based updates.
		 * 
		 * @see org.flintparticles.common.actions.Action#update()
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			if( _isDown )
			{
				_action.update( emitter, particle, time );
			}
		}
	}
}
