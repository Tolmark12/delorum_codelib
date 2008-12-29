package app.view.components.ui
{

import flash.display.MovieClip;

public class BarBtn extends MovieClip
{
	public function BarBtn():void
	{
		this.graphics.beginFill(0xFF0000, 0);
		this.graphics.drawRect( -10, -10, 20, 20);
	}

}

}