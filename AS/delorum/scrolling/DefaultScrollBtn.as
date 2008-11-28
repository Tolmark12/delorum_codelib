package delorum.scrolling
{

import flash.display.Sprite;
import flash.events.*;

public class DefaultScrollBtn extends BaseScrollBtn implements iScrollBtn
{
	private var _size:Number;
	private var _color:uint;
	private var _verticalHitAreaIncrease:Number;
	private var _horizontalHitIncrease:Number;
	
	/** 
	*	@param		Padding, left or right from the scrollbar
	*	@param		Size of the button
	*	@param		Fill color of the button
	*/
	public function DefaultScrollBtn( $buttonPadding:Number=0, $buttonSize:Number = 7, $color:uint = 0xFFFFFF, $verticalHitAreaIncrease:Number=1.2, $horizontalHitIncrease:Number=1.2 ):void
	{
		super( $buttonPadding );
		_color = $color;
		_size = $buttonSize;
		_verticalHitAreaIncrease = $verticalHitAreaIncrease;
		_horizontalHitIncrease = $horizontalHitIncrease;
	}
	
	override public function draw():void
	{
		// Draw triangle
		this.graphics.beginFill( _color );
		this.graphics.moveTo( 0, _size / -2 );
		this.graphics.lineTo( _size, 0);
		this.graphics.lineTo( 0, _size / 2 );
		
		// Draw hit area
		
		var xtraH:Number = _size * _horizontalHitIncrease;
		var xtraV:Number = _size * - _verticalHitAreaIncrease;
		
		this.graphics.beginFill( 0x000000, 0 );
		this.graphics.drawRect( -super.buttonPadding - xtraH * 0.1,
		 						-xtraV, 
								xtraH  + super.buttonPadding*2, 
								xtraV * 2   );
	}

	// ______________________________________________________________ Getters / setters
	public function set color ( $clr:Number ):void{ _color = $clr; };
	

}

}