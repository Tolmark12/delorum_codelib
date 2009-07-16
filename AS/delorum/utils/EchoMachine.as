package delorum.utils
{
import flash.display.Stage;
import flash.events.Event;
import flash.net.LocalConnection;
import flash.events.StatusEvent;


/**
* 	The connection class for communicating with the EchoPanel
*	AIR application
* 	
* 	@example
* 	<listing version=3.0>
* 		import delorum.utils.*;
*		EchoMachine.register( this.stage );
*		echo("some message");
* 	</listing>
* 	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2009-02-23
* 	@rights	  Copyright (c) Delorum 2009. All rights reserved	
*/


public class EchoMachine
{
	private static var _airConnection:LocalConnection;
	private static var _connectionId:String;
	private static var _conn:LocalConnection;
	private static var _stage:Stage;
	private static var _doSend:Boolean = true;
	private static var _statsHarvester:StatsHarvester;
	
	// ______________________________________________________________ Register
	
	/** 
	*	Register a swf file for communication with the EchoPanel AIR app
	*	@param		The swf <code>Stage</code> object
	*/
	public static function register ( $stage:Stage ):void
	{
		// Create unique connection id
		_connectionId = "_" +  String( new Date().getTime() );
		
		// Allow the air app to talk to this swf
		_conn = new LocalConnection();
		_conn.client = EchoMachine;
		_conn.allowDomain('*');
		_conn.allowInsecureDomain('localhost');
		try {
		    _conn.connect(_connectionId);
		} catch (error:ArgumentError) {}
		
		// Connect to the air app
		_airConnection = new LocalConnection();
		_airConnection.addEventListener(StatusEvent.STATUS, _onAirStaus);
		
		//set stage var
		_stage = $stage;
		
		var filePath:String = _stage.loaderInfo.loaderURL;
		
		if( _doSend ){
			_airConnection.send( "_delorum_air_connect", "initNewSwf", _connectionId, filePath );
			sendSwfInfo()
		}
		
		// Init stats harvester
		_statsHarvester = new StatsHarvester( _stage );
		_statsHarvester.addEventListener( StatsHarvester.STATS, _onStats );
	}
	
	/** 
	*	Stop sending messages to the AIR app (called by the air app)
	*/
	public static function stopBroadcasting (  ):void {
		_doSend = false;
	}
	
	/** 
	*	Sends a trace statement to the AIR app
	*/
	public static function send ( $str:* ):void {
		try
		{
			if( _doSend )
				_airConnection.send( "_delorum_air_connect", "print", _connectionId, $str );
		} 
		catch (e:Error)
		{
			_airConnection.send( "_delorum_air_connect", "print", _connectionId, "Echo failed" + '  :  ' + e );
		}

	}
	
	
	// ______________________________________________________________ Stats

	private static function _onStats ( e:Event ):void{
		if( _doSend )
			_airConnection.send( "_delorum_air_connect", "stats", _connectionId, _statsHarvester.statsObject );
	}
	
	// ______________________________________________________________ Event Handlers
	
	/** 
	*	A do nothing handler to prevent unhandled event error
	*/
	private static function _onAirStaus ( e:Event ):void {};
	
	/** 
	*	Called by tha AIR app
	*	!!!!!!!!!! May not be used anymore...
	*/
    public static function sendSwfInfo (  ):void
    {
    	// Find name of the swf
    	var myPattern:RegExp = /\b\w+\.swf/;
    	var swfName:String = String( myPattern.exec( _stage.loaderInfo.url ) );
    	
    	// Send name of the swf
    	var infoObj:Object = {
    		swfName 	: swfName,
    		name 		: swfName.split(".")[0]
    	}
    	
    	if( _doSend )
    		_airConnection.send( "_delorum_air_connect", "infoAboutSwf", _connectionId, infoObj );
    }

}

}