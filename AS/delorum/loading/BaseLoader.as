package delorum.loading
{

import flash.events.*;
import delorum.loading.progress.BaseProgressDisplay;

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
	
	// ______________________________________________________________ Loading Handles
	/** 
	*	Adds an item to the end of the load queue. 
	*	
	*	@return 	Returns an identification for use in <code>loadItemNow</code>
	*/
	public function addItemToLoadQueue (  ):String
	{
		//_loadQueue.push( this );
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
	*	
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
	* 	@private Moving through the load queue
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
	
	
	// Get the next item in the load queue
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
	
	// check if there are more items to load
	private function _loadQueueIsEmpty (  ):Boolean
	{
		// If there are no more loads, return false...
		for( var i:String in _loadQueue ){
			return false;
		}
		//...else return true
		return true;
	}
	
	
	// Event hanlder on load complete.
	private function _loadComplete ( e:Event ):void
	{
		_currentlyLoading = false;
		loadNextItem();
		if( _loadQueue[ _queueNumber ] != null ) 
			delete _loadQueue[ _queueNumber ];
	}
	
	// ______________________________________________________________ Associate with a progress indicator
	
	public function connectToProgressDisplay ( $progressDisplay:BaseProgressDisplay ):void
	{
		_eventListener.addEventListener( ProgressEvent.PROGRESS, $progressDisplay.updateHandler );
		_eventListener.addEventListener( Event.INIT, $progressDisplay.completeHandler );
	}
	
	// ______________________________________________________________ Set Event Handlers
	/** Set callback function to be triggered on Load Complete */
	public function set onComplete	($f:Function):void { _eventListener.addEventListener( Event.COMPLETE, $f);  };
	
	/** Set callback function to be triggered on Load Error */
	public function set onError		($f:Function):void { _eventListener.addEventListener( IOErrorEvent.IO_ERROR, $f);  };
	
	/** Set callback function to be triggered on Load Progress */
	public function set onProgress	($f:Function):void { _eventListener.addEventListener( ProgressEvent.PROGRESS, $f); };
	
	/** Set callback function to be triggered on Load initialization */
	public function set onInit		($f:Function):void { _eventListener.addEventListener( Event.INIT, $f); };
	
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