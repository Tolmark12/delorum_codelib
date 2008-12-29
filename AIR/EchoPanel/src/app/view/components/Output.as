package app.view.components
{

import app.view.components.ui.*;
import flash.events.*;
import flash.display.Sprite;
import app.view.components.ui.*;
import delorum.echo.EchoMachine;


public class Output extends Sprite
{
	public var windowId:String;
	
	// Content
	private var _bg:Background;
	private var _content:DisplayText;
	private var _mask:Sprite;
	private var _stats:Statistics;
	
	
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
		// Background color
		_bg = new Background();
		this.addChild( _bg );
		
		// Text
		_content = new DisplayText();
		this.addChild( _content );
		
		// Text Mask
		_mask = new Sprite();
		this.addChild( _mask );
		_content.mask = _mask;
		
		// Stats
		_stats = new Statistics();
		//_stats.addEventListener( Statistics.RUN_GC, _onRunGarbageColl, false,0,true );
		_content.addChild(_stats);
		
		// Kick the formating in
		_content.addText("");
		_content.clear();
	}
	
	/** 
	*	Print a message to the output window
	*	@param		Message
	*/
	public function addTextToStack ( $text:String ):void
	{
		_content.addText( $text );
	}
	
	/** 
	*	Resize
	*	@param		Width
	*	@param		Height
	*/
	public function resize ( $width:Number, $height:Number ):void
	{
		// background
		_bg.draw($width, $height);
		
		//  mask
		_mask.graphics.clear();
		_mask.graphics.beginFill(0xFF0000, 0.2);
		_mask.graphics.drawRect(0,0,$width, $height);
		
		// Stats
		_stats.x = $width - _stats.width;
		
		_content.resize($width, $height);
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
	public function echo ( $text:String ):void { addTextToStack($text); }

}

}