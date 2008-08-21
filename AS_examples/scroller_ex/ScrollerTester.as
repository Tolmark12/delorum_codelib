package 
{

import flash.display.Sprite;
import delorum.scrolling.*;
import flash.events.*;

public class ScrollerTester extends Sprite
{
	private var _scrolledObject:Sprite;
	private var _scroller:Scroller;
	
	private var _originalStageWidth:Number;
	
	public function ScrollerTester():void
	{
		_originalStageWidth = this.stage.stageWidth;
		_createScrollObjects();
		_createScrollBar();
		this.stage.addEventListener( Event.RESIZE, _handlerEventResize );
	}
	
	private function _createScrollBar (  ):void
	{
		// Create scrollbar
		_scroller = new Scroller( this.stage.stageWidth - 60,50 );
		_scroller.x = 30;
		_scroller.y = 100;
		
		// If this is not called, Scroller will build a default scroller
		_scroller.createDefaultScroller( 0xFFFFFF, 0xCCCCCC, 0x777777, 4 );
		
		// build Scroller
		_scroller.build();
		
		// set event handlers
		_scroller.addEventListener( Scroller.SCROLL, _handleScroll );
		this.addChild(_scroller)
		
		// sets the size of the scroll tab
		//_scroller.updateScrollWindow( this.stage.stageWidth / _scrolledObject.width );
	}
	
	// ______________________________________________________________ Event handlers
	
	private function _handlerEventResize ( e:Event ):void
	{
		_scroller.changeWidth( this.stage.stageWidth - 60 );
	}
	
	private function _handleScroll ( e:ScrollEvent ):void
	{
		_scrolledObject.x = 0 - ((_scrolledObject.width - this.stage.stageWidth) * e.percent);
	}


	
	
	
	// Nothing to to with scroller below here. Just creating some dummy content to be scrolled
	
	private function _createScrollObjects (  ):void
	{
		_scrolledObject = new Sprite();
		_scrolledObject.y = 50;
		this.addChild( _scrolledObject );
		var fillColor:uint = 0xFFAA33;
		
		for ( var i:uint=0; i<34; i++ ) 
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(fillColor+=6);
			sprite.graphics.drawRoundRect(0,0,40,40,13);
			sprite.x = 40*i + 2*i;
			_scrolledObject.addChild(sprite);
		}
		
	}

}

}