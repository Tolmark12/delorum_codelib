package app.view.components.ui
{

import flash.display.Sprite;
import flash.text.*;
import flash.geom.ColorTransform;
import delorum.scrolling.*;
import flash.events.*;
import delorum.echo.EchoMachine;
import delorum.text.QuickText;
import delorum.echo.EchoMachine;
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

	public function clear (  ):void
	{
		_count = 1;
		_quickText.text = "";
		_totalString = "";
	}
	
	
	private var _tempAr:Array = new Array();
	public function addText ( $str:String ):void
	{
		var nm:String   = String(_count++);
		var space:String = "";
		var len:uint = nm.length;
		for ( var i:uint=len; i<4; i++ ) 
		{
			space += " ";
		}
		
		//	_bigString += "<p><n>" + nm + "</n>" + space + $str + "\n</p>";
		var newObj:MessageVO = new MessageVO( "<p><n>" + nm + "</n>" + space + $str + "\n</p>", 24 );
		_tempAr.push(newObj)
		
		if( _totalString.length < 2000 ) 
			_totalString += "<p><n>" + nm + "</n>" + space + $str + "\n</p>";
		else
			_totalString = "reset";
		
		// Prevent the display from refreshing too many times
		// a second and slowing down the app
		var _timer:Number = getTimer();
		if( _timer - 1000 > _prevTimer )
		{
			_prevTimer = _timer;
			var refreshTimer:Timer = new Timer( 1000,1 );
			refreshTimer.addEventListener( TimerEvent.TIMER, _onRefreshTimer, false,0,true );
			_refreshText();
		} 
		
		var style:StyleSheet = new StyleSheet();
		setPosition();
	}
	
	private function _onRefreshTimer ( e:Event ):void
	{
		_refreshText();
	}
	
	// Refresh the display
	private function _refreshText (  ):void
	{
		_quickText.htmlText = _totalString;
	}
	
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
		_scroller.addEventListener( Scroller.SCROLL, _onScroll );
		this.addChild(_scroller)
		
		// sets the size of the scroll tab
		_scroller.updateScrollWindow( 0.5 );
	}
	
	private function _onScroll ( e:ScrollEvent ):void
	{
		_isScrolling = ( e.percent < 0.95 )? true : false ;
		if( _isScrolling ) 
			_quickText.y = 0 - ( (_quickText.height - _appHeight) * e.percent );
		else
			setPosition();
	}
	
	public function resize ( $width:Number, $height:Number ):void
	{
		_scroller.x = $width -12;
		_appHeight = $height;
		_quickText.textWidth = $width - 20
		_scroller.changeWidth($height - 40, 0);
		setPosition();
	}
	
	public function setPosition (  ):void
	{
		_scroller.updateScrollWindow(_appHeight / _quickText.height);

		if( !_isScrolling )
		{
			if( _quickText.height > _appHeight - this.parent.y ) {
				_quickText.y = _appHeight - _quickText.height - this.parent.y;
				_scroller.changeScrollPosition(1);
				_scroller.visible = true;
			}
			else{
				this.y = 0;
				_scroller.visible = false;
			}
		}
	}
}

}