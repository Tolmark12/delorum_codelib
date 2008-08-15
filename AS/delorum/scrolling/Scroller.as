package delorum.scrolling
{

import flash.display.Sprite;
import flash.events.*;
import flash.geom.Rectangle;
import caurina.transitions.Tweener;


/**
* 	A simple scrollbar
* 	
*	@requires caurina.transitions.Tweener
* 	@example Sample usage:
* 	<listing version=3.0>
* 	
*	// Working code:
*	_scrollHolder = new Sprite();
*	
*	// Create vertical scroller and listen to onScroll updates
*	_scroller = new Scroller( _scrollHolder, 500, Scroller.VERTICAL );
*	_scroller.addEventListener( Scroller.SCROLL, _handlerScroll );
*	
*	// Manually et the scroller's height based on the realative scale of 
*	// the item we're scrolling and the window we're scrolling through.
*	_scroller.updateScrollWindow( window.width / target.width );
*	// You can also manually set the scrollbar's position
*	_scroller.changeScrollPosition( 0.5 );
*	
* 	</listing>
* 	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2008-07-07
* 	@rights	  Copyright (c) Delorum 2008. All rights reserved	
*/


public class Scroller extends EventDispatcher
{
	// NOTE: all var names assume a horizontal scrollbar orientation
	
	public static const SCROLL:String 		= "scroll";
	public static const VERTICAL:String 	= "vertical";
	public static const HORIZONTAL:String 	= "horizontal";
	
	// For tweening the bar
	public var barWidth:Number 		= 0;
	public var trackWidth:Number 	= 0;
	public var barHeight:Number		= 0;
	
	// Sizes
	private var _barHeight:Number  	 = 4;
	private var _padding:Number		 = 4;
	private var _arrowBtnSize:Number = 7;
	
	// Sprites
	private var _holderMc:Sprite;
	private var _trackMc:Sprite;
	private var _barMc:Sprite;
	private var _rightBtn:ArrowBtn;
	private var _leftBtn:ArrowBtn;
	
	// Colors
	private var _trackFill:uint;
	private var _trackStroke:uint;
	private var _barFill:uint;
	
	// Math
	private var _trackWidth:Number;						// The static width of the track
	private var _scrollWidth:Number;					// This is the horizontal width the scrollbar moves in
	private var _percentOfContentVisible:Number = 0.5;	// The quotient of the window's width / target's width
	
	// Dragging
	private var _dragArea:Rectangle;
	private var _isDragging:Boolean;
	private var _currentPercent:Number = 0;
	
	// Arrow Button
	private var _scrollIncrament:Number = 8;
	private var _scrollEasing:Number	= 1.04;
	private var _scrollSpeed:Number;
	private var _barTarget:Number		= 0;
	
	/** 
	*	Constructor
	*	
	*	@param		The sprite to build the scrollbar in
	*	@param		How wide (or tall) the scrollbar should be
	*	@param		Whether the scrollbar should be VERTICAL or HORIZONTAL
	*/
	public function Scroller( $parentMc:Sprite, $width:Number, $orientation:String = HORIZONTAL, 
	 						  $barFill:uint=0xFFFFFF, $trackFill:uint=0xDDDDDD, $trackStroke:uint=0xBBBBBB):void
	{
		barHeight    = _barHeight;
		_trackWidth  = $width;
		_holderMc    = new Sprite();
		_trackFill   = $trackFill;
		_trackStroke = $trackStroke;
		_barFill     = $barFill;
		
		$parentMc.addChild( _holderMc );
		_make();
		_changeOrientation( $orientation );
		_resetScrollSpeed();
	}
	
	// ______________________________________________________________ Make
	
	private function _make (  ):void
	{
		_trackMc 		= new Sprite();
		_barMc			= new Sprite();
		_rightBtn		= new ArrowBtn(  );
		_leftBtn		= new ArrowBtn(  );
		_leftBtn.scaleX = -1;
		
		_rightBtn.draw( _arrowBtnSize );
		_leftBtn.draw(  _arrowBtnSize );
		
		_holderMc.addChild( _trackMc  );
		_holderMc.addChild( _barMc    );
		_holderMc.addChild( _rightBtn );
		_holderMc.addChild( _leftBtn  );
		
		_barMc.buttonMode = true;
		_barMc.addEventListener( MouseEvent.MOUSE_DOWN, _startScroll );
		//_barMc.addEventListener( MouseEvent.MOUSE_OVER, _mouseOver   );
		//_barMc.addEventListener( MouseEvent.MOUSE_OUT, _mouseOut     );
		
		_rightBtn.incrament = 1;
		_leftBtn.incrament = -1;
		_rightBtn.addEventListener( ArrowBtn.INCRAMENT, _handleButtonClick );
		_leftBtn.addEventListener ( ArrowBtn.INCRAMENT, _handleButtonClick );
		_leftBtn.addEventListener ( MouseEvent.CLICK, _resetScrollSpeed );
		_rightBtn.addEventListener( MouseEvent.CLICK, _resetScrollSpeed );


		
		_drawTrack();
		updateScrollWindow(0);
	}   
	
	private function _changeOrientation( $orientation:String )
	{
		if( $orientation == HORIZONTAL ){
			_holderMc.x = _padding;
		}else{
			_holderMc.rotation = 90;
			_holderMc.x = barHeight + _padding;
		}

		_holderMc.y = _padding;
	}
	
	// ______________________________________________________________ API
	
	/** 
	*	This changes the bar-width to track-width ratio
	*	
	*	@param		The percentage (0 - 1) of the target that is visible in the window 
	*/
	public function updateScrollWindow ( $percentVisible:Number, $speed:Number=1 ):void
	{
		_percentOfContentVisible = $percentVisible;
		_scrollWidth = _trackWidth - (_trackWidth * _percentOfContentVisible);
		Tweener.addTween( this, { barWidth:_trackWidth * _percentOfContentVisible, time:$speed, transition:"EaseInOutQuint", onUpdate:_barTweenUpdate } );
		changeScrollPosition( _currentPercent, $speed );
	}
	
	public function changeWidth ( $newWidth:Number, $speed:Number=1 ):void
	{
		_trackWidth	= $newWidth;
		Tweener.addTween( this, { trackWidth:$newWidth, time:$speed, transition:"EaseInOutQuint", onUpdate:_trackTweenUpdate } );
	}
	
	public function changeHeight ( $newHeight:Number, $speed:Number=0.4 ):void
	{
		_barHeight = $newHeight;
		Tweener.addTween( this, { barHeight:_barHeight, time:$speed, transition:"EaseInOutQuint", onUpdate:_heightTweenUpdate} );
	}
	
	/** 
	*	Manually changes the scrollbar's position (0 - 1)
	*	
	*	@param		The scrollbar's percentage (0 - 1), 0 is at left (or top), 1 is at right, (or bottom)
	*/
	public function changeScrollPosition ( $percent:Number, $speed:Number=1 ):void
	{
		_currentPercent = $percent;
		Tweener.addTween( _barMc, { x:_scrollWidth * $percent,time:$speed, transition:"EaseInOutQuint"} );
	}
	
	// Called on tween update, see:  updateScrollWindow()
	private function _barTweenUpdate (  ):void
	{
		_drawBar();
	}
	
	private function _trackTweenUpdate (  ):void
	{
		_drawTrack();
		_positionButtons();
	}
	
	private function _heightTweenUpdate (  ):void
	{
		_drawBar();
		_drawTrack();
		_positionButtons();
	}
	
	// ______________________________________________________________ Drawing
	
	// This is called by via Tweener. see: updateScrollWindow()
	public function _drawBar ():void
	{
		_barMc.graphics.clear();
		_barMc.graphics.beginFill( _barFill );
		_barMc.graphics.drawRoundRect(0, 0, barWidth, barHeight, barHeight, barHeight);
		// Draw larger hit area
		_barMc.graphics.beginFill( 0xFF0000, 0 );
		_barMc.graphics.drawRect(0, barHeight * -2, barWidth, barHeight*5 );
		_dragArea = new Rectangle(0, 0, _scrollWidth, 0);
	}
	
	private function _positionButtons (  ):void
	{
		_rightBtn.x	= trackWidth + 10;
		_leftBtn.x	= -10;
		_rightBtn.y = _leftBtn.y = barHeight / 2;
	}
	
	public function _drawTrack ():void
	{
		_trackMc.graphics.clear();
		_trackMc.graphics.beginFill( _trackFill );
		_trackMc.graphics.lineStyle( 1, _trackStroke );
		_trackMc.graphics.drawRoundRect(-_padding, -_padding, trackWidth + _padding * 1.8, barHeight + _padding * 1.8, barHeight + _padding, barHeight + _padding);
	}
	
	// ______________________________________________________________ Scrolling Event Handlers
	
	private function _startScroll ( e:Event ):void
	{
		Tweener.removeTweens( _barMc, "x" );
		_isDragging = true;
		_barMc.startDrag( false, _dragArea );
		_barMc.stage.addEventListener( MouseEvent.MOUSE_MOVE, _sendScrollEvent );
		_barMc.stage.addEventListener( MouseEvent.MOUSE_UP, _stopScrolling );
		
	}
	
	private function _stopScrolling ( e:Event ):void
	{
		if( _isDragging ) 
		{
			_isDragging = false;
			_barMc.stopDrag();
			_barMc.stage.removeEventListener( MouseEvent.MOUSE_MOVE, _sendScrollEvent );1
			_barMc.stage.removeEventListener( MouseEvent.MOUSE_UP, _stopScrolling );
			
		}
	}
	
	private function _mouseOver ( e:Event ):void
	{
		changeHeight( 14 );
	}
	
	private function _mouseOut ( e:Event ):void
	{
		changeHeight(4);
	}
	
	private function _sendScrollEvent ( e:Event = null ):void
	{
		var scrollEvent:ScrollEvent = new ScrollEvent( SCROLL );
		
		// If this is triggered via arrow button click, set easing to none
		scrollEvent.easeMotion = ( e == null )? false : true;
		scrollEvent.percent = _currentPercent = _barMc.x / _scrollWidth;
		this.dispatchEvent( scrollEvent );
		// Update this var for use by scrolling buttons
		_barTarget = _barMc.x;
	}
	
	// ______________________________________________________________ Arrow Button click
	
	private function _handleButtonClick ( e:Event ):void
	{

		var x:Number = _barMc.x + e.currentTarget.incrament * _scrollIncrament;
        
		if( x > _scrollWidth ) 
			x = _scrollWidth;
		else if( x < 0)
			x = 0;
		
		if( x != _barMc.x ){ 	
			_barMc.x = x;
			_sendScrollEvent();
		}
		
		//Tweener.addTween( _barMc, { x:_barTarget, time:1, transition:"linear"} );
/*		var x:Number = _barTarget + _scrollSpeed * e.currentTarget.incrament;
		
		if( x > _scrollWidth ) 
			x = _scrollWidth;
		else if( x < 0)
			x = 0;
		
		if( Math.round(x) != Math.round(_barTarget) )
		{
			_barTarget = x;
			_scrollSpeed *= _scrollEasing;
			Tweener.addTween( _barMc, { x:_barTarget, time:0.1, transition:"linear"} );
			_sendScrollEvent();
		}
		*/
	}
	
	private function _resetScrollSpeed ( e:Event = null ):void
	{
		_scrollSpeed = _scrollIncrament;
	}
}

}
