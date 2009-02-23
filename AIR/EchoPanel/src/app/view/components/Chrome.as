package app.view.components
{

import flash.events.*;
import flash.display.Sprite;
import app.view.components.ui.*;
import delorum.echo.EchoMachine;
import app.model.vo.WindowInfoVO;

public class Chrome extends Sprite
{
	// Display
	private var _bg:Background;
	private var _dragBar:DragBar_swc;
	private var _resizer:Resizer_swc;
	private var _tabHolder:Sprite = new Sprite();
	
	// List of tabs
	private var _tabs:Array = new Array();
	// Active tab
	private var _activeTab:Tab;
	
	// Active tab id, accessed by Chrome Mediator
	public var activeTabId:String = "";
	
	public function Chrome():void
	{
		
	}
	
	// ______________________________________________________________ Make
	
	/** 
	*	Create / Add display elements
	*	@param		width
	*	@param		height
	*/
	public function make ( $w:Number, $h:Number ):void
	{
		_bg = new Background();
		this.addChild(_bg);
		
		// Top draggable bar
		_dragBar = new DragBar_swc();
		this.addChild( _dragBar );
		
		// Tab bar
		_tabHolder.visible = false;
		_tabHolder.y = _dragBar.height - 2;
		_tabHolder.addEventListener( Tab.TAB_CLICK, _onTabClick, false,0,true );
		
		this.addChild( _tabHolder );
		
		// Lower right resizinb triangle
		_resizer = new Resizer_swc();
		_resizer.yOffset = dragBarHeight;
		_resizer.moveTo($w, $h);
		this.addChild( _resizer );
		_resizer.init();
	}
	
	// ______________________________________________________________ Tabs 
	
	/** 
	*	Activates a tab
	*	@param		ID of the tab to activate
	*/
	public function activateTab ( $id:String ):void
	{
		if( _activeTab != null ) {
			_activeTab.loseFocus();
		}
		_activeTab = _getTabById( $id );
		_activeTab.gainFocus();
		activeTabId = $id;
	}
	
	/** 
	*	Deaactivates the specified tab
	*	@param		Id of the tab to deactivate
	*/
	public function killTab ( $id:String ):void
	{
		// If killing the active tab...
		if( activeTabId == $id ){
			//...activate the tab to the left of it
			var ind:int = _getTabIndex($id);
			var len:int = _tabs.length;
			// if there is more than one tab, activate 
			// the tab to the right or left of it
			if( len > 1){
				var newTab:Tab;
				if( ind > 0 ) {
					newTab = _tabs[ind-1] as Tab;
				} else {
					newTab = _tabs[ind+1] as Tab;
				}
				newTab.fireActivation();
			} 
			// else, there are no tabs...
			else 
			{
				
			}
		} 
		
		var dyingTab:Tab = _getTabById($id);
		dyingTab.visible = false;
		_removeTabFromList($id);
		_stackTabs();
	}
	
	/** 
	*	Add a new output window
	*	@param		The title of the window
	*	@param		this window id
	*/
	public function addTab ( $id:String, $text:String ):void
	{
		var tab = new Tab($text, $id);
		tab.make();
//		tab.addEventListener( MouseEvent.CLICK, _onTabClick, false,0,true );
		_tabHolder.addChild(tab);
		_tabs.push(tab);
		_stackTabs();
	}
	
	/** 
	*	Set the info that the tab needs
	*	@param		Information object
	*/
	public function setTabInfo ( $vo:WindowInfoVO ):void
	{
		var tab:Tab = _getTabById($vo.id);
		tab.setInfo( $vo )
	}
	
	/** 
	*	@private 	Stacks the tabs horizontally
	*/
	private function _stackTabs (  ):void
	{
		var xPos:Number = 2;
		var tab:Tab;
		var len:uint = _tabs.length;
		for ( var i:uint=0; i<len; i++ ) {
			tab = _tabs[i] as Tab;
			tab.x = xPos;
			xPos += tab.tabWidth + 4;
		}
		
		_tabHolder.visible = ( _tabs.length <= 1 )? false : true ;
		_bg.y = ( _tabHolder.visible )? 35 : 19 ;
	}
	
	/** 
	*	@return		Gets the tab by this id
	*	@param		Id of the tab to return
	*/
	private function _getTabById ( $id:String ):Tab
	{
		var len:uint = _tabs.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var tab:Tab = _tabs[i];
			if( tab.id == $id ) 
				return tab;
		}
		return null;
	}
	
	/** 
	*	@return		The index in the tab array of the specified tab
	*	@param		The id of the tab
	*/
	private function _getTabIndex ( $id:String ):int
	{
		var len:uint = _tabs.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var tab:Tab = _tabs[i];
			if( tab.id == $id ) 
				return i;
		}
		return -1;
	}
	
	/** 
	*	Removes a tab from the display list
	*	@param		The id of the tab to remove
	*/
	private function _removeTabFromList ( $id:String ):void
	{
		var len:uint = _tabs.length;
		looper:for ( var i:uint=0; i<len; i++ ) 
		{
			var tab:Tab = _tabs[i];
			if( tab.id == $id ) {
				_tabs.splice(i,1);
				break looper;
			}
		}
	}
	
	// ______________________________________________________________ Display
	
	/** 
	*	Hide the content
	*/
	public function minimize ():void {
		_bg.visible = _resizer.visible = false;
	}
	
	/** 
	*	Show the content
	*/
	public function maximize ():void {
		_bg.visible = _resizer.visible = true;
	}
	
	/** 
	*	Resize 
	*/
	public function resize ( $width:Number, $height:Number ):void {
		// background
		_bg.draw($width, $height);
		
		// Resize the dragbar
		_dragBar.resize( $width );
		
		_tabHolder.graphics.clear();
		_tabHolder.graphics.beginFill(0X131313);
		_tabHolder.graphics.drawRect(1,0,$width-2,20)
		
		// Resize the native window
		this.stage.nativeWindow.width  = $width + 100;
		this.stage.nativeWindow.height = $height + 100;
	}
	
	/** 
	*	clear
	*/
	public function clear (  ):void{
		
	}
	
	// ______________________________________________________________ Event Listeners
	
	/** 
	*	Catch the event as it bubbles up, and set the active Tab id
	*/
	private function _onTabClick ( e:Event ):void
	{
		activeTabId = (e.target as Tab).id;
	}
	
	// ______________________________________________________________ Getters Setters
	
	/**	The Application Width */
	public function get appWidth  (  ):Number{ return _resizer.appWidth; };
	/**	The application Height */
	public function get appHeight (  ):Number{ return _resizer.appHeight; };
	/**	The height of the dragbar */
	public function get dragBarHeight (  ):Number{ return _dragBar.height - 5; };
	public function get barHeight (  ):Number{  return( _tabHolder.visible )? 39 : dragBarHeight; };
	
}

}