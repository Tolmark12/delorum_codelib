package ui
{

import flash.display.*;
import flash.events.*;
import flash.geom.Rectangle;

public class Resizer extends MovieClip
{
	public static const NEW_WINDOW_SIZE:String = "new_window_size";
	
	private var _dragOffsetX:Number;
	private var _dragOffsetY:Number;
	
	public function Resizer():void
	{
	}
	
	public function init (  ):void
	{
		this.addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown );
		this.stage.addEventListener( MouseEvent.MOUSE_UP, _onMouseUp );
	}
	
	// ______________________________________________________________ API
	
	public function moveTo ( $x:Number, $y:Number ):void
	{
		this.x = $x - this.width;
		this.y = $y - this.height;
	}
	
	// ______________________________________________________________ Event Listeners
	
	// Start the resize
	private function _onMouseDown ( e:MouseEvent ):void
	{
		_dragOffsetY = this.mouseY;
		_dragOffsetX = this.mouseX;
		this.addEventListener( Event.ENTER_FRAME, _onEnterFrame );
	}
	
	// Stop the resize
	private function _onMouseUp ( e:Event ):void
	{
		this.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
		this.dispatchEvent( new Event( NEW_WINDOW_SIZE ) );
	}
	
	private function _onEnterFrame ( e:Event ):void
	{
		var xTarg:Number = this.parent.mouseX - _dragOffsetX;
		var yTarg:Number = this.parent.mouseY - _dragOffsetY;
		this.x = ( xTarg < 100 )? 100 : xTarg ;
		this.y = ( yTarg < 40 )? 40 : yTarg ;
		this.dispatchEvent( new Event( NEW_WINDOW_SIZE ) );
	}
	
	public function get appWidth  (  ):Number{ return this.x + this.width;  };
	public function get appHeight (  ):Number{ return this.y + this.height; };

}

}