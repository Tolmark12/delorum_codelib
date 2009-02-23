/*

The MIT License

Copyright (c) Delorum 2008 - www.delorum.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


*/

package delorum.loading
{
import flash.events.*;
import flash.net.*;


/**
* 	Basic loader for xml
* 	
* 	@example Sample usage:
* 	<listing version=3.0>
*	import delorum.loading.ImageLoader 
*	
*	var ldr:ImageLoader = new DataLoader( "path/to/file.xml" );
*	ldr.addEventListener( Event.COMPLETE, _handleDataLoaded );
*	ldr.loadItem();                                                       	
* 	</listing>
* 	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2007-11-27.
* 	@rights	  Copyright (c) Delorum 2008 - www.delorum.com	
*/


public class DataLoader extends BaseLoader implements LoaderIF
{
	private var _dataRequest:URLRequest;
	private var _dataLoader:URLLoader
	
	private var _loadedCallBack:Function;
	
	/** 
	*	Begin loading an xml file
	*	@param		Path to the xml file
	*	@param		Called when xml file load is complete
	*/
	public function DataLoader( $xmlPath:String )
	{
		super();
		_dataRequest = new URLRequest( $xmlPath );
		_dataLoader  = new URLLoader( );
	}
	
	override public function loadItem (  ):void
	{
		_dataLoader.load( _dataRequest );
	}
	
	override protected function isStillActive():Boolean
	{
		return true;
	}
	
	override public function cancelLoad (  ):void
	{
		super.removeItemFromLoadQueue();
		try {
			_dataLoader.close();
		} catch (e:Error) {
			
		}
		
	}
	
	
	// ______________________________________________________________ Event dispatcher
	override protected function get _eventListener (  ):EventDispatcher
	{
		return _dataLoader;
	}
}

}