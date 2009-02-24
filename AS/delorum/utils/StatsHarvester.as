package delorum.utils
{
	
import flash.utils.getTimer;
import flash.display.*;
import flash.events.*;
import flash.system.System;


public class StatsHarvester extends EventDispatcher
{
	public static const STATS:String = "statx";
	public var statsObject:Object;
	private var _fps :int;
	private var _timer:int;
	private var _ms:int;
	private var _msPrev:int = 0;
	private var _mem:Number;
	private var _frameRate:Number;
	
	public function StatsHarvester( $stage:Stage ):void
	{
		$stage.addEventListener( Event.ENTER_FRAME, _onEnterFrame );
		_frameRate = $stage.frameRate;
	}
	
	private function _onEnterFrame ( e:Event ):void
	{
		statsObject = { fr:_frameRate };
		
		_timer = getTimer();
		_fps++;
		
		if( _timer - 1000 > _msPrev )
		{
			_msPrev = _timer;
			_mem = Number( ( System.totalMemory * 0.000000954 ).toFixed(3) );
			statsObject.fps = _fps;
			statsObject.mem = _mem;
			statsObject.ms = _timer - _ms;
			this.dispatchEvent(new Event( STATS ));
			
			_fps = 0;
		}
		_ms = _timer;
	}
}

}