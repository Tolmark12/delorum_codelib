/*

Change Log:

1) Added $height + $padding to the constructor
2) Removed the holder mc and changed the way it sets the x and y, now need to attach movie clip
3) Added the build function to start things moving
4) Made scroll bar and scroll track external classes

*/
package delorum.scrolling
{

import flash.display.Sprite;
import flash.events.*;
import flash.geom.*;
import caurina.transitions.Tweener;

/**
* 	A simple scrollbar
* 	
*	@requires caurina.transitions.Tweener
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2008-07-07
* 	@rights	  Copyright (c) Delorum 2008. All rights reserved	
*/


public class Scroller extends Sprite
{
	// NOTE: all var names assume a horizontal scrollbar orientation
	
	public static const SCROLL:String 		= "scroll";
	public static const VERTICAL:String 	= "vertical";
	public static const HORIZONTAL:String 	= "horizontal";
	
	// For tweening the bar
	public var barWidth:Number 		= 0;
	public var trackWidth:Number 	= 0;
	public var barHeight:Number		= 0;
	
	// Which scroll assets to use
	private var _useDefaultScroller:Boolean = false;
	
	// Horizontal or Vertical
	private var _orientaion:String;
	
	// Sizes
	private var _barHeight:Number  	 = 4;
	
	// Sprites
	private var _track:BaseScrollTrack;
	private var _rightBtn:BaseScrollBtn;
	private var _leftBtn:BaseScrollBtn;
	private var _scrollBar:BaseScrollBar;
	
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
	*	@param		How wide (or tall if scrolling vertical) the scroll track should be
	*	@param		How tall (or wide if scrolling vertical) the scroll track should be
	*	@param		Whether the scrollbar should be VERTICAL or HORIZONTAL
	*/
	public function Scroller(  $width:Number, $height:Number, $orientation:String = HORIZONTAL ):void
	{
		_barHeight	 = barHeight = $height;
		_trackWidth  = $width;
		_orientaion	 = $orientation;
	}
	
	// ______________________________________________________________ Make
	
	/**
	*	Sets the styling for the default scroller 
	*	
	*	@param		The padding between the scroll track and the scrollbar
	*	@param		The scrollbar's color
	*	@param		the scroll track's color
	*	@param		The scroll track's stroke color
	*	@param		Size of the arrow buttons
	*	@param		Button Color
	*/
	public function styleDefaultScroller ( $barFill:uint=0xFFFFFF, $trackFill:uint=0xDDDDDD, $trackStroke:uint=0xBBBBBB, $padding:Number=4, $buttonPadding:Number=10, $buttonSize:Number=7, $buttonColor:uint=0xFFFFFF ):void
	{
		_useDefaultScroller  = true;
		_barHeight	 		 = barHeight = _barHeight - $padding;
		_track				 = new DefaultScrollTrack( $trackFill, $trackStroke, $padding );
		_scrollBar			 = new DefaultScrollBar( $barFill, 1.2 );
		_rightBtn			 = new DefaultScrollBtn( $buttonPadding, $buttonSize, $buttonColor );
		_leftBtn			 = new DefaultScrollBtn( $buttonPadding, $buttonSize, $buttonColor );
		_leftBtn.scaleX 	 = -1;
	}
	
	
	/** 
	*	Build the scroller
	*	@param		A Scroll Bar, if none is defined, one will be built
	*	@param		A Scroll Track, if none is defined, one will be built
	*	@param		Right scroll btn
	*	@param		Left scroll btn
	*/
	public function build( $scrollBar:BaseScrollBar=null, $scrollTrack:BaseScrollTrack=null, $rightBtn:BaseScrollBtn=null, $leftBtn:BaseScrollBtn=null ) : void 
	{	
		// If no classes were passed, and useDefaultScroller() has not been called
		if ( ($scrollBar == null || $scrollTrack == null) && !_useDefaultScroller ) {
			styleDefaultScroller();
		}
		// If these are custom classes..
		 else if ( !_useDefaultScroller ) {
			_track		= $scrollTrack;
			_scrollBar 	= $scrollBar;
			_leftBtn	= $leftBtn;
			_rightBtn	= $rightBtn;
		} 

		_make();
		_changeOrientation( _orientaion );
		_resetScrollSpeed();
		changeWidth( _trackWidth );
	}
	
	// ______________________________________________________________ API
	
	/** 
	*	This changes the bar-width to track-width ratio
	*	
	*	@param		The percentage (0 - 1) of the target that is visible in the window 
	*	@param		tween speed
	*/
	public function updateScrollWindow ( $percentVisible:Number, $speed:Number=1 ):void
	{
		_percentOfContentVisible = $percentVisible;
		_scrollWidth = _trackWidth - (_trackWidth * _percentOfContentVisible);
		Tweener.addTween( this, { barWidth:_trackWidth * _percentOfContentVisible, time:$speed, transition:"EaseInOutQuint", onUpdate:_barTweenUpdate } );
		changeScrollPosition( _currentPercent, $speed );
		
	}
	
	/** 
	*	Change the width
	*	@param		new width
	*	@param		tween speed
	*/
	public function changeWidth ( $newWidth:Number, $speed:Number=1 ):void
	{
		updateScrollWindow(_percentOfContentVisible);
		_trackWidth	= $newWidth;
		Tweener.addTween( this, { trackWidth:$newWidth, time:$speed, transition:"EaseInOutQuint", onUpdate:_trackTweenUpdate } );
	}
	
	/** 
	*	Change the height
	*	@param		new height
	*	@param		tween speed
	*/
	public function changeHeight ( $newHeight:Number, $speed:Number=0.4 ):void
	{
		_barHeight = $newHeight;
		Tweener.addTween( this, { barHeight:_barHeight, time:$speed, transition:"EaseInOutQuint", onUpdate:_heightTweenUpdate} );
	}
	
	/** 
	*	Manually changes the scrollbar's position (0 - 1)
	*	
	*	@param		The scrollbar's percentage (0 - 1), 0 is at left (or top), 1 is at right, (or bottom)
	*	@param		tween speed
	*/
	public function changeScrollPosition ( $percent:Number, $speed:Number=1 ):void
	{
		_currentPercent = $percent;
		Tweener.addTween( _scrollBar, { x:_scrollWidth * $percent,time:$speed, transition:"EaseInOutQuint"} );
	}
	
	// ______________________________________________________________ Make
	
	private function _make (  ):void
	{
		this.addChild( _track );
		this.addChild( _scrollBar );
		this.addChild( _rightBtn );
		this.addChild( _leftBtn  );
		_positionButtons();
		
		_scrollBar.addEventListener( MouseEvent.MOUSE_DOWN, _startScroll );

		_rightBtn.incrament = 1;
		_leftBtn.incrament = -1;
		_rightBtn.addEventListener( BaseScrollBtn.INCRAMENT, _handleButtonClick );
		_leftBtn.addEventListener ( BaseScrollBtn.INCRAMENT, _handleButtonClick );
		_leftBtn.addEventListener ( MouseEvent.CLICK, _resetScrollSpeed );
		_rightBtn.addEventListener( MouseEvent.CLICK, _resetScrollSpeed );
		
		_rightBtn.draw();
		_leftBtn.draw();
		
		_drawTrack();
		updateScrollWindow(0);
	}   
	
	private function _changeOrientation( $orientation:String )
	{
		if( $orientation == HORIZONTAL ){
		}else{
			this.rotation = 90;
		}
	}
	
	
	// Called on tween update, see:  updateScrollWindow()
	private function _barTweenUpdate (  ):void
	{
		_drawBar();
	}
	
	private function _trackTweenUpdate (  ):void
	{
		_drawTrack();
		_drawBar();
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
		_dragArea = new Rectangle(0, 0, _scrollWidth, 0);
		_scrollBar.drawBar( barWidth, barHeight  );
	}
	
	public function _drawTrack ():void
	{
		_track.drawTrack( trackWidth, barHeight );
	}
		
	private function _positionButtons (  ):void
	{
		_rightBtn.x	= trackWidth + _rightBtn.buttonPadding;
		_leftBtn.x	= -_leftBtn.buttonPadding;
		_rightBtn.y = _leftBtn.y = barHeight / 2;
	}
	
	// ______________________________________________________________ Scrolling Event Handlers
	
	private function _startScroll ( e:Event ):void
	{
		Tweener.removeTweens( _scrollBar, "x" );
		_isDragging = true;
		_scrollBar.startDrag( false, _dragArea );
		_scrollBar.stage.addEventListener( MouseEvent.MOUSE_MOVE, _sendScrollEvent );
		_scrollBar.stage.addEventListener( MouseEvent.MOUSE_UP, _stopScrolling );
	}
	
	private function _stopScrolling ( e:Event ):void
	{
		if( _isDragging ) 
		{
			_isDragging = false;
			_scrollBar.stopDrag();
			_scrollBar.stage.removeEventListener( MouseEvent.MOUSE_MOVE, _sendScrollEvent );1
			_scrollBar.stage.removeEventListener( MouseEvent.MOUSE_UP, _stopScrolling );
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
		scrollEvent.percent = _currentPercent = _scrollBar.x / _scrollWidth;
		this.dispatchEvent( scrollEvent );
		// Update this var for use by scrolling buttons
		_barTarget = _scrollBar.x;
	}
	
	
	// ______________________________________________________________ Arrow Button click
	
	private function _handleButtonClick ( e:Event ):void
	{
		var x:Number = _scrollBar.x + e.currentTarget.incrament * _scrollIncrament;
        
		if( x > _scrollWidth ) 
			x = _scrollWidth;
		else if( x < 0)
			x = 0;
		
		if( x != _scrollBar.x ){ 	
			_scrollBar.x = x;
			_sendScrollEvent();
		}
	}
	
	private function _resetScrollSpeed ( e:Event = null ):void
	{
		_scrollSpeed = _scrollIncrament;
	}
}

}
