package delorum.util
{
import flash.external.ExternalInterface;
import flash.events.Event;


/**
* 	A simple helper class for sending trace messages to javascript 
*	when a swf is embedded in an html page.
* 	
* 	@example Sample usage:
* 	<listing version=3.0>
* 		
*		JavaTrace.trace( "My Message!" );
*		//Displays: My Message
*	
*		JavaTrace.confirm( "Confirm My Message," );
*		// Displays: Confirm My Message, and waits for confirmation 
*	
* 	</listing>
* 	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2008-04-08
* 	@rights	  Copyright (c) Delorum inc. 2008. All rights reserved	
*/


public class JavaTrace
{
	/** 
	*	Works like flash trace, but outputs message to a javascript popup
	*	
	*	@param		Message.
	*/
	public static function trace( $str:String ):void
	{
		ExternalInterface.call("alert", $str);
	}

	/** 
	*	Use this when you need to see every message since code execution is
	*	halted until user clicks "Ok"
	*	
	*	@param		Message
	*/
	public static function confirm( $str:String ):void
	{
		ExternalInterface.call("confirm", $str);
	}
}
}