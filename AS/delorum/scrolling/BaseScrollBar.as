package delorum.scrolling
{

import flash.display.Sprite;

public class BaseScrollBar extends Sprite implements iScrollBar
{
	public function BaseScrollBar():void 
	{ 
		buttonMode = true;
	}
	
	/** 
	*	This function should redraw the scrollbar at the width and heigth specified
	*/
	public function drawBar ( $w:Number, $h:Number ):void{ };
}

}

