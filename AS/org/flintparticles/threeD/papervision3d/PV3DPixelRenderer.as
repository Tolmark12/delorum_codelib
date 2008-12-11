package org.flintparticles.threeD.papervision3d 
{
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.renderers.RendererBase;
	import org.flintparticles.threeD.particles.Particle3D;
	import org.papervision3d.core.geom.Pixels;
	import org.papervision3d.core.geom.renderables.Pixel3D;	

	/**
	 * Renders the particles as pixels in a Papervision3D Pixels object.
	 * 
	 * <p>This renderer fails to work because of a bug in Papervision3D. The bug report and fix are
	 * at <a href="http://code.google.com/p/papervision3d/issues/detail?id=102">http://code.google.com/p/papervision3d/issues/detail?id=102</a>.
	 * Hopefully the fix will be included in a later version of Papervision3D.</p>
	 */
	public class PV3DPixelRenderer extends RendererBase
	{
		private var _container:Pixels;
		
		public function PV3DPixelRenderer( container:Pixels )
		{
			super();
			_container = container;
		}
		
		/**
		 * This method applies the particle's state to the associated image object.
		 * 
		 * <p>This method is called internally by Flint and shouldn't need to be called
		 * by the user.</p>
		 * 
		 * @param particles The particles to be rendered.
		 */
		override protected function renderParticles( particles:Array ):void
		{
			var o:Pixel3D;
			for each( var p:Particle3D in particles )
			{
				o = p.image;
				o.x = p.position.x;
				o.y = p.position.y;
				o.z = p.position.z;
				o.color = p.color;
			}
		}
		
		/**
		 * This method is called when a particle is added to an emitter -
		 * usually because the emitter has just created the particle. The
		 * method adds the particle's image to the container's display list.
		 * It is called internally by Flint and need not be called by the user.
		 * 
		 * @param particle The particle being added to the emitter.
		 */
		override protected function addParticle( particle:Particle ):void
		{
			particle.image = new Pixel3D( 0 );
			_container.addPixel3D( Pixel3D( particle.image ) );
		}
		
		/**
		 * This method is called when a particle is removed from an emitter -
		 * usually because the particle is dying. The method removes the 
		 * particle's image from the container's display list. It is called 
		 * internally by Flint and need not be called by the user.
		 * 
		 * @param particle The particle being removed from the emitter.
		 */
		override protected function removeParticle( particle:Particle ):void
		{
			_container.removePixel3D( Pixel3D( particle.image ) );
		}
	}
}
