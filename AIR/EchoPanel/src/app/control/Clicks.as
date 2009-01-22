package app.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;
import app.AppFacade;

public class Clicks extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{	
		
		var swfTalkProxy:SwfTalkProxy = facade.retrieveProxy( SwfTalkProxy.NAME ) as SwfTalkProxy;
		
		switch ( note.getName() )
		{
			// Called when a tab is clicked in ChromeMediator
			case AppFacade.TAB_CLICK :
				swfTalkProxy.activateWindowById( note.getBody() as String );
			break;
			
			// Called when a tab is closed	
			case AppFacade.TAB_CLOSE_CLICK :
				swfTalkProxy.killWindow( note.getBody() as String );
			break;
		}	
	}
}
}