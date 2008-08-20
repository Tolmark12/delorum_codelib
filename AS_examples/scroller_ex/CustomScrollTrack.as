package 
{

import delorum.scrolling.*;

public class CustomScrollTrack extends BaseScrollTrack implements iScrollTrack
{
	public var barPadding:Number;
	
	public function CustomScrollTrack( $barPadding:Number ):void
	{
		barPadding = $barPadding;
	}
	
	override public function drawTrack ( $trackWidth:Number, $barHeight:Number ):void
	{
	   this.graphics.clear();
	   this.graphics.beginFill( 0x000000 );
	   this.graphics.lineStyle( 1, 0xFFFFFF );
	   this.graphics.drawRect(-barPadding, -barPadding, $trackWidth + barPadding * 1.8, $barHeight + barPadding * 1.8 );
	}

}

}