package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import app.model.vo.*;
import app.AppFacade;
import flash.net.LocalConnection;
import delorum.utils.echo;
import flash.display.*;
import flash.events.*;

/** 
*	TODO: Either don't accept communications from previously initt-ed swfs or force swfs to send their url with every communication so we can initialize a new windwo at any point
*	TODO: Refresh scolling after each change? 
*	TODO: Think of creating a singleton method like Echo("asdf"); instead of echo("asdf");
*	TODO: Rewrite the client side echo-er
*	
*/

public class SwfTalkProxy extends Proxy implements IProxy
{
	public static const NAME:String = "swf_talk_proxy";

	// Local Connection
	private var _conn:LocalConnection;
	private var _idObject:Object = new Object();
	
	private var _activeWindowId:String = "";
	
	public function SwfTalkProxy( $rootSprite:Sprite ):void
	{
		super( NAME );
		initLocalConnection();
	}
	
	
	private function initLocalConnection (  ):void
	{
		// This is the connection that other swfs will connect to
		_conn = new LocalConnection();
		_conn.client = this;
		_conn.allowDomain('*');
		//_conn.allowInsecureDomain('localhost')
		
		try {
		    _conn.connect("_delorum_air_connect");
		} catch (error:ArgumentError) {
		}
	}
	
		
	// ______________________________________________________________ Local Connection API
	
	// These are called by EchoMachine swf
	public function initNewSwf ( $id:String, $swfUrl:String ):void
	{
		_checkIfOutputWindowExists( $id, $swfUrl );
	}
	
	/** 
	*	Called as a trace command
	*	@param		Accepts any kind of parameter. 
	*/
	public function print ( $id:String, ... $message ):void
	{
		_checkIfOutputWindowExists( $id );
		var len:uint = $message.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			// Add message to the stack
			sendNotification( AppFacade.NEW_MESSAGE, {id:$id, message:$message[i]} );
		}
		
		
	}
	
	/** 
	*	@param		Stats object: 
	*					fps : frames per second
	*					fr  : frame rate
	*					mem : memory
	*					ms  : miliseconds to render the frame
	*/
	public function stats ( $id:String, $statsObj:Object ):void
	{
		_checkIfOutputWindowExists( $id );
		var statsObj:StatsVO = new StatsVO( $statsObj );
		statsObj.id = $id;
		sendNotification( AppFacade.STATS, statsObj );
		echo("a bit...");
	}
	
	public function clear ( $id:String ):void
	{
		_checkIfOutputWindowExists( $id );
		//sendNotification( AppFacade.CLEAR_TEXT  );
		//sendNotification( AppFacade.CLEAR_STATS );
		//_content.clear();
		//_stats.clear();
	}
	
	public function infoAboutSwf ( $id:String, $obj:Object ):void
	{
		
		var vo:WindowInfoVO = new WindowInfoVO();
		vo.id 	= $id;
		vo.name = $obj.name;
		sendNotification( AppFacade.WINDOW_INFO, vo);
	}
	
	// ______________________________________________________________ Windows API
	
	/** 
	*	If not already acive, activates a certain window
	*	@param		id of window to activate	
	*/
	public function activateWindowById ( $id:String ):void
	{
		if( _activeWindowId != $id ) {
			_activeWindowId = $id;
			sendNotification( AppFacade.ACTIVATE_WINDOW, _activeWindowId );
			
		}
	}
	
	/** 
	*	Used to close a window
	*	@param		id of window to close
	*/
	public function killWindow ( $id:String ):void
	{
		delete _idObject[$id];
		// Tell the swf to stop broadcasting
		var airConnection:LocalConnection = new LocalConnection();
		airConnection.addEventListener("status", _emptyHandler);
		airConnection.send( $id, "stopBroadcasting" );
		// Kill the broadcasting window
		sendNotification( AppFacade.KILL_WINDOW, $id );
	}
	
	// ______________________________________________________________ Windows helpers
	
	/** 
	*	Checks if a window with the new id string currently exists. If not, it creates it
	*	@param		Id of window to check
	*/
	private function _checkIfOutputWindowExists ( $id:String, $swfUrl:String=null ):void
	{
		if( _idObject[$id] == null ) {
			_createNewSwf( $id, $swfUrl );
		}
	}
	
	/** 
	*	Creates a new window with a certain id
	*	@param		Id of window to create	
	*/
	private function _createNewSwf ( $id:String, $swfUrl:String ):void
	{
		// See if a swf in this location already exists..
		for( var i:String in _idObject ){
			if( _idObject[i] == $swfUrl ){
				killWindow(i);
			}
		}
			
		var vo:OutputerVO 	= new OutputerVO();
		vo.id          		= $id;
		vo.shortName   		= "$obj.name";
		vo.url         		= $swfUrl
		vo.swfName     		= "temp_name.swf";
		_idObject[$id] 		= $swfUrl;
		
		sendNotification( AppFacade.NEW_OUTPUTTER, vo );
		activateWindowById( vo.id );
		
		try
		{
			// Connect to new swf, and have it send the swf info
			var airConnection:LocalConnection = new LocalConnection();
			airConnection.addEventListener("status", _emptyHandler);
			airConnection.send( $id, "sendSwfInfo" );			
		} 
		catch (e:Error)
		{
			echo( e );
		}
	}
	
	private function _emptyHandler ( e:Event ):void{};
}
}