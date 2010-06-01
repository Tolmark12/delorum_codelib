package 
{

import flash.display.Sprite;
import delorum.images.EdgeFinder;

public class EdgeFinderExample extends Sprite
{
	public function EdgeFinderExample():void
	{
		var mc = this.getChildByName( "testMc" ) as MovieClip
		var finder:EdgeFinder = new EdgeFinder( mc, mc.txt );
		var ar:Array = finder.findLetters();
	}

}

}