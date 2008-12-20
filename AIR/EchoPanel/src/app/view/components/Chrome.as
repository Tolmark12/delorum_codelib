package app.view.components
{

import flash.events.*;
import flash.display.Sprite;
import app.view.components.ui.*;

public class Chrome extends Sprite
{
	// Display
	private var _dragBar:DragBar_swc;
	private var _resizer:Resizer_swc;
	
	
	public function Chrome():void
	{
		
	}
	
	// ______________________________________________________________ API
	
	/** 
	*	Create / Add display elements
	*	@param		width
	*	@param		height
	*/
	public function make ( $w:Number, $h:Number ):void
	{
		// Top draggable bar
		_dragBar = new DragBar_swc();
		this.addChild( _dragBar );
		
		// Lower right resizinb triangle
		_resizer = new Resizer_swc();
		_resizer.yOffset = dragBarHeight;
		_resizer.moveTo($w, $h);
		this.addChild( _resizer );
		_resizer.init();
	}
	
	/** 
	*	Activates a tab
	*	@param		ID of the tab to activate
	*/
	public function activateTab ( $id:String ):void
	{
		
	}
	
	/** 
	*	Add a new output window
	*	@param		The title of the window
	*	@param		this window id
	*/
	public function addTab ( $id:String, $text:String ):void
	{
		
	}
	
	/** 
	*	Hide the content
	*/
	public function minimize ():void {
		_resizer.visible = false;
	}
	
	/** 
	*	Show the content
	*/
	public function maximize ():void {
		_resizer.visible = true;
	}
	
	/** 
	*	Resize 
	*/
	public function resize ( $width:Number, $height:Number ):void {
		// Resize the dragbar
		_dragBar.resize( $width );
		
		// Resize the native window
		this.stage.nativeWindow.width  = $width + 100;
		this.stage.nativeWindow.height = $height + 100;
	}
	
	/** 
	*	clear
	*/
	public function clear (  ):void{
		
	}
	
	
	// ______________________________________________________________ Getters Setters
	
	/**	The Application Width */
	public function get appWidth  (  ):Number{ return _resizer.appWidth; };
	/**	The application Height */
	public function get appHeight (  ):Number{ return _resizer.appHeight; };
	/**	The height of the dragbar */
	public function get dragBarHeight (  ):Number{ return _dragBar.height - 5; };
	
}

}