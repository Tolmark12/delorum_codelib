﻿/*
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

package org.flintparticles.threeD.renderers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flintparticles.common.renderers.SpriteRendererBase;
	import org.flintparticles.threeD.geom.Matrix3D;	
	import org.flintparticles.threeD.geom.Quaternion;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The BitmapRenderer is a native Flint 3D renderer that draws particles
	 * onto a single Bitmap display object. The particles are drawn face-on to the
	 * camera, with perspective applied to position and scale the particles.
	 * 
	 * <p>The region of the projection plane drawn by this renderer must be 
	 * defined in the canvas property of the BitmapRenderer. Particles outside this 
	 * region are not drawn.</p>
	 * 
	 * <p>The image to be used for each particle is the particle's image property.
	 * This is a DisplayObject, but this DisplayObject is not used directly. Instead
	 * it is copied into the bitmap with the various properties of the particle 
	 * applied, including 3D positioning and perspective relative to the renderer's
	 * camera position. Consequently each particle may be represented by the same 
	 * DisplayObject instance and the SharedImage initializer can be used with this 
	 * renderer.</p>
	 * 
	 * <p>The BitmapRenderer allows the use of BitmapFilters to modify the appearance
	 * of the bitmap. Every frame, under normal circumstances, the Bitmap used to
	 * display the particles is wiped clean before all the particles are redrawn.
	 * However, if one or more filters are added to the renderer, the filters are
	 * applied to the bitmap instead of wiping it clean. This enables various trail
	 * effects by using blur and other filters.</p>
	 * 
	 * <p>The BitmapRenderer has mouse events disabled for itself and any 
	 * display objects in its display list. To enable mouse events for the renderer
	 * or its children set the mouseEnabled or mouseChildren properties to true.</p>
	 */
	public class BitmapRenderer extends SpriteRendererBase
	{
		protected static var ZERO_POINT:Point = new Point( 0, 0 );

		protected var toDegrees:Number = 180 / Math.PI;
		
		/**
		 * @private
		 */
		protected var _zSort:Boolean;
		/**
		 * @private
		 */
		protected var _camera:Camera;

		/**
		 * @private
		 */
		protected var _bitmap:Bitmap;
		/**
		 * @private
		 */
		protected var _preFilters:Array;
		/**
		 * @private
		 */
		protected var _postFilters:Array;
		/**
		 * @private
		 */
		protected var _paletteMap:Array;
		/**
		 * @private
		 */
		protected var _smoothing:Boolean;
		/**
		 * @private
		 */
		protected var _canvas:Rectangle;

		/**
		 * The constructor creates a BitmapRenderer. After creation it should be
		 * added to the display list of a DisplayObjectContainer to place it on 
		 * the stage.
		 * 
		 * <p>Emitter's should be added to the renderer using the renderer's
		 * addEmitter method. The renderer displays all the particles created
		 * by the emitter's that have been added to it.</p>
		 * 
		 * @param canvas The area within the renderer on which particles can be drawn.
		 * Particles outside this area will not be drawn.
		 * @param zSort Whether to sort the particles according to their
		 * z order when rendering them or not.
		 * @param smoothing Whether to use smoothing when scaling the Bitmap and, if the
		 * particles are represented by bitmaps, when drawing the particles.
		 * Smoothing removes pixelation when images are scaled and rotated, but it
		 * takes longer so it may slow down your particle system.
		 * 
		 * @see org.flintparticles.twoD.emitters.Emitter#renderer
		 */
		public function BitmapRenderer( canvas:Rectangle, zSort:Boolean = true, smoothing:Boolean = false )
		{
			_zSort = zSort;
			_camera = new Camera();
			mouseEnabled = false;
			mouseChildren = false;
			_zSort = zSort;
			_smoothing = smoothing;
			_preFilters = new Array();
			_postFilters = new Array();
			_canvas = canvas;
			createBitmap();
		}
		
		/**
		 * Indicates whether the particles should be sorted in distance order for display.
		 */
		public function get zSort():Boolean
		{
			return _zSort;
		}
		public function set zSort( value:Boolean ):void
		{
			_zSort = value;
		}
		
		/**
		 * The camera controls the view for the renderer
		 */
		public function get camera():Camera
		{
			return _camera;
		}
		public function set camera( value:Camera ):void
		{
			_camera = value;
		}
		
		/**
		 * The addFilter method adds a BitmapFilter to the renderer. These filters
		 * are applied each frame, before or after the new particle positions are 
		 * drawn, instead of wiping the display clear. Use of a blur filter, for 
		 * example, will produce a trail behind each particle as the previous images
		 * blur and fade more each frame.
		 * 
		 * @param filter The filter to apply
		 * @param postRender If false, the filter is applied before drawing the particles
		 * in their new positions. If true the filter is applied after drawing the particles.
		 */
		public function addFilter( filter:BitmapFilter, postRender:Boolean = false ):void
		{
			if( postRender )
			{
				_postFilters.push( filter );
			}
			else
			{
				_preFilters.push( filter );
			}
		}
		
		/**
		 * Removes a BitmapFilter object from the Renderer.
		 * 
		 * @param filter The BitmapFilter to remove
		 * 
		 * @see addFilter()
		 */
		public function removeFilter( filter:BitmapFilter ):void
		{
			for( var i:int = 0; i < _preFilters.length; ++i )
			{
				if( _preFilters[i] == filter )
				{
					_preFilters.splice( i, 1 );
					return;
				}
			}
			for( i = 0; i < _postFilters.length; ++i )
			{
				if( _postFilters[i] == filter )
				{
					_postFilters.splice( i, 1 );
					return;
				}
			}
		}
		
		/**
		 * Sets a palette map for the renderer. See the paletteMap method in flash's BitmapData object for
		 * information about how palette maps work. The palette map will be applied to the full canvas of the 
		 * renderer after all filters have been applied and the particles have been drawn.
		 */
		public function setPaletteMap( red : Array = null , green : Array = null , blue : Array = null, alpha : Array = null ) : void
		{
			_paletteMap = new Array(4);
			_paletteMap[0] = alpha;
			_paletteMap[1] = red;
			_paletteMap[2] = green;
			_paletteMap[3] = blue;
		}
		/**
		 * Clears any palette map that has been set for the renderer.
		 */
		public function clearPaletteMap() : void
		{
			_paletteMap = null;
		}
		
		/**
		 * Create the Bitmap and BitmapData objects
		 */
		protected function createBitmap():void
		{
			if( !_canvas )
			{
				return;
			}
			if( _bitmap && _bitmap.bitmapData )
			{
				_bitmap.bitmapData.dispose();
			}
			if( _bitmap )
			{
				removeChild( _bitmap );
			}
			_bitmap = new Bitmap( null, "auto", _smoothing);
			_bitmap.bitmapData = new BitmapData( _canvas.width, _canvas.height, true, 0 );
			addChild( _bitmap );
			_bitmap.x = _canvas.x;
			_bitmap.y = _canvas.y;
		}
		
		/**
		 * The canvas is the area within the renderer on which particles can be drawn.
		 * Particles outside this area will not be drawn.
		 */
		public function get canvas():Rectangle
		{
			return _canvas;
		}
		public function set canvas( value:Rectangle ):void
		{
			_canvas = value;
			createBitmap();
		}

		/**
		 * This method draws the particles in the bitmap image, positioning and
		 * scaling them according to their positions relative to the camera 
		 * viewport.
		 * 
		 * <p>This method is called internally by Flint and shouldn't need to be called
		 * by the user.</p>
		 * 
		 * @param particles The particles to be rendered.
		 */
		override protected function renderParticles( particles:Array ):void
		{
			if( !_bitmap )
			{
				return;
			}
			var transform:Matrix3D = _camera.transform;
			var i:int;
			var len:int;
			var particle:Particle3D;
			_bitmap.bitmapData.lock();
			len = _preFilters.length;
			for( i = 0; i < len; ++i )
			{
				_bitmap.bitmapData.applyFilter( _bitmap.bitmapData, _bitmap.bitmapData.rect, BitmapRenderer.ZERO_POINT, _preFilters[i] );
			}
			if( len == 0 && _postFilters.length == 0 )
			{
				_bitmap.bitmapData.fillRect( _bitmap.bitmapData.rect, 0 );
			}
			len = particles.length;
			for( i = 0; i < len; ++i )
			{
				particle = particles[i];
				particle.projectedPosition = transform.transformVector( particle.position );
				particle.zDepth = particle.projectedPosition.z;
			}
			if( _zSort )
			{
				particles.sort( sortOnZ );
			}
			for( i = 0; i < len; ++i )
			{
				drawParticle( particles[i] );
			}
			len = _postFilters.length;
			for( i = 0; i < len; ++i )
			{
				_bitmap.bitmapData.applyFilter( _bitmap.bitmapData, _bitmap.bitmapData.rect, BitmapRenderer.ZERO_POINT, _postFilters[i] );
			}
			if( _paletteMap )
			{
				_bitmap.bitmapData.paletteMap( _bitmap.bitmapData, _bitmap.bitmapData.rect, ZERO_POINT, _paletteMap[1] , _paletteMap[2] , _paletteMap[3] , _paletteMap[0] );
			}
			_bitmap.bitmapData.unlock();
		}
		
		/**
		 * @private
		 */
		protected function sortOnZ( p1:Particle3D, p2:Particle3D ):int
		{
			return p2.zDepth - p1.zDepth;
		}

		/**
		 * Used internally here and in derived classes to render a single particle.
		 * Each particle is positioned and perspective scaling applied here.
		 * 
		 * <p>Derived classes can modify the rendering of individual particles
		 * by overriding this method.</p>
		 * 
		 * @param particle The particle to draw on the bitmap.
		 */
		protected function drawParticle( particle:Particle3D ):void
		{
			var pos:Vector3D = particle.projectedPosition;
			if( pos.z < _camera.nearPlaneDistance || pos.z > _camera.farPlaneDistance )
			{
				return;
			}
			var scale:Number = particle.scale * _camera.projectionDistance / pos.z;
			pos.project();
			
			var rot:Number = 0;
			var transform:Matrix3D = _camera.transform;			
			var facing:Vector3D;
			if( particle.rotation.equals( Quaternion.IDENTITY ) )
			{
				facing = particle.faceAxis.clone();
			}
			else
			{
				var m:Matrix3D = particle.rotation.toMatrixTransformation();
				facing = m.transformVector( particle.faceAxis );
			}
			transform.transformVectorSelf( facing );
			if( facing.x != 0 || facing.y != 0 )
			{
				rot = Math.atan2( -facing.y, facing.x );
			}

			var matrix:Matrix;
			if( rot )
			{
				var cos:Number = scale * Math.cos( rot );
				var sin:Number = scale * Math.sin( rot );
				matrix = new Matrix( cos, sin, -sin, cos, pos.x - _canvas.x, -pos.y - _canvas.y );
			}
			else
			{
				matrix = new Matrix( scale, 0, 0, scale, pos.x - _canvas.x, -pos.y - _canvas.y );
			}

			_bitmap.bitmapData.draw( particle.image, matrix, particle.colorTransform, DisplayObject( particle.image ).blendMode, null, _smoothing );
		}
	}
}