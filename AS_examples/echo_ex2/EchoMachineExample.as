package 
{

import flash.display.Sprite;
import delorum.utils.*;
import flash.events.*;

public class EchoMachineExample extends Sprite
{
	
	public function EchoMachineExample():void
	{
		var obj:Object = new Object()
		EchoMachine.register( this.stage );
		echo( "some thing " );
		echo( 123 );
		echo( obj );
		trace( obj );
	}
}

}