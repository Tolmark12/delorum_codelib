
package org.flintparticles.common.renderers 
{
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
	public class RendererBase implements Renderer 
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
		public function RendererBase()
		{
			_emitters = new Array();
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
			emitter.addEventListener( EmitterEvent.EMITTER_UPDATED, emitterUpdated, false, 0, true );
			emitter.addEventListener( ParticleEvent.PARTICLE_CREATED, particleAdded, false, 0, true );
			emitter.addEventListener( ParticleEvent.PARTICLE_ADDED, particleAdded, false, 0, true );
			emitter.addEventListener( ParticleEvent.PARTICLE_DEAD, particleRemoved, false, 0, true );
			for each( var p:Particle in emitter.particles )
			{
				addParticle( p );
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
					return;
				}
			}
		}
		
		private function particleAdded( ev:ParticleEvent ):void
		{
			addParticle( ev.particle );
		}
		
		private function particleRemoved( ev:ParticleEvent ):void
		{
			removeParticle( ev.particle );
		}

		private function emitterUpdated( ev:EmitterEvent ):void
		{
			renderParticles( Emitter( ev.target ).particles );
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
	}
}
