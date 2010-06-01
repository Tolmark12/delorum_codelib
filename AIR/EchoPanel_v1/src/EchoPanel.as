package 
{

import flash.display.*;
import flash.events.*;
import delorum.utils.echo;
import delorum.utils.EchoMachine;
import app.AppFacade;

public class EchoPanel extends Sprite
{
	public function EchoPanel():void
	{
		EchoMachine.register(this.stage);

		_init();
		_createMvcApp();
		stage.quality = "low"
	}
	
	private function _init (  ):void
	{
		this.stage.align = StageAlign.TOP_LEFT;
		this.stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.quality = "low"
		this.stage.nativeWindow.activate();
	}
	
	private function _createMvcApp (  ):void
	{
		var myFacade:AppFacade = AppFacade.getInstance( 'app_facade' );
		myFacade.startup( this );
	}
	

}

}