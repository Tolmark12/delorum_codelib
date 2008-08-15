package 
{

import delorum.echo.EchoMachine;
import flash.display.Sprite;

public class SharedCodeTester extends Sprite
{
	public function SharedCodeTester():void
	{
		_testEchoMachine();
	}	
	
	
	// \\ ECHO MACHINE TEST
	private function _testEchoMachine (  ):void
	{
		// Set error mode automatically
		EchoMachine.setEchoModeAutomatically( this.stage );
		
		// Add Errors and print errors
		EchoMachine.echo("hullo");
		EchoMachine.addErrorToLog("These ");
		EchoMachine.addErrorToLog("are");
		EchoMachine.addErrorToLog("errors.");
		EchoMachine.printErrors(  );
		
		// Add Message and print messages
		EchoMachine.addMessageToLog("These");
		EchoMachine.addMessageToLog("are");
		EchoMachine.addMessageToLog("messages");
		EchoMachine.printMessages();
		
		// Set error mode manually
		EchoMachine.errorMode = EchoMachine.WEB;
		EchoMachine.echo( "This will be output to a javascript alert window." );
		
		EchoMachine.errorMode = EchoMachine.FLASH;
		EchoMachine.echo( "This will be output in the flash Output panel." );
		
		EchoMachine.errorMode = EchoMachine.QUIET;
		EchoMachine.echo( "This will not be output anywhere." );
	}

}

}