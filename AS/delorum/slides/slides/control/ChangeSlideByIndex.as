package delorum.slides.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import delorum.slides.view.*;
import delorum.slides.model.*;


public class ChangeSlideByIndex extends SimpleCommand implements ICommand
{

	override public function execute( notification:INotification ):void
	{
		var newIndex:uint		= notification.getBody() as uint;
		var slideShowProxy:SlideShowProxy 	= facade.retrieveProxy( SlideShowProxy.NAME ) as SlideShowProxy;
		slideShowProxy.changeSlide( newIndex );
	}
}
}