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

public class BaseLoader extends EventDispatcher
{
	// Static vars
	private static var _currentlyLoading:Boolean;
	private static var _loadCount:uint = 100000;
	private static var _loadQueue:Object = new Object();
	
	// Local vars
	private var _queueNumber:uint;
	
	public function BaseLoader():void
	{}
	
	protected function get _eventListener (  ):EventDispatcher
	{
		trace( "The '_eventListner' getter function should be overridden in the sub class!!");
		return null;
	}
	
	// ______________________________________________________________ Loading 
	/** 
	*	Adds an item to the end of the load queue. 
	*	@return 	Returns an identification for use in <code>loadItemNow</code>
	*/
	public function addItemToLoadQueue (  ):String
	{
		_queueNumber = _loadCount;
		_loadQueue[ _queueNumber ] = this;
		_loadCount++;
		loadNextItem();
		return String( _queueNumber );
	}
	
	/** 
	*	no matter where this item is in the load queue, it is loaded immediately
	*/
	public function budgeAndLoad ( ):void
	{
		loadItemNow( this.toString() );
	}
	
	/** 
	*	no matter where this item is in the load queue, it is loaded immediately
	*	@param		The id string returned from <code>addItemToLoadQueue()</code>
	*/
	public static function loadItemNow ( $id:String ):void
	{
		
		var newLoader:BaseLoader = _loadQueue[$id];
		if(newLoader != null)
		{
			delete _loadQueue[$id];
			newLoader.loadItem();
		}
	}
	
	/** Loads item immediately */
	public function loadItem (  ):void
	{
        trace( "The 'loadItem' function should be overridden in the sub class!!");
	}
	
	// ______________________________________________________________ 
	
	/** 
	*	Ensure the load target still exists. 
	*/
	protected function isStillActive (  ):Boolean
	{
		trace( "The 'isStillActive' function should be overridden in the sub class!!");
		return true;
	}
	
	
	// ______________________________________________________________ Static functions, the meat of the loading done here. 
	
	/** 
	* 	@private 	Moving through the load queue
 	*/
	private function loadNextItem ():void
	{
		if( !_currentlyLoading && !_loadQueueIsEmpty() )
		{
			var nextLoad:BaseLoader = _getNextLoad();
			
			// Double check that holder mc hasn't been removed or deleted
			if( nextLoad.isStillActive() )
			{
				_currentlyLoading = true;
				nextLoad.loadItem();
				nextLoad.onComplete = _loadComplete;
				nextLoad.onError	= _loadComplete;
			}else{
				loadNextItem();
			}
		}
	}
	
	
	/** 
	*	@private 	Get the next item in the load queue
	*/
	private function _getNextLoad (  ):BaseLoader
	{
		var ar:Array = new Array();
		for( var i:String in  _loadQueue){
			var nextLoader:BaseLoader = _loadQueue[i] as BaseLoader;
			ar.push( _loadQueue[i] );
		}
		ar.sort();
		var ldr:BaseLoader = ar.shift() as BaseLoader;
		delete _loadQueue[ldr];
		return ldr;
	}
	
	/** 
	*	@private	check if there are more items to load
	*/
	private function _loadQueueIsEmpty (  ):Boolean
	{
		// If there are no more loads, return false...
		for( var i:String in _loadQueue ){
			return false;
		}
		//...else return true
		return true;
	}
	
	/** 
	*	@private   Check if there are still items needing to be loaded, and load them. 
	*/
	private function _loadComplete ( e:Event ):void
	{
		_currentlyLoading = false;
		loadNextItem();
		if( _loadQueue[ _queueNumber ] != null ) 
			delete _loadQueue[ _queueNumber ];
	}
	
	// ______________________________________________________________ Backwards compatible event listening
	/** Set callback function to be triggered on Load Complete */
	public function set onComplete	($f:Function):void { _eventListener.addEventListener( Event.COMPLETE, $f);  };
	
	/** Set callback function to be triggered on Load Error */
	public function set onError		($f:Function):void { _eventListener.addEventListener( IOErrorEvent.IO_ERROR, $f);  };
	
	/** Set callback function to be triggered on Load Progress */
	public function set onProgress	($f:Function):void { _eventListener.addEventListener( ProgressEvent.PROGRESS, $f); };
	
	/** Set callback function to be triggered on Load initialization */
	public function set onInit		($f:Function):void { _eventListener.addEventListener( Event.INIT, $f); };
	
	/** Set callback function to be triggered on Load initialization */
	public function set onOpen		($f:Function):void { _eventListener.addEventListener( Event.OPEN, $f); };
	
	public function get tester (  ):String{ return "yeah"; };
	
	override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
	{
		_eventListener.addEventListener( type, listener );
	}

	override public function toString():String 
	{
		return String( _queueNumber );
	}

}

}