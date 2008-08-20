package delorum.scrolling
{

import flash.display.Sprite;

public class BaseScrollTrack extends Sprite implements iScrollTrack
{
	public function BaseScrollTrack():void { }
	
	/** 
	*	This method should redraw the scroll track at the specified sidth and height
	*/
	public function drawTrack ( $w:Number, $h:Number ):void{ };
}

}