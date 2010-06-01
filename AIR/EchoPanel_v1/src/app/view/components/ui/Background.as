package app.view.components.ui
{

import flash.display.*;
import flash.events.*;

public class Background extends Sprite
{
	public function Background():void
	{
	}

	public function draw ( $w:Number, $h:Number ):void
	{
		this.graphics.clear();
		this.graphics.beginFill(0x000000, 0.96);
		this.graphics.lineStyle(1, 0xAAAAAA, 0.1 );
		this.graphics.drawRect(1,0,$w-2,$h);
	}
}

}