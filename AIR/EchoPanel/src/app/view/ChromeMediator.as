package app.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import app.AppFacade;
import app.model.vo.*;
import app.view.components.*;
import app.view.components.ui.*;
import flash.display.Sprite;
import flash.events.*;
import delorum.echo.EchoMachine;

public class ChromeMediator extends Mediator implements IMediator
{	
	// Constants
	public static const NAME:String = "chrome_mediator";
	public static const ORIG_WIDTH:Number = 700;
	public static const ORIG_HEIGHT:Number = 200;
	
	
	private var _chrome:Chrome = new Chrome();
	
	public function ChromeMediator( ):void
	{
		super( NAME );
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [ 	AppFacade.ACTIVATE_WINDOW,
					AppFacade.NEW_OUTPUTTER,
					AppFacade.MINIMIZE,
					AppFacade.MAXIMIZE,
					AppFacade.APP_RESIZE,
					AppFacade.CLEAR_TEXT,
					AppFacade.CLEAR_STATS,
					AppFacade.WINDOW_INFO	];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case AppFacade.ACTIVATE_WINDOW :
				_chrome.activateTab( note.getBody() as String );
			break;
			case AppFacade.NEW_OUTPUTTER :
				var vo:OutputerVO = note.getBody() as OutputerVO;
				_chrome.addTab( vo.id, vo.shortName );
			break;
			case AppFacade.MINIMIZE:
				_chrome.minimize();
			break;
			case AppFacade.MAXIMIZE :
				_chrome.maximize();
			break;
			case AppFacade.APP_RESIZE :
				var obj:Object = note.getBody() as Object;
				_chrome.resize( obj.width, obj.height );
			break;
			case AppFacade.WINDOW_INFO :
				var windowInfo:WindowInfoVO = note.getBody() as WindowInfoVO;
				_chrome.setTabInfo( windowInfo )
			break;
		}
	}
	
	// ______________________________________________________________ Make
	public function make ( $rootSprite:Sprite ):void
	{
		$rootSprite.addChild( _chrome );
		_chrome.addEventListener( DragBar.HIDE_CONTENT, _onContentToggle, false,0,true );
		_chrome.addEventListener( DragBar.SHOW_CONTENT, _onContentToggle, false,0,true );
		_chrome.addEventListener( Resizer.WINDOW_RESIZE, _onResize, false,0,true );
		_chrome.addEventListener( DragBar.RESET, _onClear, false,0,true  );
		_chrome.addEventListener( Tab.TAB_CLICK, _onTabClick, false,0,true );
		_chrome.addEventListener( Tab.TAB_CLOSE, _onTabCloseClick, false,0,true );
		_chrome.make( ORIG_WIDTH, ORIG_HEIGHT );
	}
	
	/** 
	*	Resize the application to the default size
	*/
	public function firstResize (  ):void{
		_onResize( new Event("none") );
	}
	
	// ______________________________________________________________ Event Handlers
	/** 
	*	@private Called when HIDE_CONTENT or SHOW_CONTENT is called
	*/
	private function _onContentToggle ( e:Event ):void{
		if( e.type == DragBar.HIDE_CONTENT )
			sendNotification( AppFacade.MINIMIZE );
		else
			sendNotification( AppFacade.MAXIMIZE );
	}
	
	/** 
	*	@private Called when Resizer.NEW_WINDOW_SIZE triggers
	*/
	private function _onResize ( e:Event ):void{
		sendNotification( AppFacade.APP_RESIZE, {width:_chrome.appWidth, height:_chrome.appHeight, barHeight:_chrome.barHeight } );
	}
	
	/** 
	*	@private Called when RESET is called
	*/
	private function _onClear ( e:Event ):void{
		sendNotification( AppFacade.CLEAR_TEXT );
		sendNotification( AppFacade.CLEAR_STATS );
	}
	
	/** 
	*	@private Called when one of the tabs are clicked in the chrome
	*/
	private function _onTabClick ( e:Event ):void{
		sendNotification( AppFacade.TAB_CLICK, _chrome.activeTabId );
	}
	
	private function _onTabCloseClick ( e:Event ):void{
		sendNotification( AppFacade.TAB_CLOSE_CLICK, _chrome.activeTabId );
	}
	
	// ______________________________________________________________ Getters / Setters
	
	public function get height (  ):Object{ return _chrome.dragBarHeight; };
	
}
}