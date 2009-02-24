package app.view.components.ui
{

import flash.display.Sprite;
import flash.text.*;
import flash.geom.ColorTransform;
import delorum.scrolling.*;
import flash.events.*;
import delorum.text.QuickText;
import delorum.utils.echo;
import flash.utils.*;
import app.model.vo.MessageVO;

public class DisplayText extends Sprite
{
	private var _displayText:TextField;
	private var _quickText:QuickText;
	private var _count:Number = 1;
	private var _appHeight:Number = 100;
	private var _totalString:String = "";
	private var _scroller:Scroller;
	private var _isScrolling:Boolean = false;
	private var _prevTimer:Number = 0;
	private var _bigString:String = "";
	
	public function DisplayText():void
	{
		_quickText = new QuickText();
		_quickText.parseCss("p{ font-family:Monaco; color:#AAAA44; font-size:10  },n{color:#333333; display:inline}");
		_quickText.htmlText = "hullo";
		_quickText.textWidth = 50;
		this.addChild(_quickText);
		_addScrollBar();
	}

	/** 
	*	Clear the text field
	*/
	public function clear (  ):void
	{
		_count = 1;
		_quickText.text = "";
		_totalString = "";
	}
	
	/** 
	*	Add a String to the text
	*	@param		Text to add
	*	
	*	Todo: Eventually, this will be done completely differently. I imagine
	*	some sort of scenario where we are only rendering the visible chunk of
	*	text. (that which is not masked). 
	*/
	public function addText ( $str:String ):void
	{
		var nm:String   = String(_count++);
		var space:String = "";
		var len:uint = nm.length;
		for ( var i:uint=len; i<4; i++ ) 
		{
			space += " ";
		}
		
		
		_bigString += "<p><n>" + nm + "</n>" + space + $str + "\n</p>";
		//var newObj:MessageVO = new MessageVO( "<p><n>" + nm + "</n>" + space + $str + "\n</p>", 24 );
		//_tempAr.push(newObj)
		
		//if( _totalString.length < 2000 ) 
		//	_totalString += "<p><n>" + nm + "</n>" + space + $str + "\n</p>";
		//else
			//_totalString = "reset";
		
//TODO Figure out an intelligent refresher. 

		// Prevent the display from refreshing too many times
		// a second and slowing down the app
//		var _timer:Number = getTimer();
//		if( _timer - 1000 > _prevTimer )
//		{
//			_prevTimer = _timer;
//			var refreshTimer:Timer = new Timer( 1000,1 );
//			refreshTimer.addEventListener( TimerEvent.TIMER, _onRefreshTimer, false,0,true );
//			_refreshText();
//		} 
//		
		_refreshText();
		
		var style:StyleSheet = new StyleSheet();
		setPosition();
	}
	
	/** 
	*	@private Called via timer. Updates the text display
	*/
	private function _onRefreshTimer ( e:Event ):void
	{
		_refreshText();
	}
	
	/** 
	*	@private Refresh the display
	*/
	private function _refreshText (  ):void
	{
		_quickText.htmlText = _bigString;
	}
	
	/** 
	*	@private Create the scrollbar
	*/
	private function _addScrollBar (  ):void
	{
		// Create scrollbar
		_scroller = new Scroller( _appHeight, 14, "vertical" );
		_scroller.y = 12;
		// If this is not called, Scroller will build a default scroller
		_scroller.createDefaultScroller( 0x333333, 0x000000, 0x222222, 2 );
		
		// build Scroller
		_scroller.build();
		
		// set event handlers
		_scroller.addEventListener( Scroller.SCROLL_START, _onScrollStart );
		_scroller.addEventListener( Scroller.SCROLL_END, _onScrollEnd );
		_scroller.addEventListener( Scroller.SCROLL, _onScroll );
		this.addChild(_scroller)
		
		// sets the size of the scroll tab
		_scroller.updateScrollWindow( 0.5 );
	}
	
	// ______________________________________________________________ Scroll Events
	
	/** 
	*	@private Called when scrolling
	*/
	private function _onScroll ( e:ScrollEvent ):void {
		_isScrolling = true;
		if( _isScrolling ) 
			_quickText.y = 0 - ( (_quickText.height - _appHeight) * e.percent );
		else
			setPosition();
	}
	
	/** 
	*	@private Called when scrollbar is pressed
	*/
	private function _onScrollStart ( e:Event ):void{
		_isScrolling = true;
	}
	
	/** 
	*	@private Called when scrollbar is released
	*/
	private function _onScrollEnd ( e:Event ):void{
		_isScrolling = (_scroller.scrollPosition > 0.9 )? false : true ;
	}
	
	// ______________________________________________________________ Size and Positiong
	
	/** 
	*	Resize the text field
	*	@param		Width
	*	@param		Height
	*/
	public function resize ( $width:Number, $height:Number ):void
	{
		_scroller.x = $width -12;
		_appHeight = $height;
		_quickText.textWidth = $width - 20
		_scroller.changeWidth($height - 40, 0);
		setPosition();
	}
	
	/** 
	*	- Determines if scrollbar should be visible
	*	- Sets the Scroll Window
	*	- Sets the scrollbar position
	*/
	public function setPosition (  ):void
	{
		// update the scrollbar's scroll window
		var perc:Number = (_quickText.textHeight != 0)? _appHeight / _quickText.textHeight : 0;
		_scroller.updateScrollWindow(perc, 0);
		
		// whether we should show the scrollbar or not
		var doNeedScrollBar:Boolean = _quickText.textHeight > (_appHeight - this.parent.y);
		
		// If the user is not dragging, or dragged the scrollbar somewhere
		if( !_isScrolling )
		{
			if( doNeedScrollBar ) {
				_quickText.y = _appHeight - _quickText.textHeight - this.parent.y;
				_scroller.changeScrollPosition(1);
			}
			else{
				this.y = 0;
			}
		}
		
		_scroller.visible = doNeedScrollBar;
	}
}

}