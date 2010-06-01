package app.view.components.ui
{

import flash.display.*;
import flash.events.*;
import flash.geom.Rectangle;

public class Resizer extends MovieClip
{
	public static const WINDOW_RESIZE:String = "window_resize";
	public static const MIN_WIDTH:Number = 260;
	public static const MIN_HEIGHT:Number = 65;
	
	public var yOffset:Number;
	
	private var _dragOffsetX:Number;
	private var _dragOffsetY:Number;
	
	public function Resizer():void
	{
	}
	
	public function init (  ):void
	{
		this.addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown, false,0,true  );
		this.stage.addEventListener( MouseEvent.MOUSE_UP, _onMouseUp, false,0,true  );
	}
	
	// ______________________________________________________________ API
	
	/** 
	*	Move to a specified point
	*	@param		x position to move to
	*	@param		y position to move to
	*/
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
		this.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true  );
	}
	
	// Stop the resize
	private function _onMouseUp ( e:Event ):void
	{
		this.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
		this.dispatchEvent( new Event( WINDOW_RESIZE, true ) );
	}
	
	private function _onEnterFrame ( e:Event ):void
	{
		var xTarg:Number = this.parent.mouseX - _dragOffsetX;
		var yTarg:Number = this.parent.mouseY - _dragOffsetY;
		this.x = ( xTarg < MIN_WIDTH )?  MIN_WIDTH : xTarg ;
		this.y = ( yTarg < MIN_HEIGHT )? MIN_HEIGHT : yTarg ;
		this.dispatchEvent( new Event( WINDOW_RESIZE, true ) );
	}
	
	public function get appWidth  (  ):Number{ return this.x + this.width;  };
	public function get appHeight (  ):Number{ return this.y + this.height - yOffset; };

}

}