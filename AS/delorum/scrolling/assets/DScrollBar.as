package delorum.scrolling.assets
{

import flash.display.Sprite;

public class DScrollBar extends Sprite implements iDScrollBar
{
	private var _hitPadding:Number;
	private var _color:uint;
	
	public function DScrollBar( $color:uint, $hitPadding:Number=1.2  ):void
	{
		_hitPadding = $hitPadding;
		_color = $color;
		buttonMode = true;
	}

	public function drawBar ( $width:Number, $height:Number ):void
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

