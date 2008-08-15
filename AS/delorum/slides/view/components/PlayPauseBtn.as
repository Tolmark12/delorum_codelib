package delorum.slides.view.components
{

import flash.display.Sprite;
import flash.events.*;

public class PlayPauseBtn extends BaseBtn
{
	public static const PAUSE:String 	= "pause";
	public static const PLAY:String 	= "play";
	
	private var _currentState:String;
	private var _playShape:ArrowBtn;
	private var _pauseShape:Sprite;
	
	public function PlayPauseBtn():void
	{
		super();
		this.buttonMode = true;
		_drawShapes();
		this.addEventListener( MouseEvent.CLICK, _click );
	}
	
	private function _drawShapes (  ):void
	{
		var tall:Number = ThumbnailBtn.WIDTH;
		_playShape  = new ArrowBtn();
		_playShape.buttonMode = false;
		_pauseShape = new Sprite();
		
		// Draw Pause Button
		_pauseShape.graphics.beginFill( ThumbnailBtn.BG_COLOR );
		_pauseShape.graphics.drawRect( 0, 0, tall/3, tall );
		_pauseShape.graphics.drawRect( tall/3 + tall/4, 0, tall/3, tall );
		
		// Draw hit area
		this.graphics.beginFill( 0xFF0000, 0 );
		this.graphics.drawRect( -tall/2, -tall/2, tall*2, tall*2);
				
		super._bgShape.addChild(_playShape);
		super._bgShape.addChild(_pauseShape);
	}
	
	// ______________________________________________________________  API
	
	public function changeState ( $state:String = PAUSE ):void
	{
		switch ( $state ) {
			case PAUSE:
				_playShape.visible = false;
				_pauseShape.visible = true;
			break
			case PLAY:
				_playShape.visible = true;
				_pauseShape.visible = false;
			break;
		}
		
		_currentState = $state;
	}
	
	// ______________________________________________________________ Event Handler
	
	public function _click ( e:Event ):void
	{
		switch( _currentState )
		{
			case PAUSE:
				this.dispatchEvent( new Event( PAUSE ) );
			break
			case PLAY:
				this.dispatchEvent( new Event( PLAY )  );
			break
		}
	}

}

}