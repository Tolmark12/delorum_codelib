package delorum.images.helpers
{
	
import flash.display.*;

public class Aligner
{
	/**	@private "+" or "-" ie:add or subtract*/
	private var _modifyer:String;
	/**	@private How it should be aligned. top, bottom, right, etc */
	private var _alignString:String;
	/**	@private The extra distance (if any) that should be added after aligning */
	private var _extra:uint;
	/**	@private The return value */
	private var _pos:Number;
	
	/** 
	*	Find the x position based on a string
	*	
	*	@param		Can be string or number. valid examples: 24, "left+100", "center-24"
	*	@param		The Bitmap data we are aligning to
	*	@param		The display object we are adding
	*/
	public function getX ( $position:*, $bitmap:BitmapData, $newSprite:* ):Number
	{
		if( typeof $position == "number" ){
			return $position;
		} 
		else
		{
			_setVars($position)
			switch ( _alignString ){
				case "right":
					_pos = $bitmap.width;
				break
				case "left" :
					_pos = -$newSprite.width;
				break;
				case "middle" :
				case "center" :
					_pos = $bitmap.width/2 - $newSprite.width/2;
				break;
				case "right_edge" :
					_pos = $bitmap.width - $newSprite.width;
				break;
				case "left_edge" :
					_pos = 0;
				break;
			}
			_addExtra();
			return _pos;
		}
	}
	
	/** 
	*	Find the x position based on a string
	*	
	*	@param		Can be string or number. valid examples: 24, "top+100", "center-24"
	*	@param		The Bitmap data we are aligning to
	*	@param		The display object we are adding
	*/
	public function getY ( $position:*, $bitmap:BitmapData, $newSprite:* ):Number
	{
		if( typeof $position == "number" ){
			return $position;
		}
		else
		{
			_setVars($position)
			switch ( _alignString ){
				case "top":
					_pos = -$newSprite.height;
				break
				case "bottom" :
					_pos = $bitmap.height;
				break;
				case "middle":
				case "center":
					_pos = $bitmap.height/2 - $newSprite.height/2
				break;
				case "top_edge" :
					_pos = 0;
				break;
				case "bottom_edge" :
					_pos = $bitmap.height - $newSprite.height;
				break;
			}
			_addExtra();
			return _pos;
		}
	}
	
	// ______________________________________________________________ Helpers
	
	/** 
	*	@private	Set the _alignString var, and the _extra var
	*	@param		The position. Examples:  x="left+20", y="top", x="center-25"
	*/
	private function _setVars ( $position:String ):void
	{
		_modifyer = ( $position.indexOf("+") == -1 )? "-" : "+";
		var ar = $position.split(_modifyer);
		_alignString = ar[0];
		_extra = uint(ar[1]);
	}
	
	/** 
	*	@private	
	*	Add any extra space to the position. Forinstancex="center+20" 
	*	would add 20 pixels after centering the image.
	*/
	private function _addExtra (  ):void
	{
		if( _modifyer == "+" ) 
			_pos += _extra;
		else
			_pos -= _extra;
	}
}

}