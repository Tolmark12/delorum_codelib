package app.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import app.AppFacade;
import app.model.vo.*;
import app.view.components.*;
import flash.display.Sprite;
import delorum.utils.echo;

public class OutputMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "trace_mediator";
	
	// Outputter management
	private var _windows:Array = new Array();
	private var _windowsHolder:Sprite = new Sprite();
	private var _activeWindowId:String;
	private var _currentAppSize:Object;
	
	public function OutputMediator(  ):void
	{
		super( NAME );
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return  [ 	AppFacade.ECHO_MESSAGE,
					AppFacade.NEW_OUTPUTTER,
		 		 	AppFacade.ACTIVATE_WINDOW,
		 			AppFacade.APP_RESIZE,
					AppFacade.MINIMIZE,
					AppFacade.MAXIMIZE,
					AppFacade.STATS,
					];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case AppFacade.STATS :
				var statsVo:StatsVO = note.getBody() as StatsVO;
				_getWindowById( statsVo.id ).updateStats( statsVo.fps, statsVo.frameRate, statsVo.memoryUsed, statsVo.ms );      
			break;
			case AppFacade.ECHO_MESSAGE :
				var echoVo:EchoVO = note.getBody() as EchoVO;
			   _getWindowById( echoVo.id ).addTextToStack( echoVo.echoTxt );
			break;
			case AppFacade.NEW_OUTPUTTER:
				var vo:OutputerVO = note.getBody() as OutputerVO;
				_addWindow( vo.id );
			break;
			case AppFacade.ACTIVATE_WINDOW :
				_activateOutputWindow( note.getBody() as String);
			break;
			case AppFacade.APP_RESIZE :
				var obj:Object = note.getBody() as Object;
				_currentAppSize = obj;
				_windowsHolder.y = obj.barHeight
				if( _activeWindowId != null ) {
					currentWindow.resize( obj.width, obj.height );
				}
			break;
			case AppFacade.MINIMIZE :
				_windowsHolder.visible = false;
			break;
			case AppFacade.MAXIMIZE :
				_windowsHolder.visible = true;
			break;
		}
	}
	
	// ______________________________________________________________ Make
	
	/** 
	*	Creates window holder and adds to stage
	*/
	public function make ( $rootSprite:Sprite ):void
	{
		$rootSprite.addChildAt( _windowsHolder, 1 );
	}
	
	// ______________________________________________________________ Output Windows
	
	/** 
	*	Create a new Output window
	*	@param		Output window id
	*/
	private function _addWindow ( $windowId:String ):void
	{
		var output:Output = new Output( $windowId );
		output.make()
		_windows.push( output );
		_windowsHolder.addChild( output );
		output.resize(_currentAppSize.width, _currentAppSize.height);
		
		if( _windows.length == 1 ) 
			_activateOutputWindow( $windowId );
	} 
	
	/** 
	*	Activate a particular window
	*	@param		Id of window to activate
	*/
	private function _activateOutputWindow ( $windowId:String ):void
	{
		// Hide current window
		if( _activeWindowId != null && _activeWindowId != $windowId ) {
			if( currentWindow != null ) 
				currentWindow.visible = false;
		}
		
		// Show new window
		_activeWindowId = $windowId;
		currentWindow.visible = true
	}
	
	// ______________________________________________________________ Helpers
	
	/** 
	*	Get a particular Output
	*	@param		Id of Output to return
	*	@return		Output window with particular id
	*/
	private function _getWindowById ( $windowId:String ):Output
	{
		var len:uint = _windows.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			if( (_windows[i] as Output ).windowId == $windowId ) 
				return _windows[i] as Output;
		}
		return null;
	}
	
	/** 
	*	@return		Returns the active Outpu
	*/
	public function get currentWindow (  ):Output { return _getWindowById( _activeWindowId ); };
	
}
}