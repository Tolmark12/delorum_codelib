package delorum.upload
{

import flash.events.*;
import flash.net.*;

public class SelectEvent extends Event
{
	public var fileReference:FileReference;
	
	public function SelectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
	{
		super(type, bubbles, cancelable);
	}

}

}