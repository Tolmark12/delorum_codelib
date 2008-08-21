package delorum.scrolling
{

import flash.display.Sprite;
import flash.events.*;
import flash.utils.Timer;

public class BaseScrollBtn extends Sprite implements iScrollBtn
{
	// Dispatched events
	public static const INCRAMENT:String = "incrament";
	
	// scrolling speed
	private static const DELAY:uint 		= 500;
	private static const SCROLL_SPEED:uint 	= 10;

	private var _isPressed:Boolean;
	private var _timer:Timer;
	private var _incrament:int;
	
	public function BaseScrollBtn(  ):void
	{
		this.buttonMode = true;
	}
	
	public function draw ():void
	{
		trace( "The draw method in BaseScrollBtn should be overrided" );
	}
	
	// ______________________________________________________________ Event Handlers
	
	protected function _mousePress ( e:Event ):void
	{
		_isPressed = true;
		_sendIncramentNotice();
		_timer = new Timer(DELAY, 1);
		_timer.addEventListener("timer", _timer1);
		_timer.start();
		// Add the release handler. 
		this.stage.addEventListener( MouseEvent.MOUSE_UP,   _mouseUp );
	}
	
	protected function _mouseUp ( e:Event ):void
	{
		_isPressed = false;
		_timer.stop();
		// Remove the release handler
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
	}
	
	protected function _timer1 ( e:Event ):void
	{
		if( _isPressed ){ 
			_timer.stop();
			_timer = new Timer( SCROLL_SPEED );
			_timer.addEventListener("timer", _sendIncramentNotice);
			_timer.start();
		}	
	}
	
	// ______________________________________________________________ Dispatched events
	
	protected function _sendIncramentNotice ( e:Event = null ):void
	{
		this.dispatchEvent( new Event( INCRAMENT ) );
	}
	
	// ______________________________________________________________ Getters / Setter
	
	public function set incrament ( $val:int ):void { _incrament = $val; };
	public function get incrament ():int 			 { return _incrament; };
}

}