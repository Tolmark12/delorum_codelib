package delorum.slides.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import delorum.slides.view.*;
import delorum.slides.model.*;
import delorum.slides.model.vo.*;
import delorum.slides.SlideShowFacade;

public class IncramentSlide extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{
		var loopOnOvershoot:Boolean = note.getBody() as Boolean;
		var slideShowProxy:SlideShowProxy 	= facade.retrieveProxy( SlideShowProxy.NAME ) as SlideShowProxy;
		
		
		switch( note.getName() )
		{
			case SlideShowFacade.NEXT_SLIDE:
			  		slideShowProxy.incramentSlideIndex(1, loopOnOvershoot);
			break;
			
			case SlideShowFacade.PREV_SLIDE:
			  slideShowProxy.incramentSlideIndex(-1, loopOnOvershoot);
			break;
		}

	}
}
}