package app.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import app.AppFacade;
import app.model.vo.*;
import app.view.components.*;
import flash.display.Sprite;
import flash.events.*;
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

	// FLIX: I need to refresh the display on the following events:
	// Switching tabs
	// Adding / Removing tabs (doesn't jog down right)
	
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
					AppFacade.CELL_DATA_TO_ID,
					AppFacade.NEW_ITEM_IN_STACK,
					AppFacade.REFRESH_WINDOW,
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
			case AppFacade.NEW_ITEM_IN_STACK :
				var output:Outputter = _getWindowById( note.getBody() as String );
				sendNotification( AppFacade.CELL_DATA_REQUEST, {id:output.windowId, percent:output.percentOfStack, stackSize:output.stackSize} );
			break;
			case AppFacade.NEW_OUTPUTTER:
				var vo:OutputerVO = note.getBody() as OutputerVO;
				_addWindow( vo.id );
			break;
			case AppFacade.ACTIVATE_WINDOW :
				_activateOutputWindow( note.getBody() as String);
				sendNotification( AppFacade.REFRESH_WINDOW );
			break;
			case AppFacade.APP_RESIZE :
				_currentAppSize = note.getBody() as Object;
				_windowsHolder.y = _currentAppSize.barHeight
				if( _activeWindowId != null ) {
					currentWindow.resize( _currentAppSize.width, _currentAppSize.height );
					sendNotification( AppFacade.CELL_DATA_REQUEST, {id:currentWindow.windowId, percent:currentWindow.percentOfStack, stackSize:currentWindow.stackSize} );
					
				}
			break;
			case AppFacade.MINIMIZE :
				_windowsHolder.visible = false;
			break;
			case AppFacade.MAXIMIZE :
				_windowsHolder.visible = true;
			break;
			case AppFacade.CELL_DATA_TO_ID :
				var data:CellDataUpdateVO = note.getBody() as CellDataUpdateVO;
				_getWindowById( data.id ).changeData( data.cellData );
			break;
			case AppFacade.REFRESH_WINDOW :
				if( _currentAppSize != null ){
					sendNotification( AppFacade.APP_RESIZE, _currentAppSize );
				}
			break;
			case AppFacade.KILL_WINDOW :
				// NOT COMPLETE, sub objects not deallocated
				var id:String = note.getBody() as String;
				var out:Output = _getWindowById( id );
				_windowsHolder.removeChild( out );
				_removeOutputFromArray( id );
				output.destruct();
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
		output.addEventListener( Output.CELL_DATA_REQUEST, _onCellDataRequest, false,0,true );
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
		echo( "new window is active" )
	}
	
	// ______________________________________________________________ Event Handlers
	
	private function _onCellDataRequest ( e:Event ):void {
		var output:Output = e.target as Output;
		sendNotification( AppFacade.CELL_DATA_REQUEST, {id:output.windowId, percent:output.percentOfStack, stackSize:output.stackSize} );
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
	*	Remove an Output from the array by id
	*	@param		id of Output window
	*/
	private function _removeOutputFromArray ( $windowId:String ):void
	{
		var len:uint = _windows.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			if( (_windows[i] as Output ).windowId == $windowId )
				_windows.splice(i,1);
		}
	}
	
	/** 
	*	@return		Returns the active Outpu
	*/
	public function get currentWindow (  ):Output { return _getWindowById( _activeWindowId ); };
}
}