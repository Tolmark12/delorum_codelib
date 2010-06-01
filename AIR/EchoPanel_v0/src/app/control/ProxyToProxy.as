package app.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;
import app.AppFacade;

public class ProxyToProxy extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{
		var logProxy:LogProxy = facade.retrieveProxy( LogProxy.NAME ) as LogProxy;
		
		switch ( note.getName() )
		{
			case AppFacade.NEW_MESSAGE :
				var stackObj:Object = note.getBody() as Object;
				logProxy.addMessageToStack( stackObj.id, stackObj.message );
			break;
			case AppFacade.NEW_OUTPUTTER :
				logProxy.addNewLog( note.getBody() as OutputerVO );
			break;
			case AppFacade.KILL_WINDOW :
				logProxy.deleteLog( note.getBody() as String );
			break;
			
		}
	}
}
}