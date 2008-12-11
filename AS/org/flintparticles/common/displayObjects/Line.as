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
	import flash.display.Shape;	

	/**
	 * The LineShape class is a DisplayObject with a simple line shape. The line is
	 * horizontal and the registration point of this display object is in the center
	 * of the line.
	 */

	public class Line extends Shape
	{
		/**
		 * The constructor creates a Line with the specified length.
		 * 
		 * @param lineLength The length, in pixels, of the line.
		 * @param color the color of the Line
		 * @param bm The blendMode for the Line
		 */
		public function Line( lineLength : Number, color:uint = 0xFFFFFF, bm:String = "normal" )
		{
			graphics.lineStyle( 1, color );
			graphics.moveTo( -lineLength * 0.5, 0 );
			graphics.lineTo( lineLength * 0.5, 0 );
			blendMode = bm;
		}
	}
}
