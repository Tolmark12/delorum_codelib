package app
{
import org.puremvc.as3.multicore.interfaces.IFacade;
import org.puremvc.as3.multicore.patterns.facade.Facade;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import app.control.*;
import flash.display.Sprite;

public class AppFacade extends Facade implements IFacade
{
	public static const STARTUP:String = "startup";
	
	// Messages
	public static const WINDOW_INFO:String       	= "window_info";
	public static const NEW_OUTPUTTER:String     	= "new_outputer";
	public static const ACTIVATE_WINDOW:String   	= "activate_window";
	public static const KILL_WINDOW:String 			= "kill_window";
	public static const ECHO_MESSAGE:String      	= "echo_message";
	public static const STATS:String             	= "stats";
	public static const CLEAR_TEXT:String        	= "clear_text";
	public static const CLEAR_STATS:String       	= "clear_stats";
	                                             	
	// UI                                        	
	public static const BAR_HEIGHT_CHANGE:String 	= "bar_height_change";
	public static const APP_RESIZE:String        	= "app_resize";
	public static const MINIMIZE:String          	= "minimize";
	public static const MAXIMIZE:String          	= "maximize";
	public static const TAB_CLICK:String         	= "tab_click";
	public static const TAB_CLOSE_CLICK:String 		= "tab_close_click";

	public function AppFacade( key:String ):void
	{
		super(key);	
	}

	/** Singleton factory method */
	public static function getInstance( key:String ) : AppFacade 
    {
        if ( instanceMap[ key ] == null ) instanceMap[ key ]  = new AppFacade( key );
        return instanceMap[ key ] as AppFacade;
    }
	
	public function startup($stageSprite:Sprite):void
	{
	 	sendNotification( STARTUP, $stageSprite ); 
	}

	/** Register Controller commands */
	override protected function initializeController( ) : void 
	{
		super.initializeController();			
		registerCommand( STARTUP, Startup );
		registerCommand( TAB_CLICK, Clicks );
		registerCommand( TAB_CLOSE_CLICK, Clicks );
	}

}
}