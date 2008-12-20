package delorum.scrolling
{

import flash.display.Sprite;

public class DefaultScrollTrack extends BaseScrollTrack implements iScrollTrack
{
	public var trackFill:uint;
	public var trackStroke:uint;
	public var barPadding:Number;
	
	public function DefaultScrollTrack( $fill:uint=0xCCCCCC, $stroke:uint=0x666666, $barPadding:Number=4 ):void
	{
		trackFill = $fill;
		trackStroke = $stroke;
		barPadding = $barPadding;
	}
	
	override public function drawTrack ( $trackWidth:Number, $barHeight:Number ):void
	{
	   this.graphics.clear();
	   this.graphics.beginFill( trackFill );
	   this.graphics.lineStyle( 0, trackStroke );
	   this.graphics.drawRoundRect(-barPadding, -barPadding, $trackWidth + barPadding * 1.8, $barHeight + barPadding * 1.8, $barHeight + barPadding, $barHeight + barPadding);
	}
}

}