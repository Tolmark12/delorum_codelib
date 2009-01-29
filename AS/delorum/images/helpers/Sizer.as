package delorum.images.helpers
{
	
import flash.display.DisplayObject;

public class Sizer
{
	/** 
	*	Get the width a target should be
	*	@param		Can be number or string. Ex: width=200, width="50%"
	*	@param		The thing to resize
	*/
	public function getWidth ( $width:*, $target:* ):Number
	{
		if( typeof $width == "number" ){
			return $width;
		} 
		else
		{
			return $target.width * _percent( $width );
		}
	}
	
	/** 
	*	Get the height a target should be
	*	@param		Can be number or string. Ex: height=200, height="50%"
	*	@param		The thing to resize
	*/
	public function getHeight ( $height:*, $target:* ):Number
	{
		if( typeof $height == "number" ){
			return $height;
		} 
		else
		{
			return $target.height * _percent( $height );
		}
	}
	
	/** 
	*	@private Lazy method for Chomping the percent off a string and returning a number
	*/
	private function _percent ( $numberString:String ):Number
	{
		var ar:Array = $numberString.split("%");
		return Number( ar[0] ) / 100;
	}
}

}