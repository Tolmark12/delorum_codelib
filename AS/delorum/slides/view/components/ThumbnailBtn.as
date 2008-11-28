package delorum.slides.view.components
{

import delorum.slides.Slide_VO;
import flash.display.Sprite;
import flash.events.*;

public class ThumbnailBtn extends BaseBtn
{
	public static var BG_COLOR:uint 		= 0x000000;
	public static var HIGHLIGHT_COLOR:uint 	= 0x666666;
	public static var WIDTH:Number 			= 12;
	
	private var _slideVo:Slide_VO;
	private var _dot:Sprite;
	
	public function ThumbnailBtn( $slideVo:Slide_VO ):void
	{
		super();
		_slideVo = $slideVo;
		this.buttonMode = true;
	}
	
	// ______________________________________________________________ Make
	
	public function build (  ):void
	{
		super._bgShape.graphics.beginFill( BG_COLOR );
		super._bgShape.graphics.drawRect(0,0,WIDTH,WIDTH);
		
		_dot = new Sprite();
		_dot.x = _dot.y = WIDTH / 4;
		_dot.graphics.beginFill( HIGHLIGHT_COLOR );
		_dot.graphics.drawRect(0,0,WIDTH/2,WIDTH/2);
		this.addChild( _dot );
	}
	
	public function highlight (  ):void
	{
		this.dispatchEvent( new Event( MouseEvent.MOUSE_OUT ) );
		_dot.alpha = 1;
		super._doRollOvers = false;
	}
	
	public function unHighlight (  ):void
	{
		_dot.alpha = 0;
		super._doRollOvers = true;
	}
	
	// ______________________________________________________________ Getters / Setters
	
	public function get slideIndex (  ):uint { return _slideVo.index; };
}

}