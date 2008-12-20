package delorum.slides.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import delorum.slides.view.*;
import delorum.slides.model.*;

import delorum.slides.SlideShow_VO;

public class BuildSlides extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{
		var slideShowVo:SlideShow_VO 		= note.getBody() as SlideShow_VO;
		var slideShowProxy:SlideShowProxy 	= facade.retrieveProxy( SlideShowProxy.NAME ) as SlideShowProxy;
		
		slideShowProxy.buildSlides( slideShowVo );
	}
}
}