package 
{

import flash.display.*;
import flash.events.*;
import ui.*;

public class EchoPanel extends Sprite
{
	public function EchoPanel():void
	{
		_init()
	}
	
	private function _init (  ):void
	{
		this.stage.align = StageAlign.TOP_LEFT;
		this.stage.scaleMode = StageScaleMode.NO_SCALE;
		this.stage.nativeWindow.activate();
		var stageManager = new StageManager();
		this.addChild(stageManager);
		stageManager.init();
	}
	

}

}