package delorum.slides.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import flash.display.Sprite;
import flash.events.*;
import delorum.slides.*;
import delorum.slides.model.vo.*;
import caurina.transitions.Tweener;
import delorum.loading.ImageLoader;

public class DisplayImageMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "slide_show_mediator";

	// Display
	private var _slideHolder:Sprite;
	private var _slides:Object = new Object();
	private var _newSlide:Sprite;
	private var _oldSlide:Sprite;
	
	public function DisplayImageMediator( $holderMc:Sprite ):void
	{
		super( NAME );
		_slideHolder = new Sprite();
		$holderMc.addChild(_slideHolder);
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [	SlideShowFacade.DISPLAY_NEW_SLIDE,
			   ];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case SlideShowFacade.DISPLAY_NEW_SLIDE:
				var newSlide:Slide_VO = note.getBody() as Slide_VO;
				_swapSlides( newSlide );
				_setStackOrder();
			break;
		}
	}
	

	// ______________________________________________________________ Private Methods

	// Set the "_newSlide" variable in preparation to showing the slide
	private function _swapSlides ( $slide:Slide_VO ):void
	{
		var id:String = $slide.id;
		_oldSlide = _newSlide;

		if( _slides[id] == null )
		{
			//...create it...
			_slides[id] = new Sprite();
			_newSlide = _slides[id];
			_slideHolder.addChild( _slides[id] );
			
			// load image
			var ldr:ImageLoader = new ImageLoader( $slide.imagePath, _slides[id] );
			ldr.onComplete = _showNewSlide;
			ldr.loadItem();
		}
		else
		{
			//...else show existing slide.
			_newSlide = _slides[id];
			_showNewSlide();
		}		
	}

	// Bring the current slide to the front, and display it. 
	private function _showNewSlide ( e:Event = null ):void
	{
		_newSlide.alpha = 0;
		Tweener.addTween(_newSlide, {alpha:1, time:SlideShowFacade.transitionSpeed} );
	}	
	
	private function _setStackOrder():void
	{
		_slideHolder.setChildIndex(_newSlide, _slideHolder.numChildren - 1);
	}
}
}