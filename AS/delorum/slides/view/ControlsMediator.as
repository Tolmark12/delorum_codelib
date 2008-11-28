package delorum.slides.view
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.mediator.Mediator;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import delorum.slides.*;
import flash.display.Sprite;
import delorum.slides.view.components.*;
import flash.events.*;

public class ControlsMediator extends Mediator implements IMediator
{	
	public static const NAME:String = "controls_mediator";
	
	// Display
	private var _holderMc:Sprite;
	private var _controlsHolder:Sprite;
	private var _btnsAr:Array;
	private var _currentBtn:ThumbnailBtn;
	private var _playPauseBtn:PlayPauseBtn;
	
	public function ControlsMediator( $holderMc:Sprite ):void
	{
		super( NAME );
		_holderMc = $holderMc;
   	}
	
	// PureMVC: List notifications
	override public function listNotificationInterests():Array
	{
		return [	SlideShowFacade.INIT_SLIDES,
		    		SlideShowFacade.DISPLAY_NEW_SLIDE,
		 			SlideShowFacade.STOP_AUTOPLAY,
					SlideShowFacade.START_AUTOPLAY,
					SlideShowFacade.CHANGE_SLIDE_BY_INDEX ];
	}
	
	// PureMVC: Handle notifications
	override public function handleNotification( note:INotification ):void
	{
		switch ( note.getName() )
		{
			case SlideShowFacade.INIT_SLIDES:
				_createControls( note.getBody() as Array );
				break;
			case SlideShowFacade.DISPLAY_NEW_SLIDE:
				var slideVo:Slide_VO = note.getBody() as Slide_VO;
				_activateBtn( slideVo.index );
				break;
			case SlideShowFacade.START_AUTOPLAY:
				_playPauseBtn.changeState( PlayPauseBtn.PAUSE );
				break;
			case SlideShowFacade.STOP_AUTOPLAY:
			case SlideShowFacade.CHANGE_SLIDE_BY_INDEX:
				_playPauseBtn.changeState( PlayPauseBtn.PLAY  );
				break
		}
	}
	
	// ______________________________________________________________ Make
	
	private function _createControls ( $slides:Array ):void
	{
		
		_controlsHolder = new Sprite();
		_controlsHolder.y = SlideShowFacade.slidesHeight + 5;
		_holderMc.addChild( _controlsHolder );
		_btnsAr = new Array();
		var xInc:uint = 15;
		
		
		var len:uint  = $slides.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var slideVo:Slide_VO = $slides[i];
			var btn:ThumbnailBtn = new ThumbnailBtn(slideVo);
			
			btn.build();
			btn.unHighlight();
			btn.addEventListener( MouseEvent.CLICK, _handleBtnClick );
			btn.x = xInc * i;
			_btnsAr[slideVo.index] = btn;
			
			_controlsHolder.addChild(btn);
		}
		
		// Create play and pause button
		_playPauseBtn = new PlayPauseBtn();
		_playPauseBtn.addEventListener( PlayPauseBtn.PAUSE, _pauseShow );
		_playPauseBtn.addEventListener( PlayPauseBtn.PLAY,  _playShow  );
		_playPauseBtn.x = _controlsHolder.width  + 20;
		
		// Create previous and next buttons
		var rightBtn:ArrowBtn = new ArrowBtn( ArrowBtn.RIGHT );
		var leftBtn:ArrowBtn  = new ArrowBtn( ArrowBtn.LEFT  );
		rightBtn.x = SlideShowFacade.slidesWidth - rightBtn.width/4 - 5;
		leftBtn.x  = SlideShowFacade.slidesWidth - leftBtn.width - 5;
		rightBtn.addEventListener( MouseEvent.CLICK, _handleArrowBtnClick );
		leftBtn.addEventListener(  MouseEvent.CLICK, _handleArrowBtnClick );
		
		_controlsHolder.addChild( _playPauseBtn );
		_controlsHolder.addChild( rightBtn		);
		_controlsHolder.addChild( leftBtn		);
	}
	
	private function _activateBtn ( $index:uint ):void
	{
		if( _currentBtn != null )
			_currentBtn.unHighlight();
		_currentBtn = _btnsAr[ $index ] as ThumbnailBtn;
		_currentBtn.highlight();
	}
	
	// ______________________________________________________________ Event Handlers
	
	private function _handleBtnClick ( e:Event ):void{
		facade.sendNotification( SlideShowFacade.TRANSITION_SPEED_TO_CLICK );
		facade.sendNotification( SlideShowFacade.CHANGE_SLIDE_BY_INDEX, e.currentTarget.slideIndex );
	}
	
	private function _pauseShow ( e:Event ):void{
		facade.sendNotification( SlideShowFacade.STOP_AUTOPLAY );
	}
	
	private function _playShow ( e:Event ):void{
		facade.sendNotification( SlideShowFacade.START_AUTOPLAY );
		facade.sendNotification( SlideShowFacade.TRANSITION_SPEED_TO_CLICK );
		facade.sendNotification( SlideShowFacade.NEXT_SLIDE, true );
	}
	
	private function _handleArrowBtnClick ( e:Event ):void{
		facade.sendNotification( SlideShowFacade.TRANSITION_SPEED_TO_CLICK );
		facade.sendNotification( SlideShowFacade.STOP_AUTOPLAY );
		
		if( e.currentTarget.direction == ArrowBtn.RIGHT )
			facade.sendNotification( SlideShowFacade.NEXT_SLIDE, true);
		else
			facade.sendNotification( SlideShowFacade.PREV_SLIDE, true);
			
	}
	
	
	
}
}