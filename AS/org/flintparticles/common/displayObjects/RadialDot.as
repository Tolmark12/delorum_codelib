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

package org.flintparticles.common.displayObjects 
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;	

	/**
	 * The RadialDot class is a DisplayObject that is a circle shape with a gradient 
	 * fill that fades to transparency at the edge of the dot. The registration point
	 * of this diaplay object is in the center of the Dot.
	 */

	public class RadialDot extends Shape 
	{
		/**
		 * The constructor creates a RadialDot with the  specified radius.
		 * 
		 * @param radius The radius, in pixels, of the RadialDot.
		 * @param color The color of the RadialDot
		 * @param bm The blendMode of the RadialDot
		 */
		public function RadialDot( radius:Number, color:uint = 0xFFFFFF, bm:String = "normal" )
		{
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( radius * 2, radius * 2, 0, -radius, -radius );
			graphics.beginGradientFill( GradientType.RADIAL, [color,color], [1,0], [0,255], matrix );
			graphics.drawCircle( 0, 0, radius );
			graphics.endFill();
			blendMode = bm;
		}
	}
}
