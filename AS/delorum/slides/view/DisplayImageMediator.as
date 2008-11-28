package delorum.slides.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import flash.display.*;
import flash.events.*;
import delorum.slides.*;
import delorum.slides.view.components.Slide;
import caurina.transitions.Tweener;
import delorum.loading.ImageLoader;

public class DisplayImageMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "slide_show_mediator";

	// Display
	private var _slideHolder:Sprite;
	private var _slides:Object = new Object();
	private var _newSlide:Slide;
	private var _oldSlide:Slide;
	private var _bgBitmapHolder:Sprite;
	
	public function DisplayImageMediator( $holderMc:Sprite ):void
	{
		super( NAME );
		_bgBitmapHolder = new Sprite();
		_slideHolder = new Sprite();
		$holderMc.addChild(_bgBitmapHolder);
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
			_slides[id] = new Slide();
			_slides.imageUrl = $slide.imagePath;
			_newSlide = _slides[id];
			_newSlide.isBlank = $slide.imagePath.indexOf("__blank__") != -1;
			
			_slideHolder.addChild( _slides[id] );

			if( !_newSlide.isBlank )
			{
				// load image
				var ldr:ImageLoader = new ImageLoader( $slide.imagePath, _slides[id] );
				ldr.onComplete = _showNewSlide;
				ldr.loadItem();
			} else {
				_showNewSlide();
			}
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
		
		// Take snapshot of currentdisplay
		_bgBitmapHolder.alpha = 1;
		_bgBitmapHolder.visible = true;
		var bmd:BitmapData = new BitmapData( SlideShowFacade.slidesWidth, SlideShowFacade.slidesHeight, true, 0x000000 );
		bmd.draw(_slideHolder);
		var bitmap:Bitmap = new Bitmap(bmd);
		if( _bgBitmapHolder.numChildren != 0 ) 
			_bgBitmapHolder.removeChildAt(0);
		_bgBitmapHolder.addChildAt( bitmap, 0 );
		if( _oldSlide != null ) 
			_oldSlide.visible = false;
		
		if( !_newSlide.isBlank ) {
			_newSlide.alpha = 0;
			_newSlide.visible = true;
			Tweener.addTween(_newSlide, {alpha:1, time:SlideShowFacade.getTransitionSpeed(), onComplete:_hidePreviousSlide} );
		} else {
			Tweener.addTween(_bgBitmapHolder, {alpha:0, time:SlideShowFacade.getTransitionSpeed(), onComplete:_hidePreviousSlide} );
		}
	}	
	
	private function _hidePreviousSlide (  ):void
	{
		//_bgBitmapHolder.visible = false;
	}
	
	private function _setStackOrder():void
	{
		_slideHolder.setChildIndex(_newSlide, _slideHolder.numChildren - 1);
	}
}
}