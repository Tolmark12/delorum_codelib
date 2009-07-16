package app.view.components.ui.virtualization
{

import flash.display.Sprite;
import flash.events.*;
import app.model.vo.LogItemVO;
import delorum.utils.echo;

public class CellManager extends Sprite
{
	// Reference to the stack of display cells
	private var _cells:Array = new Array();
	
	/**	The percentage the scrollbar is at */
	public var scrollPercent:Number;
	
	public function CellManager():void
	{
	}
	
	// ______________________________________________________________ API
	
	/** 
	*	Add and remove display cells based on a width and height
	*	@param		Width
	*	@param		Height
	*/
	public function changeDimmensions ( $width:Number, $height:Number ):void
	{
		var displayCell:DisplayCell;
		var cellsNeeded:Number = Math.ceil( $height / DisplayCell.TOTAL_HEIGHT ) - 1;
		var len:Number = totalCells;
		
		// We'r too short, Add the additional cells needed to fill the height
		if( cellsNeeded > totalCells ) 
		{
			for ( var i:uint=len; i<cellsNeeded; i++ ) 
			{
				displayCell = new DisplayCell();
				displayCell.y = DisplayCell.TOTAL_HEIGHT * i;
				displayCell.changeText("");
				_cells.push(displayCell);
				this.addChild(displayCell);
			}
			
		// we're too long, remove the extraneous cells
		} else {	
			for ( var j:uint=cellsNeeded; j<len; j++ ) 
			{
				displayCell = _cells.pop();
				displayCell.deconstruct();
				this.removeChild( displayCell );
			}
		}
	}
	
	public function changeData ( $ar:Array ):void
	{
		var len:uint = $ar.length;
		for ( var i:uint=0; i<len; i++ ) {
			var vo:LogItemVO = $ar[i];
			_cells[i].changeText( vo.echoTxt );
		}
	}
	
	// ______________________________________________________________ Getters / Setters
	
	public function get totalCells (  ):Number {  
		return _cells.length; 
	};
}

}