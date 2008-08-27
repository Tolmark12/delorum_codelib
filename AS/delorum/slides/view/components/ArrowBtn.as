package delorum.slides.view.components
{

import flash.display.Shape;

public class ArrowBtn extends BaseBtn
{
	public static const RIGHT:String = "right";
	public static const LEFT:String  = "left";
	
	public var direction:String;
	
	public function ArrowBtn($direction:String=RIGHT):void
	{
		super();
		buttonMode = true;
		direction = $direction;
		_draw();
	}
	
	public function _draw ():void
	{
		var tall:Number 	= ThumbnailBtn.WIDTH;
		var shape:Shape		= new Shape();
		// Draw arrow
		shape.graphics.beginFill( ThumbnailBtn.BG_COLOR );
		shape.graphics.moveTo( 0, 0 			);
		shape.graphics.lineTo( tall, tall/2 	);
		shape.graphics.lineTo( 0, tall 		);
		shape.graphics.lineTo( 0, 0			);
		
		// draw hit area
		shape.graphics.beginFill( 0xFF0000, 0 );
		shape.graphics.drawRect( -tall/5, -tall/5, tall*2, tall*1.5);
		
		// Point the right direction
		if( direction == LEFT ) {
			shape.x = tall;
			shape.scaleX = -1;
		}
		
		super._bgShape.addChild( shape );
	}
}

}