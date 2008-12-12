package 
{

import flash.display.*;
import flash.events.*;
import ui.*;
import delorum.echo.EchoMachine;

public class EchoPanel extends Sprite
{
	public function EchoPanel():void
	{
		_init();
		EchoMachine.echoMode = EchoMachine.AIR;
		EchoMachine.echo([1,2,3,4,5,6,7])
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