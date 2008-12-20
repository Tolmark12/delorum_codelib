package ui
{

import flash.events.*;
import flash.display.Sprite;
import ui.*;
import net.hires.debug.Stats;
import flash.net.LocalConnection;
import delorum.echo.EchoMachine;

public class StageManager extends Sprite
{
	public static const ORIG_WIDTH:Number = 700;
	public static const ORIG_HEIGHT:Number = 200;
	
	private var _bg:Background;
	private var _dragBar:DragBar_swc;
	private var _resizer:Resizer_swc;
	private var _content:Content;
	private var _mask:Sprite;
	private var _stats:Statistics;
	
	public function StageManager():void
	{
	}
	
	// ______________________________________________________________ Make
	
	public function initialize (  ):void
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
		_dragBar.addEventListener( DragBar.RESET, clear );
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
		
		// Stats
		_stats = new Statistics();
		_stats.addEventListener( Statistics.RUN_GC, _onRunGarbageColl, false,0,true );
		//_stats.y = _dragBar.height + 1;
		contentHolder.addChild(_stats);
		//_stats.mask = _mask;
		
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

		_initForCommunication();
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
		_mask.graphics.drawRect(0,0,_resizer.appWidth + 21, _resizer.appHeight - _mask.parent.y);
		
		_stats.x = _resizer.appWidth - _stats.width;
		
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
		_stats.visible = vis;
		_resizer.visible = vis;
	}
	
	// ______________________________________________________________ AIR communication
	
	private var _conn:LocalConnection;
	
	private function _initForCommunication (  ):void
	{
		// This is the connection that other swfs will connect to
		_conn = new LocalConnection();
		_conn.client = this;
		_conn.allowDomain('*');
		try {
		    _conn.connect("_delorum_air_connect");
		} catch (error:ArgumentError) {
		    _content.addText("Can't connect...the connection name is already being used by another SWF");
		}
	}
	
	public function init ( $str:String ):void
	{
		_content.addText($str);

	}
	
	public function echo ( $str:String ):void
	{
		_content.addText( $str);
	}
	
	private function _onRunGarbageColl ( e:Event ):void
	{
		
	}
	
	/** 
	*	@param		Stats object: 
	*					fps : frames per second
	*					fr  : frame rate
	*					mem : memory
	*					ms  : miliseconds to render the frame
	*/
	public function stats ( $statsObj:Object ):void
	{
		EchoMachine.echo( "bump" );
		_stats.update( $statsObj.fps, $statsObj.mem, $statsObj.fr, $statsObj.ms )
	}
	
	public function clear ( e:Event=null ):void
	{
		_content.clear();
		_stats.clear();
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
		EchoMachine.echo( "222" );
	}
	
}

}