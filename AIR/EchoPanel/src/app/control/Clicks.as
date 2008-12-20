package app.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;

public class Clicks extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{	
		switch ( note.getName() )
		{
			
		}	
		//facade.registerProxy		( new SomeProxy() );
		//facade.registerMediator	( new SomeMediator() );
		
		//var someProxy:SomeProxy = facade.retrieveProxy( SomeProxy.NAME ) as SomeProxy;
		//var someMediator:SomeMediator = facade.retrieveMediator( SomeMediator.NAME ) as SomeMediator;
	}
}
}