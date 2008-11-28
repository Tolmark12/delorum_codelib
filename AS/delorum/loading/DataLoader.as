package delorum.loading
{
import flash.events.*;
import flash.net.*;


/**
* 	Basic loader for xml
* 	
* 	@example Sample usage:
* 	<listing version=3.0>
* 		
*
*	
* 	</listing>
* 	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2007-11-27.
* 	@rights	  Copyright (c) Delorum inc. 2008. All rights reserved	
*/


public class DataLoader extends BaseLoader implements LoaderIF
{
	private var _dataRequest:URLRequest;
	private var _dataLoader:URLLoader
	
	private var _loadedCallBack:Function;
	
	/** 
	*	Begin loading an xml file
	*	
	*	@param		Path to the xml file
	*	@param		Called when xml file load is complete
	*/
	public function DataLoader( $xmlPath:String )
	{
		super();
		_dataRequest 	= new URLRequest( $xmlPath );
		_dataLoader 		= new URLLoader( );
	}
	
	override public function loadItem (  ):void
	{
		_dataLoader.load( _dataRequest );
	}
	
	override protected function isStillActive():Boolean
	{
		return true;
	}
	
	// ______________________________________________________________ Event dispatcher
	override protected function get _eventListener (  ):EventDispatcher
	{
		return _dataLoader;
	}
}

}