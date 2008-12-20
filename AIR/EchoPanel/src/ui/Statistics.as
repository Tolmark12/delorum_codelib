package ui
{

import flash.display.Sprite;
import net.hires.debug.Stats;
import flash.events.*;
import flash.net.LocalConnection;
import delorum.echo.EchoMachine;

public class Statistics extends Sprite
{
	// Events
	public static const RUN_GC:String = "run_gc"; // Run Garbage Collection
	
	private var _stats:Stats;
	private var _clearMemoryBtn:Xbutton_swc;
	
	public function Statistics():void
	{
		_stats =  new Stats();
		_clearMemoryBtn = new Xbutton_swc();
		_clearMemoryBtn.x = 80;
		_clearMemoryBtn.addEventListener( MouseEvent.CLICK, _onClearMemoryClick, false,0,true );
		_clearMemoryBtn.buttonMode = true;
		
		this.addChild( _clearMemoryBtn );
		this.addChild( _stats );
	}
	
	public function update( $fps:Number, $fr:Number, $mem:Number, $ms:Number ):void
	{
		_stats.update( $fps, $fr, $mem, $ms )
	}
	
	public function clear (  ):void
	{
		_stats.clear();
	}
	
	// ______________________________________________________________ Event Listeners
	private function _onClearMemoryClick ( e:Event ):void
	{
		this.dispatchEvent( new Event( RUN_GC ) );
	}
	
}

}