package delorum.slides.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import delorum.slides.SlideShowFacade;
import delorum.slides.model.vo.*;
import flash.utils.Timer;
import flash.events.*;

public class AutoplayMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "autoplay_mediator";

	private var _timer:Timer;
	
	public function AutoplayMediator():void
	{
		super( NAME );
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [	SlideShowFacade.START_AUTOPLAY,
		    		SlideShowFacade.STOP_AUTOPLAY,
					SlideShowFacade.CHANGE_SLIDE_BY_INDEX,  ];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case SlideShowFacade.START_AUTOPLAY:
				_startTimer();
				break;
			
			case SlideShowFacade.STOP_AUTOPLAY:
				_stopTimer();
				break;
			case SlideShowFacade.CHANGE_SLIDE_BY_INDEX :
				_stopTimer();
				break;
		}
	}
	
	private function _startTimer (  ):void
	{
		_timer = new Timer( SlideShowFacade.slideDisplayTime * 1000 );
		_timer.addEventListener("timer", _tick);
		_timer.start();
	}
	
	private function _stopTimer (  ):void
	{
		if( _timer != null ) 
		{
			_timer.stop();
			_timer.removeEventListener("timer", _tick);
			_timer = null;
		}
	}
	
	// ______________________________________________________________ Event Handlers
	
	private function _tick ( e:Event ):void
	{
		facade.sendNotification( SlideShowFacade.NEXT_SLIDE, true );
	}
}
}