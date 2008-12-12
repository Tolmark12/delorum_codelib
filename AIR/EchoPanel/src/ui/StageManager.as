package ui
{

import flash.events.*;
import flash.display.Sprite;
import ui.*;

public class StageManager extends Sprite
{
	public static const ORIG_WIDTH:Number = 700;
	public static const ORIG_HEIGHT:Number = 200;
	
	private var _bg:Background;
	private var _dragBar:DragBar_swc;
	private var _resizer:Resizer_swc;
	private var _content:Content;
	private var _mask:Sprite;
	
	public function StageManager():void
	{
	}
	
	// ______________________________________________________________ Make
	
	public function init (  ):void
	{
		// background color
		_bg = new Background();
		_bg.draw(ORIG_WIDTH, ORIG_HEIGHT)
		this.addChild( _bg );
		
		// Top draggable bar
		_dragBar = new DragBar_swc();
		_dragBar.resize(ORIG_WIDTH);
		_dragBar.addEventListener( DragBar.HIDE_CONTENT, _onContentToggle );
		_dragBar.addEventListener( DragBar.SHOW_CONTENT, _onContentToggle );
		this.addChild( _dragBar );
		
		// Content area
		var contentHolder:Sprite = new Sprite()
		contentHolder.y = _dragBar.height + 1;
		this.addChild(contentHolder);
		_content = new Content();
		contentHolder.addChild( _content );
		
		// Mask
		_mask = new Sprite();
		//_mask.y = _dragBar.height + 1;
		contentHolder.addChild( _mask );
		_content.mask = _mask;
		
		// Lower right resizinb triangle
		_resizer = new Resizer_swc();
		_resizer.addEventListener( Resizer.NEW_WINDOW_SIZE, _onResize );
		_resizer.moveTo(ORIG_WIDTH, ORIG_HEIGHT);
		this.addChild( _resizer );
		_resizer.init();
		
		
		
		this.stage.nativeWindow.alwaysInFront = true;
		_onResize(null)
		
		// Kick the formating in
		_content.addText("");
		_content.clear();
	}
	
	// ______________________________________________________________ Event Listeners
	
	private function _onResize ( e:Event ):void
	{
		// Resize the dragbar and the background
		_dragBar.resize( _resizer.appWidth );
		_bg.draw( _resizer.appWidth, _resizer.appHeight );
		
		// Resize mask + content
		_content.resize(_resizer.appWidth, _resizer.appHeight );
		_mask.graphics.clear();
		_mask.graphics.beginFill(0xFF0000, 0.2);
		_mask.graphics.drawRect(0,0,_resizer.appWidth, _resizer.appHeight - _mask.y);
		
		// Resize the native window
		this.stage.nativeWindow.width = _resizer.appWidth + 100;
		this.stage.nativeWindow.height = _resizer.appHeight + 100;
	}
	
	private function _onContentToggle ( e:Event ):void
	{
		var vis:Boolean = true
		if( e.type == DragBar.HIDE_CONTENT )
			vis = false;
		
		_bg.visible = vis;
		_content.visible = vis;
		_mask.visible = vis;
	}

}

}