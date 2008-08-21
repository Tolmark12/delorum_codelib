package delorum.scrolling
{

import flash.display.Sprite;
import flash.events.*;

public class DefaultScrollBtn extends BaseScrollBtn implements iScrollBtn
{
	private var _size:Number;
	private var _color:uint;
	
	public function DefaultScrollBtn( $buttonSize:Number = 7, $color:uint = 0xFFFFFF ):void
	{
		_color = $color;
		_size = $buttonSize;
		super();
	}
	
	override public function draw():void
	{
		// Draw triangle
		this.graphics.beginFill( _color );
		this.graphics.moveTo( 0, _size / -2 );
		this.graphics.lineTo( _size, 0);
		this.graphics.lineTo( 0, _size / 2 );
		// Draw hit area
		this.graphics.beginFill( 0x000000, 0 );
		this.graphics.drawRect( _size * -2, _size * -2, _size * 4, _size * 4 )
		// Event Handler
		this.addEventListener( MouseEvent.MOUSE_DOWN, _mousePress );
	}

	// ______________________________________________________________ Getters / setters
	public function set color ( $clr:Number ):void{ _color = $clr; };
	

}

}