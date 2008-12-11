
package org.flintparticles.common.renderers 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.renderers.Renderer;	

	/**
	 * The base class used by all the Flint renderers. This class manages
	 * various aspects of the rendering process.
	 * 
	 * <p>The class will add every emitter it should renderer to it's internal
	 * array of emitters. It will listen for the appropriate events on the 
	 * emitter and will then call the protected methods addParticle, removeParticle
	 * and renderParticles at the appropriate times. Many derived classes need 
	 * only implement these three methods to manage the rendering of the particles.</p>
	 */
	public class SpriteRendererBase extends Sprite implements Renderer 
	{
		/**
		 * @private
		 * 
		 * We retain assigned emitters in this array merely so the reference exists and they are not
		 * garbage collected. This ensures the expected behaviour is achieved - an emitter that exists
		 * on a renderer is not garbage collected, an emitter that does not exist on a renderer may be 
		 * garbage collected if no other references exist.
		 */
		protected var _emitters:Array;
		
		/**
		 * The constructor creates a RendererBase class.
		 */
		public function SpriteRendererBase()
		{
			_emitters = new Array();
			mouseEnabled = false;
			mouseChildren = false;
			addEventListener( Event.ADDED_TO_STAGE, addedToStage, false, 0, true );
		}
		
		/**
		 * Adds the emitter to the renderer. When an emitter is added, the renderer
		 * invalidates its display so the renderParticles method will be called
		 * on the next render event in the frame update.
		 * 
		 * @param emitter The emitter that is added to the renderer.
		 */
		public function addEmitter( emitter : Emitter ) : void
		{
			_emitters.push( emitter );
			if( stage )
			{
				stage.invalidate();
			}
			emitter.addEventListener( EmitterEvent.EMITTER_UPDATED, emitterUpdated, false, 0, true );
			emitter.addEventListener( ParticleEvent.PARTICLE_CREATED, particleAdded, false, 0, true );
			emitter.addEventListener( ParticleEvent.PARTICLE_ADDED, particleAdded, false, 0, true );
			emitter.addEventListener( ParticleEvent.PARTICLE_DEAD, particleRemoved, false, 0, true );
			for each( var p:Particle in emitter.particles )
			{
				addParticle( p );
			}
			if( _emitters.length == 1 )
			{
				addEventListener( Event.RENDER, updateParticles, false, 0, true );
			}
		}

		/**
		 * Removes the emitter from the renderer. When an emitter is removed, the renderer
		 * invalidates its display so the renderParticles method will be called
		 * on the next render event in the frame update.
		 * 
		 * @param emitter The emitter that is removed from the renderer.
		 */
		public function removeEmitter( emitter : Emitter ) : void
		{
			for( var i:int = 0; i < _emitters.length; ++i )
			{
				if( _emitters[i] == emitter )
				{
					_emitters.splice( i, 1 );
					emitter.removeEventListener( EmitterEvent.EMITTER_UPDATED, emitterUpdated );
					emitter.removeEventListener( ParticleEvent.PARTICLE_CREATED, particleAdded );
					emitter.removeEventListener( ParticleEvent.PARTICLE_ADDED, particleAdded );
					emitter.removeEventListener( ParticleEvent.PARTICLE_DEAD, particleRemoved );
					for each( var p:Particle in emitter.particles )
					{
						removeParticle( p );
					}
					if( _emitters.length == 0 )
					{
						removeEventListener( Event.RENDER, updateParticles );
						renderParticles( [] );
					}
					else
					{
						stage.invalidate();
					}
					return;
				}
			}
		}
		
		private function addedToStage( ev:Event ):void
		{
			if( stage )
			{
				stage.invalidate();
			}
		}
		
		private function particleAdded( ev:ParticleEvent ):void
		{
			addParticle( ev.particle );
			if( stage )
			{
				stage.invalidate();
			}
		}
		
		private function particleRemoved( ev:ParticleEvent ):void
		{
			removeParticle( ev.particle );
			if( stage )
			{
				stage.invalidate();
			}
		}

		private function emitterUpdated( ev:EmitterEvent ):void
		{
			if( stage )
			{
				stage.invalidate();
			}
		}
		
		private function updateParticles( ev:Event ) : void
		{
			var particles:Array = new Array();
			for( var i:int = 0; i < _emitters.length; ++i )
			{
				particles = particles.concat( _emitters[i].particles );
			}
			renderParticles( particles );
		}
		
		
		
		/**
		 * The addParticle method is called when a particle is added to one of
		 * the emitters that is being rendered by this renderer.
		 * 
		 * @param particle The particle.
		 */
		protected function addParticle( particle:Particle ):void
		{
		}
		
		/**
		 * The removeParticle method is called when a particle is removed from one
		 * of the emitters that is being rendered by this renderer.
		 * @param particle The particle.
		 */
		protected function removeParticle( particle:Particle ):void
		{
		}
		
		/**
		 * The renderParticles method is called during the render phase of 
		 * every frame if the state of one of the emitters being rendered
		 * by this renderer has changed.
		 * 
		 * @param particles The particles being managed by all the emitters
		 * being rendered by this renderer. The particles are in no particular
		 * order.
		 */
		protected function renderParticles( particles:Array ):void
		{
		}

		public function get emitters():Array
		{
			return _emitters;
		}
	}
}
