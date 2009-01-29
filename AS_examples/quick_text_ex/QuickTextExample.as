package 
{

import flash.display.Sprite;
import delorum.text.QuickText;
import flash.events.*;

public class QuickTextExample extends Sprite
{
	public function QuickTextExample (  ):void
	{
		var quickText:QuickText = new QuickText();
		quickText.htmlText = "This is a test";
		this.addChild(quickText);
	}
}

}