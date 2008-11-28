package delorum.images.helpers
{
	
import flash.display.*;

public class Aligner
{
	private var _modifyer:String;
	private var _alignString:String;
	private var _extra:uint;
	private var _pos:Number;
	
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
	
	private function _setVars ( $position:String ):void
	{
		_modifyer = ( $position.indexOf("+") == -1 )? "-" : "+";
		var ar = $position.split(_modifyer);
		_alignString = ar[0];
		_extra = uint(ar[1]);
	}
	
	private function _addExtra (  ):void
	{
		if( _modifyer == "+" ) 
			_pos += _extra;
		else
			_pos -= _extra;
	}
}

}