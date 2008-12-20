package delorum.slides.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import delorum.slides.SlideShowFacade;
import delorum.slides.SlideShow;
import delorum.slides.view.*;
import delorum.slides.model.*;


public class Startup extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{
		var holderMc:SlideShow = note.getBody() as SlideShow;

		// If the main holder is defined...
		if( holderMc != null ) 
		{
			//...create
			var autoPlayMediator:AutoplayMediator    	= new AutoplayMediator();
			var slideShowMediator:DisplayImageMediator 	= new DisplayImageMediator( holderMc );
			var controlsMediator:ControlsMediator      	= new ControlsMediator( holderMc );
			var slideShowProxy:SlideShowProxy		 	= new SlideShowProxy();
			
			facade.registerMediator	( autoPlayMediator  );
			facade.registerMediator	( slideShowMediator );
			facade.registerMediator	( controlsMediator  );
			facade.registerProxy	( slideShowProxy    );
		}
		// Else, we are tearing down...
		else
		{
			//...destroy
			sendNotification( SlideShowFacade.STOP_AUTOPLAY );
			
			facade.removeMediator( ControlsMediator.NAME  );
			facade.removeMediator( AutoplayMediator.NAME  );
			facade.removeProxy( SlideShowProxy.NAME		  );
			facade.removeProxy( DisplayImageMediator.NAME );
		}
		
	}
}
}