package delorum.scrolling
{

import flash.events.Event;

public class ScrollEvent extends Event
{
	
	public var percent:Number;
	public var easeMotion:Boolean;
	
	/** 
	*	Constructor
	*	
	*	@param		A number between 0 and 1.
	*/
	public function ScrollEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ):void
	{
		super(type, bubbles, cancelable );
	}

}

}