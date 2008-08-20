package
{

import delorum.scrolling.*;

public class CustomScrollBar extends BaseScrollBar implements iScrollBar
{
	public function CustomScrollBar():void
	{
		super();
	}
	
	override public function drawBar ( $width:Number, $height:Number ):void
	{
		this.graphics.clear();
		this.graphics.beginFill( 0xFFFF00 );
		this.graphics.drawRect(0, 0, $width, $height );
	}

}

}