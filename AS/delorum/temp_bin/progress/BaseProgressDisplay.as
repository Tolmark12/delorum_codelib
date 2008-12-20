package delorum.loading.progress
{

import flash.display.*;
import caurina.transitions.Tweener;
import flash.events.*;

public class BaseProgressDisplay extends MovieClip
{
	protected var _holderMc:Sprite;
	protected var _bytesLoaded:Number;
	protected var _bytesTotal:Number;
	protected var _percentLoaded:Number;
	
	public function BaseProgressDisplay():void
	{
	}
	
	public function build( $x:Number = 0, $y:Number = 0 ):void
	{
		this.alpha = 0;
		show();
	}

	// Let the loader display know progress has occured
	protected function _updateProgress ( e:ProgressEvent ):void
	{
		_bytesTotal    = e.bytesTotal;
		_bytesLoaded   = e.bytesLoaded;
		_percentLoaded = _bytesLoaded / _bytesTotal;
	}
	
	// Called on load complete
	protected function _loadComplete ( e:Event ):void
	{
		hideAndDestroy();
	}
	
	// Show the component
	public function show (  ):void
	{
		Tweener.addTween( this, { alpha:1, time:1, transition:"EaseInOutQuint"} );
	}
	
	// Hide the component
	public function hide ( $callback:Function = null ):void
	{
		Tweener.addTween( this, { alpha:0, time:1, transition:"EaseInOutQuint", onComplete:$callback } );
	}
	
	
	//	Hide and then delets all the pieces. Be sure to remove all 
	//	references to this component to qualify for garbage collection.
	public function hideAndDestroy (  ):void
	{
		hide( _destroy );
	}
	
	private function _destroy (  ):void
	{
		this.parent.removeChild( this );
	}
	
	// ______________________________________________________________ Getters Setters
	
	public function get updateHandler 	(  ):Function{ return _updateProgress; };
	public function get completeHandler (  ):Function{ return _loadComplete;   };
}

}