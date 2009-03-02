package app.view.components.ui
{

import flash.display.Sprite;
import delorum.scrolling.*;
import flash.events.*;
import delorum.utils.echo;

public class Scroll extends Sprite
{
	// Constants
	public static const BOTTOM_PADDING:Number = 65;
	
	// Events
	public static const SCROLL_CHANGE:String = "scroll_change";
	
	// How tall the app is
	private var _appHeight:Number;
	private var _scroller:Scroller;
	public var scrollPercent:Number = 1;
	
	public function Scroll():void
	{
		
	}
	
	// ______________________________________________________________ Scrolling

	public function resize ( $width:Number, $height:Number ):void
	{
		_appHeight = $height;
		
		// Add Scrollbar if not here
		if( _scroller == null )
			_addScrollBar( $height - BOTTOM_PADDING );
		
		// Resize / position scrollbar
		_scroller.x = $width - 12;
		_scroller.changeWidth($height - BOTTOM_PADDING, 0);
	}
	
	
	private function _addScrollBar ( $height:Number ):void
	{
		// Create scrollbar
		_scroller = new Scroller( $height, 14, "vertical" );
		_scroller.keepButtonsTogether = true;
		_scroller.y = 12;
		// If this is not called, Scroller will build a default scroller
		_scroller.createDefaultScroller( 0x333333, 0x000000, 0x222222, 2, 10, 7, 0x555555 );
										
		// build Scroller
		_scroller.build();

		// set event handlers
		_scroller.addEventListener( Scroller.SCROLL_START, _onScrollStart );
		_scroller.addEventListener( Scroller.SCROLL_END, _onScrollEnd );
		_scroller.addEventListener( Scroller.SCROLL, _onScroll );
		this.addChild(_scroller)

		// sets the size of the scroll tab
		_scroller.changeScrollPosition(scrollPercent,0);
		_scroller.updateScrollWindow( 0.5, 0.1 );

	}

	// ______________________________________________________________ Scroll Events

	/** 
	*	@private Called when scrolling
	*/
	private function _onScroll ( e:ScrollEvent ):void {
		scrollPercent = e.percent;
		dispatchEvent( new Event(SCROLL_CHANGE, true) );
	}

	/** 
	*	@private Called when scrollbar is pressed
	*/
	private function _onScrollStart ( e:Event ):void{
//		_isScrolling = true;
	}

	/** 
	*	@private Called when scrollbar is released
	*/
	private function _onScrollEnd ( e:Event ):void{
//		_isScrolling = (_scroller.scrollPosition > 0.9 )? false : true ;
	}
	

}

}