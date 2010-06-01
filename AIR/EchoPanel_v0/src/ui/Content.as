package ui
{

import flash.display.Sprite;
import flash.text.*;
import flash.geom.ColorTransform;
import delorum.scrolling.*;
import flash.events.*;
import delorum.utils.echo;

public class Content extends Sprite
{
	private var _displayText:TextField;
	private var _count:Number = 1;
	private var _appHeight:Number = 100;
	private var _totalString:String = "";
	private var _scroller:Scroller;
	private var _isScrolling:Boolean = false;
	
	public function Content():void
	{
		// TEMP - Replace this
		var format:TextFormat = new TextFormat();
        format.font = "Monaco";
        format.color = 0xAAAA44;
        format.size = 9;

		_displayText = new TextField();
		//_displayText.defaultTextFormat = format;
	
		_displayText.autoSize = "left";
		_displayText.wordWrap = true;
		_displayText.antiAliasType = "advanced";
		_displayText.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 225, 0);
		this.addChild(_displayText);
		
		_addScrollBar();
	}

	public function clear (  ):void
	{
		_count = 1;
		_displayText.text = "";
		_totalString = "";
	}
	
	public function addText ( $str:String ):void
	{
		var nm:String   = String(_count++);
		var space:String = "";
		var len:uint = nm.length;
		for ( var i:uint=len; i<4; i++ ) 
		{
			space += " ";
		}
		
		_totalString += "<n>" + nm + "</n>" + space + $str + "\n";
		_displayText.htmlText = "<body>" + _totalString + "</body>";
		var style:StyleSheet = new StyleSheet();
        
		var num:Object = new Object();
		num.color = "#333333";
		num.display = "inline";
		var body:Object = new Object();
		body.fontFamily = "Monaco";
		body.color		= "#AAAA44";
		body.fontSize	= 9;
		style.setStyle("n", num);
		style.setStyle("body", body);
		_displayText.styleSheet = style;
		setPosition();
	}
	
	private function _addScrollBar (  ):void
	{
		// Create scrollbar
		_scroller = new Scroller( _appHeight, 13, "vertical" );
		_scroller.y = 2;
		// If this is not called, Scroller will build a default scroller
		_scroller.createDefaultScroller( 0x333333, 0x000000, 0x000000, 1 );
		
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
			_displayText.y = 0 - ( (_displayText.height - _appHeight) * e.percent );
		else
			setPosition();
	}
	
	public function resize ( $width:Number, $height:Number ):void
	{
		_scroller.x = $width + 10;
		_appHeight = $height;
		_displayText.width = $width
		_scroller.changeWidth($height - 40, 0);
		setPosition();
	}
	
	public function setPosition (  ):void
	{
		_scroller.updateScrollWindow(_appHeight / _displayText.height);

		if( !_isScrolling )
		{
			if( _displayText.height > _appHeight - this.parent.y ) {
				_displayText.y = _appHeight - _displayText.height - this.parent.y;
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