package delorum.slides.view.components
{

import flash.display.Sprite;
import gs.TweenLite;
import flash.events.*;

public class BaseBtn extends Sprite
{
	protected var _bgShape:Sprite;
	protected var _doRollOvers:Boolean = true;
	public var mouseOverColor:uint 	= 0x666666;
	public var mouseOutColor:uint	= 0x000000;	
	
	public function BaseBtn():void
	{
		_bgShape = new Sprite();
		this.addChild( _bgShape );
		this.addEventListener( MouseEvent.MOUSE_OVER, _mouseOver );
		this.addEventListener( MouseEvent.MOUSE_OUT,  _mouseOut  );
	}
	
	// ______________________________________________________________ Event Handlers
	
	private function _mouseOver ( e:Event ):void{
		if( _doRollOvers ) 
			_shiftToOutColor();
	}
	
	private function _mouseOut ( e:Event ):void{
		if( _doRollOvers )
			_shiftToOverColor();
	}
	
	// ______________________________________________________________ Color Shifting
	private function _shiftToOverColor (  ):void{
		TweenLite.to(_bgShape,0.1,{tint:mouseOutColor});
	}
	
	private function _shiftToOutColor (  ):void
	{
		TweenLite.to(_bgShape,0.4,{tint:mouseOverColor});
	}
}

}