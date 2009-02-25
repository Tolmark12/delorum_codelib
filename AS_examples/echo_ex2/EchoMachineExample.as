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
		for ( var i:uint=0; i<200; i++ ) 
		{
			echo( i + '  :  ' +  "example" );
		}
	}
}

}