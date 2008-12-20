package delorum.slides.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import delorum.slides.view.*;
import delorum.slides.model.*;
import delorum.slides.SlideShowFacade;

public class ChangeTransitionSpeed extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{		
		switch ( note.getName() ){
			case SlideShowFacade.TRANSITION_SPEED_TO_CLICK :
				SlideShowFacade.useAutoSpeed = false;
			break;
			case SlideShowFacade.TRANSITION_SPEED_TO_AUTO :
				SlideShowFacade.useAutoSpeed = true;
			break;
		}
	}
}
}