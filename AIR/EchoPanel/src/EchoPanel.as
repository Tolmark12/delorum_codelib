package 
{

import flash.display.*;
import flash.events.*;
import ui.*;
import delorum.echo.EchoMachine;
import app.AppFacade;

public class EchoPanel extends Sprite
{
	public function EchoPanel():void
	{
		_init();
		_createMvcApp();
		//stage.quality = "low"
		EchoMachine.echoMode = EchoMachine.AIR;
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		//EchoMachine.echo( "hi" );
		EchoMachine.startLogging(this);		
	}
	
	private function _init (  ):void
	{
		this.stage.align = StageAlign.TOP_LEFT;
		this.stage.scaleMode = StageScaleMode.NO_SCALE;
		this.stage.nativeWindow.activate();
		//var stageManager = new StageManager();
		//this.addChild(stageManager);
		//stageManager.initialize();
	}
	
	private function _createMvcApp (  ):void
	{
		var myFacade:AppFacade = AppFacade.getInstance( 'app_facade' );
		myFacade.startup( this );
	}
	

}

}