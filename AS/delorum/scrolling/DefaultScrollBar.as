package delorum.scrolling
{

import flash.display.Sprite;

public class DefaultScrollBar extends BaseScrollBar implements iScrollBar
{
	private var _hitPadding:Number;
	private var _color:uint;
	
	public function DefaultScrollBar( $color:uint=0xFFFFFF, $hitPadding:Number=1.2  ):void
	{
		super();
		_hitPadding = $hitPadding;
		_color = $color;
	}

	override public function drawBar ( $width:Number, $height:Number ):void
	{
		this.graphics.clear();
		this.graphics.beginFill( _color );
		this.graphics.drawRoundRect(0, 0, $width, $height, $height, $height);
  		// Draw larger hit area
		this.graphics.beginFill( 0xFF0000, 0 );
		_hitPadding -= 1;
		this.graphics.drawRect(0, $height *-_hitPadding,   $width, $height + ($height * _hitPadding*2) );
	}
}

}

