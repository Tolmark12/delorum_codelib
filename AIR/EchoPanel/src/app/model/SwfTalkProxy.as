package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import app.model.vo.*;
import app.AppFacade;
import flash.net.LocalConnection;
import delorum.echo.EchoMachine;
import flash.display.*;

public class SwfTalkProxy extends Proxy implements IProxy
{
	public static const NAME:String = "swf_talk_proxy";

	// Local Connection
	private var _conn:LocalConnection;
	private var _idObject:Object = new Object();;
	
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
		try {
		    _conn.connect("_delorum_air_connect");
		} catch (error:ArgumentError) {
		}
	}
	
		
	// ______________________________________________________________ Local Connection API
	
	// These are called by EchoMachine swf
	
	public function initNewSwf ( $id:String ):void
	{
		_checkIfOutputWindowExists( $id );
	}
	
	/** 
	*	Called as a trace command
	*	@param		Accepts any kind of parameter. 
	*/
	public function echo ( $id:String, ... $message ):void
	{
		_checkIfOutputWindowExists( $id );
		
		//_content.addText( $str);
		var vo:EchoVO = new EchoVO();
		vo.id = $id;
		
		var len:uint = $message.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			if( $message[i] is String ) {				// String
				vo.echoTxt   = $message[i];
				vo.echoColor = 0x0000FF;
			} else if( $message[i] is Number ) {		// Number
				vo.echoTxt   = String($message[i]);
				vo.echoColor = 0xFF0000;
			} else if( $message[i] is DisplayObject ) {	// Display Object
				var mc:DisplayObject = $message[i];
				vo.echoTxt   = String( mc );
				vo.echoColor = 0x00FF00;
				vo.metaTxt   = "x:" + mc.x + ", y:" + mc.y + ", width:" + mc.width + 
								", height:" + mc.height + ", alpha:" + mc.alpha + ", vis:" + 
								mc.visible + ", added:" + ((mc.parent == null)? "no" : "yes"); 
				vo.metaColor = 0xCCCCCC;
			}
			sendNotification( AppFacade.ECHO_MESSAGE, vo );
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
		EchoMachine.echo( $id );
		sendNotification( AppFacade.STATS, statsObj );
	}
	
	public function clear ( $id:String ):void
	{
		_checkIfOutputWindowExists( $id );
		//sendNotification( AppFacade.CLEAR_TEXT  );
		//sendNotification( AppFacade.CLEAR_STATS );
		//_content.clear();
		//_stats.clear();
	}
	
	// ______________________________________________________________ API
	private function _checkIfOutputWindowExists ( $id:String ):void
	{
		if( _idObject[$id] == null ) {
			EchoMachine.echo( $id + ": create output" );
			_createNewSwf( $id );
		}
	}
	
	private function _createNewSwf ( $id:String ):void
	{
		var vo:OutputerVO = new OutputerVO();
		vo.id = $id;
		vo.shortName = "temp_data";
		vo.swfName = "temp_name.swf";
		_idObject[$id] = "";
		sendNotification( AppFacade.NEW_OUTPUTTER, vo );
	}
}
}