package delorum.graphics
{

import flash.display.*;
import flash.geom.*;


/**
* 	Code for drawing a rounded shape
* 	
* 	@example Sample usage:
* 	<listing version=3.0>
* 		
* 	</listing>
* 	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2008-11-13
* 	@rights	  Copyright (c) Delorum 2008. All rights reserved	
*/


public class RoundedShape extends Sprite
{
	public static const RADIUS:Number = 6;
	
	// Motion Directions
	public static const NONE:int 	= 0;
	public static const RIGHT:int 	= -1;
	public static const LEFT:int 	= 1;
	public static const UP:int 		= -1;
	public static const DOWN:int 	= 1;
	
	
	private var _graphics:Graphics;
	private var _testingScale:Number = 1;
	
	public function RoundedShape():void
	{
		var _shape:Shape = new Shape();
		this.addChild( _shape );
		_graphics = _shape.graphics;
	}
	
	// Draw based on an array of points
	public function draw ( $points:Array, $color:uint=0xFFAA00, $alpha:Number=1 ):void
	{
		_graphics.clear();
		_graphics.beginFill( $color, $alpha );
		
		var len:int = $points.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			// If first point
			if( i == 0 ) 
				_drawCorner( $points[len-1], $points[i], $points[i+1] );
			
			// If last point
			else if( i == len - 1 ) 
				_drawCorner( $points[i-1], $points[i], $points[0] );
			
			// point somewhere in middle
			else
				_drawCorner( $points[i-1], $points[i], $points[i+1] );
		}
	}
	
	private function _drawCorner ( $prevPoint:Point, $nowPoint:Point, $nextPoint:Point ):void
	{
		var xDirComing:int = _getDirection( "x", $prevPoint.x, $nowPoint.x  );
		var yDirComing:int = _getDirection( "y", $prevPoint.y, $nowPoint.y  );
		var xDirGoing:int  = _getDirection( "x", $nowPoint.x,  $nextPoint.x );
		var yDirGoing:int  = _getDirection( "y", $nowPoint.y,  $nextPoint.y );
		
		var cRadius = RADIUS;
		var radi:Array = new Array
		(
			Math.abs($nextPoint.x - $nowPoint.x),
			Math.abs($nextPoint.y - $nowPoint.y),
			Math.abs($prevPoint.x - $nowPoint.x),
			Math.abs($prevPoint.y - $nowPoint.y)
		)
		for ( var i:uint=0; i<4; i++ ) 
		{
			if( radi[i] != 0 && radi[i] < cRadius ) 
				cRadius = radi[i]/2;
		}
		
		// Horizontal lines
		if( xDirComing != NONE ) 
		{
			_graphics.lineTo( $nowPoint.x + (cRadius * xDirComing), $nowPoint.y + (cRadius * yDirComing) );
			_graphics.curveTo($nowPoint.x, $nowPoint.y, $nowPoint.x + (cRadius * xDirGoing),  $nowPoint.y + (cRadius * yDirGoing ))
		}
		// Vertical lines
		else
		{
			_graphics.lineTo( $nowPoint.x + (cRadius * -xDirComing), $nowPoint.y + (cRadius * -yDirComing) );
			_graphics.curveTo($nowPoint.x, $nowPoint.y, $nowPoint.x + (cRadius * -xDirGoing),  $nowPoint.y + (cRadius * -yDirGoing ))
		}
	}
	
	
	// ______________________________________________________________  Helpers
	private function _getDirection ( $axis:String, $prev:Number, $next:Number ):int
	{
		if( $prev > $next ) 
			return ( $axis == "x" )? LEFT : UP ;
		else if( $prev < $next )
			return ( $axis == "x" )? RIGHT : DOWN ;
		else 
			return NONE;
	}
	
}

}