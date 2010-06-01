package app.view.components.ui.virtualization
{

import flash.display.Sprite;

public class DisplayCell extends Sprite
{
	public static const CELL_HEIGHT:Number = 10;
	public static const CELL_PADDING:Number = 3;
	public static const TOTAL_HEIGHT:Number = CELL_PADDING + CELL_HEIGHT;
	
	private var _text:Text_swc = new Text_swc();
	
	public function DisplayCell():void
	{
		_text.titleTxt.autoSize = "left";
		this.addChild(_text);
	}
	
	// ______________________________________________________________ API
	
	public function changeText ( $txt:String ):void
	{
		_text.titleTxt.text = $txt;
		//this.graphics.beginFill(0xFF0000, 0.2);
		//this.graphics.drawRect( 0,0,400,CELL_HEIGHT );
	}
	
	// ______________________________________________________________ Deconstruct
	
	public function deconstruct (  ):void
	{
		this.removeChild(_text);
		_text = null;
	}

}

}