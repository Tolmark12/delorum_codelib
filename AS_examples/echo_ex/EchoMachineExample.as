package 
{

import flash.display.Sprite;
import delorum.echo.EchoMachine;
import flash.events.*;

public class EchoMachineExample extends Sprite
{
	private var _count:Number = 1;
	
	public function EchoMachineExample():void
	{
		EchoMachine.errorMode = EchoMachine.AIR;
		EchoMachine.echo("This message is coming from the Echo Machine Document Class constructor");
		this.stage.addEventListener(MouseEvent.CLICK, _onClick);
	}
	
	private function _onClick ( e:Event ):void
	{
		EchoMachine.echo( "You have clicked on the stage " + _count++ + " times." );
	}

}

}