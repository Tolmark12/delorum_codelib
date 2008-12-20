package delorum.slides.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import delorum.slides.*;

public class SlideShowProxy extends Proxy implements IProxy
{
	public static const NAME:String = "slide_show_proxy";
	private var _currentSlideIndex:uint;
	private var _totalSlides:uint;
	private var _slideList:Array;
	private var _xmlData:XML;
	

	public function SlideShowProxy( ):void
	{
		super( NAME );
	}
	
	public function buildSlides ( $slideVo:SlideShow_VO ):void
	{
		_slideList = $slideVo.slides
		_totalSlides = _slideList.length;
		_currentSlideIndex = 0;
		
		// Send observers a list of slides
		sendNotification( SlideShowFacade.INIT_SLIDES, _slideList );
		// load the first slide
		sendNotification( SlideShowFacade.DISPLAY_NEW_SLIDE, this.currentSlide );
		sendNotification( SlideShowFacade.START_AUTOPLAY );
	}
	
	/** 
	*	Incrament the slide index
	*	@param		The incrament amount. This can be a positive OR a negative number.
	*/
	public function incramentSlideIndex ( $incrament:int, $loopOnOverShoot:Boolean=false ):void
	{
		var newIndex:int = _currentSlideIndex + $incrament;
		
		// Make sure the new index falls within the range of slides
		if( newIndex > _totalSlides - 1 )		
			newIndex = ($loopOnOverShoot)? 0 : _totalSlides - 1;	// if new index is greater than the last slide, show last slide.
		else if( newIndex < 0 )				
			newIndex = ($loopOnOverShoot)? _totalSlides - 1 : 0;					// if the index is less than 0, show first slide.
		
		// Only send broadcast if the new slide 
		// is different than the current slide
		if( _currentSlideIndex != newIndex ) 
		{
			_currentSlideIndex = newIndex;
			sendNotification( SlideShowFacade.DISPLAY_NEW_SLIDE, this.currentSlide );
		}
	}
	
	/** 
	*	Change which slide to display by passing the new slide index
	*	@param		The index of the new slide
	*/
	public function changeSlide ( $newIndex:uint ):void
	{
		var plusOrMinus:int 		= ($newIndex > _currentSlideIndex)? 1 : -1;
		var incramentDifference:int	= Math.abs( _currentSlideIndex - $newIndex ) * plusOrMinus;
		incramentSlideIndex( incramentDifference );
	}
	
	// ______________________________________________________________ Getters and setters
	public function get currentSlideIndex 	(  ):uint{ return _currentSlideIndex; 	};
	public function get totalSlides			(  ):uint{ return _totalSlides; 		};
	public function get currentSlide 		(  ):Slide_VO{ return _slideList[ _currentSlideIndex ]; };
	
}
}