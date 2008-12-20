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
		// background color
		_bg = new Background();
		this.addChild( _bg );
		
		// text
		_content = new DisplayText();
		this.addChild( _content );
		
		// Mask
		_mask = new Sprite();
		this.addChild( _mask );
		_content.mask = _mask;
		
		// Kick the formating in
		_content.addText("");
		_content.clear();
	}
	
	public function echo ( $text:String ):void
	{
		addTextToStack($text);
	}
	
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
		_bg.draw($width, $height);
		
		// Update mask
		_mask.graphics.clear();
		_mask.graphics.beginFill(0xFF0000, 0.2);
		_mask.graphics.drawRect(0,0,$width, $height);
		
		_content.resize($width, $height);
	}

}

}