package app.view.components
{

import app.view.components.ui.*;
import flash.events.*;
import flash.display.Sprite;
import app.view.components.ui.*;
import delorum.utils.echo;
import app.view.components.ui.virtualization.CellManager;
import app.view.components.ui.virtualization.DisplayCell;

public class Output extends Sprite
{
	public static const CELL_DATA_REQUEST:String = "cell_data_request";
	public var windowId:String;
	
	// Content
	//private var _content:DisplayText;
	private var _content:CellManager;
	private var _mask:Sprite;
	private var _stats:Statistics;
	private var _scroll:Scroll;
	
	/** 
	*	@param		Unique id
	*/
	public function Output($id):void
	{
		windowId = $id;
	}
	
	// ______________________________________________________________ API
	
	/** 
	*	Make a new Output Window
	*/
	public function make ():void
	{
		// Text
		_content = new CellManager();
		this.addChild( _content );
		
		// Text Mask
		_mask = new Sprite();
		this.addChild( _mask );
		_content.mask = _mask;
		
		// Stats
		_stats = new Statistics();
		_stats.y = 15;
		//_stats.addEventListener( Statistics.RUN_GC, _onRunGarbageColl, false,0,true );
		_content.addChild(_stats);
		
		// Scroll
		_scroll = new Scroll();
		_scroll.addEventListener( Scroll.SCROLL_CHANGE, _onScrollChange, false,0,true );
		this.addChild(_scroll);
	}
	
	/** 
	*	
	*/
	public function changeData ( $ar:Array ):void
	{
		_testScrollerNeeded();
		_content.changeData($ar);
	}
	
	/** 
	*	Resize
	*	@param		Width
	*	@param		Height
	*/
	public function resize ( $width:Number, $height:Number ):void
	{
		//  mask
		_mask.graphics.clear();
		_mask.graphics.beginFill(0xFF0000, 0.2);
		_mask.graphics.drawRect(0,0,$width, $height);
		
		// Stats
		_stats.x = $width - _stats.width - 20;
		
		// Virtualizer
		_content.changeDimmensions($width, $height);
		
		// Scroller
		_scroll.resize($width, $height);
		
		_testScrollerNeeded();
	}
	
	/** 
	*	Update the swf statistics
	*	@param		Frames per seconds
	*	@param		Frame rate set in swf
	*	@param		Total memory used
	*	@param		How many miliseconds to render frame
	*/
	public function updateStats( $fps:Number, $frameRate:Number, $memoryUsed:Number, $ms:Number):void
	{
		_stats.update( $fps, $frameRate, $memoryUsed, $ms );
	}
	
	// ______________________________________________________________ Alias
	
	/** 
	*	Print a message to the output window
	*	@param		Message
	*/
	//public function print ( $text:String ):void { addTextToStack($text); }
	
	
	// ______________________________________________________________ Event Handlers
	private function _onScrollChange ( e:Event ):void {
		dispatchEvent( new Event(CELL_DATA_REQUEST, true) );
	}
	
	// ______________________________________________________________ Getters / Setters
	
	// Called when the scroll fires
	public function get percentOfStack (  ):Number 	{ return _scroll.scrollPercent; };
	public function get stackSize (  ):Number 		{ return _content.totalCells; };
	
	// ______________________________________________________________ Destruct
	
	public function destruct (  ):void
	{
		this.windowId = null;
		
		_scroll.removeEventListener( Scroll.SCROLL_CHANGE, _onScrollChange );
	   	
		// Destruct these
		//_content = new CellManager();
	   	//_mask = new Sprite();
	   	//_stats = new Statistics();
	   	//_scroll = new Scroll
		
		var len:uint = this.numChildren;
		for ( var i:uint=0; i<len; i++ ) 
		{
			this.removeChildAt( 0 );
		}
	}
	
	public function _testScrollerNeeded (  ):void
	{
		//if( _content.totalCells * DisplayCell.TOTAL_HEIGHT > this.height )
		//	_scroll.visible = true;
		//else
		//	_scroll.visible = false;
	}
}

}