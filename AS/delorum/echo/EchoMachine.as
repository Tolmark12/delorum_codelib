package delorum.echo
{
import flash.display.*;
import flash.external.ExternalInterface;
import flash.utils.Timer;
import flash.events.Event;
import flash.system.System;
import flash.net.LocalConnection;
import flash.events.StatusEvent;

/**
 *	This class is used to report errors or other messages independent
 *	of how the swf has been deployed. For instance, if the swf has been
 *	embedded in an html page, the errors and messages are sent as Javascript
 *	alerts; When deployed to the flash runtime, as flash trace statements.
 *	
 *	@example
 *	<listing version="3.0">
 *	
 *	// Determine what mode to output errors and messages
 *	ErrorMachine.setechoModeAutomatically( this.stage );
 *	// or, to set the error mode manually... 
 *	// ErrorMachine.echoMode = ErrorMachine.FLASH;
 *	
 *	// Add a sample error
 *	ErrorMachine.addErrorToLog( "This is a fake error." );
 *	// Print all errors
 *	ErrorMachine.printErrors();
 *	// Outputs:
 *	// >> Errors
 *	// This is a fake error.
 *	// << End
 *
 *	
 *	</listing>
 *	
 *	@language ActionScript 3, Flash 9.0.0
 *	@author   Mark Parson, 24.03.2008
 *	@rights	  Copyright (c) Delorum inc. 2008. All rights reserved	
 */


public class EchoMachine
{
	// Error modes
	/** Error Mode: For testing in flash */
	public static const FLASH:String		= "flash";
	/** Error Mode: Quiet, does not print any errors */
	public static const QUIET:String 		= "quiet";
	/** Error Mode: For testing on web, uses javascript alert*/
	public static const WEB:String 			= "web";
	/** Error Mode: For saving errors to a log (not implemented yet) */
	public static const LOG:String 			= "log";
	/**	Error Mode: Ooutputs to the AIR application */
	public static const AIR:String 			= "air";

	/**	Set the echoMode to indicate how errors should be reported 
	*	
	*	@default    EchoMachine.QUIET 							 */
	private static var _echoMode:String		= QUIET;

	/**	@private 	Store Messages here for later output */ 
	private static var _messageLog:Array 	= new Array();
	/**	@private 	Store Errors here for later output */ 
	private static var _errorLog:Array 		= new Array();
	/**	@private 	Local Connection to the AIR application */
	private static var _airConnection:LocalConnection;
	
	private static var _connectionId:String;
	private static var _conn:LocalConnection;
	private static var _stage:Stage;
	private static var _doSend:Boolean = true;
	
	// ______________________________________________________________ PUBLIC FUNCTIONS
	
	/**	Allow Javascript to add items to logs. Print logs, And print immediately */
	public static function initForExternalJavascript (  ):void
	{
		if( ExternalInterface.available )
		{
			ExternalInterface.addCallback( "addErrorToLog",   EchoMachine.addErrorToLog 	);
			ExternalInterface.addCallback( "addMessageToLog", EchoMachine.addMessageToLog 	);
			ExternalInterface.addCallback( "printErrors",     EchoMachine.printErrors 		);
			ExternalInterface.addCallback( "printMessages",   EchoMachine.printMessages 	);
			ExternalInterface.addCallback( "print",  		  EchoMachine.print			);	
			ExternalInterface.addCallback( "trace",  		  EchoMachine.print			);	
			ExternalInterface.addCallback( "echo",  		  EchoMachine.print			);	
		}
	}
	
	/** Add message to the message log 
	* 	@param		Message to be added to the log*/
	public static function addMessageToLog ( $m:* ):void
	{
		_messageLog.push( String( $m ) );
	}

	/** Add error to log 
	* 	@param		Error*/
	public static function addErrorToLog ( $e:* ):void
	{
		_errorLog.push( String( $e ) );
	}
	
	/** Similar to the trace function, traces immediately 
	* 	@param		Message
	* 	@param		Error Mode [FLASH, QUIET, WEB, WEB_ALERT, LOG] */
	public static function print ( $str:*, $emode:String = null  ):void
	{
		outputMessage( String($str), $emode );
	}
	
	/** Automatically detect if flash is embedded in html, and set error mode appropriately 	*/
	public static function setEchoModeAutomatically ( $stage:Stage ):void
	{
		echoMode = ( isOnWeb( $stage ) )? EchoMachine.WEB : EchoMachine.FLASH 
	}
	
	/** 
	*	@return		Returns <code>true</code> if swf is embedded in html
	*/
	public static function isOnWeb ( $stage:Stage ):Boolean
	{
		return ( $stage.loaderInfo.url.indexOf("http") == 0 )? true : false;
	}
	
	
	/** Prints all Errors in log 
	* 	@param		Error Mode [FLASH, QUIET, WEB, WEB_ALERT, LOG] */
	public static function printErrors ( $emode:String = null ):void
	{	
		if( _errorLog.length != 0 ) 
		{
			outputMessage(  getErrorsAsString(), $emode );
		}
	}
	
	/** Prints all messages in the log 
	* 	@param		Error Mode [FLASH, QUIET, WEB, WEB_ALERT, LOG] */
	public static function printMessages ( $emode:String = null ):void
	{
		if( _messageLog.length != 0 ) 
		{
			outputMessage(  getMessagesAsString(), $emode );
		}
	}
	
	public static function clearMessages (  ):void
	{
		_messageLog = new Array()
	}
	
	public static function clearErrors (  ):void
	{
		_errorLog = new Array()
	}
	
	// ______________________________________________________________ AIR specific 
	
	private static function _initForAIR (  ):void
	{
		// Connection id
		_connectionId = "_" +  String( new Date().getTime() );
		
		// Allow the air app to talk to this swf
		_conn = new LocalConnection();
		_conn.client = EchoMachine;
		_conn.allowDomain('*');
		_conn.allowInsecureDomain('localhost');
		try {
		    _conn.connect(_connectionId);
		} catch (error:ArgumentError) {
		}
		
		// Connect to the air app
		_airConnection = new LocalConnection();
		_airConnection.addEventListener(StatusEvent.STATUS, _onAirStaus);
		
		if( _doSend ) {
			_airConnection.send( "_delorum_air_connect", "clear", _connectionId );
		}
	}
	
	/** 
	*	Called by tha AIR app
	*/
	public static function sendSwfInfo (  ):void
	{
		// Find name of the swf
		var myPattern:RegExp = /\b\w+\.swf/;
		var swfName = String( myPattern.exec( _stage.loaderInfo.url ) );
		
		// Send name of the swf
		var infoObj:Object = {
			swfName 	: swfName,
			name 		: swfName.split(".")[0]
		}
		
		if( _doSend )
			_airConnection.send( "_delorum_air_connect", "infoAboutSwf", _connectionId, infoObj );
	}
	
	
	public static function stopBroadcasting (  ):void
	{
		_doSend = false;
	}
	
	private static function _onAirStaus ( e:Event ):void {};
	
	// ______________________________________________________________ AIR specific END
	
	// ______________________________________________________________ Memory
	
	private static var _memoryEchoCount:uint = 0;
	private static var _memoryTimer:Timer;
	
	/**	Echo out the amount of memory used by flash every 1 second. */
	public static function startMemoryEcho ( $seconds:Number = 1 ):void
	{
		if( _memoryTimer == null ) 
			_memoryTimer = new Timer( $seconds * 1 );

		_memoryTimer.addEventListener("timer", _echoMemory, false, 0, true);
		_memoryTimer.start();
	}
	
	public static function stopMemoryEcho (  ):void
	{
		_memoryTimer.stop();
	}
	
	private static function _echoMemory ( e:Event ):void
	{
		trace( _memoryEchoCount++ + ") " + System.totalMemory );
	}
	
	// ______________________________________________________________ Memory END
	
	/** @private 	Send message to output receiver
	* 	@param		Message
	* 	@param		Error Mode [FLASH, QUIET, WEB, WEB_ALERT, LOG] */
	private static function outputMessage( $str:String,  $emode:String = null ):void
	{
		// If no error mode sent, use the static echoMode
		$emode = ( $emode == null )? echoMode : $emode ;
				
		if( $str.length != 0 ) 
		{
			switch( $emode )
			{
				case QUIET:
				  // Do nothing
				break
			
				case FLASH:
				  trace( $str );
				break
			
				case WEB:
					ExternalInterface.call("confirm", $str);
				break
				
				case AIR :
					if( _doSend )
						_airConnection.send( "_delorum_air_connect", "echo", _connectionId, $str );
				break;
				
				case LOG:
					// Nothing here yet :-D
				break
				default :
				
				break
			}
		}
	}
	
	// ______________________________________________________________ Stats
	private static var _statsHarvester:StatsHarvester;
	
	public static function startLogging ( $stage:DisplayObjectContainer ):void
	{
		_stage = $stage.stage;
		_statsHarvester = new StatsHarvester( $stage );
		_statsHarvester.addEventListener( StatsHarvester.STATS, _onStats );
		var str:String = $stage.stage.loaderInfo.loaderURL;
		if( _doSend )
			_airConnection.send( "_delorum_air_connect", "initNewSwf", _connectionId );
	}
	
	private static function _onStats ( e:Event ):void
	{
		if( _doSend )
			_airConnection.send( "_delorum_air_connect", "stats", _connectionId, _statsHarvester.statsObject );
	}
	
	public static function get errorLog 	(  ):Array{ return _errorLog; };
	public static function get messageLog 	(  ):Array{ return _messageLog; };
	
	// ______________________________________________________________ PRIVATE parsers
	/** 
	*	@private 	Returns all errors as a String
	*	
	*	@return		Returns contents of Error Log
	*/
	
	private static function getErrorsAsString():String
	{
		var newLine:String 		= (echoMode == WEB)? "\n" : "\n";
		var lineStart:String	= ""
		var preamble:String		= ">> Errors" + newLine;
		var conclusion:String	= "<< End";
		
		var str:String = preamble;
		var len:Number = _errorLog.length;
		for ( var i:Number=0; i<len; i++ ) 
		{
			str += lineStart + _errorLog[ i ] + newLine;
		}
		return str + conclusion;
	}
	
	/** 
	*	@private	Parse all messages into a string 
	*	
	*	@return		Returns contents of Message Log
	*/
	private static function getMessagesAsString():String
	{
		var newLine:String 		= (echoMode == WEB)? "\n" : "\n";
		var lineStart:String	= ""
		var preamble:String		= ">> Message Log" + newLine;
		var conclusion:String	= "<< End";
		
		var str:String = preamble;
		var len:Number = _messageLog.length;
		for ( var i:Number=0; i<len; i++ ) 
		{
			str += lineStart + _messageLog[ i ] + newLine;
		}
		return str + conclusion;
	}
	
	// ______________________________________________________________ Getters + Setters
	public static function get echoMode (  ):String { return _echoMode; }
	public static function set echoMode ( $str:String ):void { 
		_echoMode = $str;
		if( _echoMode == AIR ) 
			_initForAIR();
	}
	
	// ______________________________________________________________ Aliases
	public static function echo ( $str:* ):void { print($str); };
	public static function clearMessageLog ( ):void { clearMessages() };
	public static function clearErrorLog ( ):void { clearErrors() };
	public static function clearLogs (  ):void
	{
		clearMessages();
		clearErrors();
	}
}

}