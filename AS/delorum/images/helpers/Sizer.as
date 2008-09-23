package delorum.images.helpers
{
	
import flash.display.DisplayObject;

public class Sizer
{
	
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
	
	private function _percent ( $numberString:String ):Number
	{
		// Lazy method for Chomping off the percent ;-)
		var ar:Array = $numberString.split("%");
		return Number( ar[0] ) / 100;
	}
}

}