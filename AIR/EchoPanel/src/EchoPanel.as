package 
{

import flash.display.*;
import flash.events.*;
import ui.*;
import delorum.utils.echo;
import delorum.utils.EchoMachine;
import app.AppFacade;

public class EchoPanel extends Sprite
{
	public function EchoPanel():void
	{
		_init();
		_createMvcApp();
		//stage.quality = "low"
		EchoMachine.register(this.stage);
		//for ( var i:uint=0; i<200; i++ ) 
		//{
		//	echo( i + '  :  ' +  "asdf" );
		//}
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