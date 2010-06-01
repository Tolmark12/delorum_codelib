package delorum.images
{

import flash.display.BitmapData;
import flash.events.*;

public class FinderPoint extends EventDispatcher
{
	// Events
	public static const INFINITE_LOOP:String = "infinite_loop";
	
	// State
	public static const FILLED:uint = 1;
	public static const EMPTIED:uint = 2;
	public static const NO_CHANGE:uint = 3;
	
	public var x:Number;
	public var y:Number;
	
	public var lastChange:uint;
	public var state:uint;
	
	public var filled:Boolean;
	public var emptied:Boolean;
	public var noChange:Boolean;
	public var isEmpty:Boolean;
	public var logPositions:Boolean = false;
	public var positions:Array = new Array();
	
	public function FinderPoint( $x:Number=0, $y:Number=0 ):void
	{
		x = $x;
		y = $y;
	}
	
	public function incramentX ( $incrament:Number ):void{
		this.x += $incrament;
		if( logPositions )
			_logAndCompare()
	}
	
	public function incramentY ( $incrament:Number ):void{
		this.y += $incrament;
	}
	
	public function testPixelValue ( $bmd:BitmapData ):void
	{
		
		// Test the new value to see if this pixel is empty
		var newState:uint = (( $bmd.getPixel32( this.x, this.y ) >> 24 & 0xFF) < 8 )? EMPTIED : FILLED;
		// Set the changed state 
		if( state != newState )
			lastChange = newState;
		else
			lastChange = NO_CHANGE;
		
		// Save this state for future states
		state = newState;
	}
	
	public function reset (  ):void
	{
		positions = new Array();
	}
	
	private function _logAndCompare (  ):void
	{
		var newPos:String = this.x+"."+this.y;
		if( positions.lastIndexOf(newPos) == -1 )
			positions.push(newPos);
		else
			dispatchEvent( new Event(INFINITE_LOOP, true) );
	}
}

}