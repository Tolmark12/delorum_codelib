package app.view.components.ui
{

import flash.display.*;
import flash.events.*;
import flash.geom.Point;
import delorum.echo.EchoMachine;

public class DragBar extends MovieClip
{
	public static const SHOW_CONTENT:String = "show_content";
	public static const HIDE_CONTENT:String = "hide_content";
	public static const RESET:String = "clear";
	
	private var _bgBar:MovieClip;
	private var _minimizeBtn:MovieClip;
	private var _closeBtn:MovieClip;
	private var _clearBtn:MovieClip;
	private var _isOpen:Boolean = true;
	private var _clickPoint:Point;
	
	public function DragBar():void
	{
		_bgBar = this.getChildByName( "bgBar" ) as MovieClip;
		_closeBtn = this.getChildByName("closeBtn") as MovieClip;
		_closeBtn.addEventListener( MouseEvent.MOUSE_DOWN, _onClose );
		_closeBtn.buttonMode = true;
		
		_minimizeBtn = this.getChildByName("minimizeBtn") as MovieClip;
		_minimizeBtn.addEventListener( MouseEvent.MOUSE_DOWN, _onMinimize );
		_minimizeBtn.buttonMode = true;

		_clearBtn = this.getChildByName("clearBtn") as MovieClip;
		//_clearBtn.addEventListener( MouseEvent.MOUSE_DOWN, _onClear );
		_clearBtn.buttonMode = true;
		
		_bgBar.x = 1;
		_bgBar.y = 1;

		_bgBar.doubleClickEnabled = true;
		_bgBar.mouseEnabled = true;
		_bgBar.addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDown );
		_bgBar.addEventListener( MouseEvent.MOUSE_UP, _onMouseUp );
		//_bgBar.addEventListener( MouseEvent.DOUBLE_CLICK, _onDoubleClick);
		
		// ############## TEMP
		// _clearBtn.addEventListener( MouseEvent.MOUSE_DOWN, _clearEnterFrame, false,0,true );
		// _clearBtn.addEventListener( Event.ENTER_FRAME, _tempEcho, false,0,true );
		// ############## TEMP
	}
	
	// ############## TEMP
	private function _clearEnterFrame ( e:Event ):void
	{
		_clearBtn.removeEventListener( Event.ENTER_FRAME, _tempEcho );
	}

	private function _tempEcho ( e:Event ):void
	{
		EchoMachine.echo( "This is simply a long message to make flash render." );
	}
	// ############## TEMP
	
	// ______________________________________________________________ API
	
	public function resize ( $width:Number ):void
	{
		_bgBar.width = $width - 2;
		_minimizeBtn.x = $width - 30;
		_clearBtn.x = $width - 50;
		_closeBtn.x = $width - 10;
	}
	
	// ______________________________________________________________ Event Handlers
	
	private function _onMouseDown ( e:Event ):void
	{
		this.stage.nativeWindow.startMove();
		_clickPoint = new Point( this.stage.nativeWindow.x, this.stage.nativeWindow.y );
		this.addEventListener( Event.ENTER_FRAME, _onEnterFrame, false,0,true  );
	}
	
	private function _onEnterFrame ( e:Event ):void
	{
		if( this.stage.nativeWindow.x != _clickPoint.x || this.stage.nativeWindow.y != _clickPoint.y ) {
			this.parent.alpha = 0.99;
			this.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
		}
	}
	
	private function _onMinimize ( e:Event ):void
	{
		
	}
	
	private function _onMouseUp ( e:Event ):void
	{
		if( this.parent.alpha == 1 ) {
			if( _isOpen ) 
				this.dispatchEvent( new Event(HIDE_CONTENT, true) );
			else
				this.dispatchEvent( new Event(SHOW_CONTENT, true) );
				
			_isOpen = (_isOpen)? false : true ;
		}
			
		this.parent.alpha = 1;
		this.removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
	}
	
	private function _onClose ( e:Event ):void
	{
		this.stage.nativeWindow.close();
	}
	
	private function _onClear ( e:Event ):void
	{
		this.dispatchEvent( new Event(RESET, true) );
	}
	
	private function _onDoubleClick ( e:Event ):void
	{
		if( _isOpen ) 
			this.dispatchEvent( new Event(HIDE_CONTENT, true) );
		else
			this.dispatchEvent( new Event(SHOW_CONTENT, true) );
			
		_isOpen = (_isOpen)? false : true ;
	}

}

}