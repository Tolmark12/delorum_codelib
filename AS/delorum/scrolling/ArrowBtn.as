package delorum.scrolling
{

import flash.display.Sprite;
import flash.events.*;
import flash.utils.Timer;

public class ArrowBtn extends Sprite
{
	// Dispatched events
	public static const INCRAMENT:String = "incrament";
	
	//
	private static const DELAY:uint 		= 500;
	private static const SCROLL_SPEED:uint 	= 10;

	private var _color:Number = 0xFFFFFF;
	private var _isPressed:Boolean;
	private var _timer:Timer;
	private var _incrament:int;
	
	public function ArrowBtn(  ):void
	{
		this.buttonMode = true;
	}
	
	public function draw ( $size:Number ):void
	{
		// Draw triangle
		this.graphics.beginFill( _color );
		this.graphics.moveTo( 0, $size / -2 );
		this.graphics.lineTo( $size, 0);
		this.graphics.lineTo( 0, $size / 2 );
		// Draw hit area
		this.graphics.beginFill( 0x000000, 0 );
		this.graphics.drawRect( $size * -2, $size * -2, $size * 4, $size * 4 )
		// Event Handler
		this.addEventListener( MouseEvent.MOUSE_DOWN, _mousePress 	);
	}
	
	// ______________________________________________________________ Event Handlers
	
	private function _mousePress ( e:Event ):void
	{
		_isPressed = true;
		_sendIncramentNotice();
		_timer = new Timer(DELAY, 1);
		_timer.addEventListener("timer", _timer1);
		_timer.start();
		// Add the release handler. 
		this.stage.addEventListener( MouseEvent.MOUSE_UP,   _mouseUp );
	}
	
	private function _mouseUp ( e:Event ):void
	{
		_isPressed = false;
		_timer.stop();
		// Remove the release handler
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
	}
	
	private function _timer1 ( e:Event ):void
	{
		if( _isPressed ){ 
			_timer.stop();
			_timer = new Timer( SCROLL_SPEED );
			_timer.addEventListener("timer", _sendIncramentNotice);
			_timer.start();
		}	
	}
	
	// ______________________________________________________________ Dispatched events
	
	private function _sendIncramentNotice ( e:Event = null ):void
	{
		this.dispatchEvent( new Event( INCRAMENT ) );
	}
	
	// ______________________________________________________________ Getters / Setter
	
	public function set color ( $clr:Number ):void{ _color = $clr; };
	public function set incrament ( $val:int ):void { _incrament = $val; };
	public function get incrament ():int 			 { return _incrament; };
}

}