package app.view.components.ui
{

import flash.display.Sprite;
import delorum.text.QuickText;
import app.model.vo.WindowInfoVO;
import delorum.utils.echo;
import flash.events.*;

public class Tab extends Sprite
{
	// Events
	public static const TAB_CLICK:String = "tab_click";
	public static const TAB_CLOSE:String = "tab_close";
	
	/**	Width of the tab */
	public var tabWidth:Number;
	/**	id */
	public var id:String;
	
	// Name of the tab
	private var _name:String = "Name coming...";
//	private var _titleTxt:QuickText;
	private var _text:Text_swc;
	// Background
	private var _bg:Sprite = new Sprite();
	
	/** 
	*	Create a new tab object
	*	@param		The name of the tab
	*	@param		The tab's id
	*/
	public function Tab( $name:String, $id:String ):void
	{
		_name = $name;
		id = $id;
	}
	
	/** 
	*	Create the tab
	*/
	public function make (  ):void
	{
		this.addChild( _bg );
//	   	_titleTxt = new QuickText();
//	   	_titleTxt.parseCss("p{ font-family:Monaco; color:#CFCFCF; font-size:10  }");
//		this.addChild( _titleTxt );
		_text = new Text_swc();
		this.addChild(_text);
		_drawTextAndBg();
		_bg.addEventListener( MouseEvent.CLICK, _onBgClick, false,0,true );
	}
	
	/** 
	*	Sets all the info, including the name
	*/
	public function setInfo ( $vo:WindowInfoVO ):void
	{
		_name = $vo.name
		_drawTextAndBg();
	}
	
	/** 
	*	As if the tab had been clicked
	*/
	public function fireActivation (  ):void {
		_onBgClick(null);
	}
	
	/** 
	*	Draws the tab and 
	*/
	private function _drawTextAndBg (  ):void
	{
		// Text
		var pad:Number = 15;
//		_titleTxt.htmlText = "<p>" + _name + "</p>";
//		_titleTxt.x = pad;
//		_titleTxt.mouseEnabled = false;
//		tabWidth = _titleTxt.textWidth + pad*2;
		_text.titleTxt.text = _name;
		_text.x = pad;
		_text.mouseEnabled = false;
		_text.mouseChildren = false;
		_text.titleTxt.selectable = false;
		tabWidth = _text.titleTxt.textWidth + pad*2;
		
		// Background
		_bg.graphics.clear();
		_bg.graphics.beginFill( 0x262626 );
		_bg.graphics.drawRect( 0,0,tabWidth,20  );
		
		// Close button
		var closeBtn:Xbutton_swc = new Xbutton_swc();
		this.addChild( closeBtn );
		closeBtn.addEventListener( MouseEvent.CLICK, _onCloseClick, false,0,true );
	}
	
	// ______________________________________________________________ Display
	
	/** 
	*	Visually unselected 
	*/
	public function loseFocus (  ):void
	{
		this.alpha = 0.4;
	}
	 /** 
	 *	Visually select
	 */
	public function gainFocus (  ):void
	{
		this.alpha = 1;
	}
	
	// ______________________________________________________________ Event Listeners
	
	private function _onBgClick ( e:Event ):void {
		this.dispatchEvent( new Event(TAB_CLICK, true) );
	}
	
	private function _onCloseClick ( e:Event ):void {
		this.dispatchEvent( new Event(TAB_CLOSE, true) );
	}

}

}