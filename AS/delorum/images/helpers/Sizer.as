package delorum.images.helpers
{
	
import flash.display.DisplayObject;

public class Sizer
{
	
	public function getWidth ( $width:*, $target:DisplayObject ):Number
	{
		if( typeof $width == "number" ){
			return $width;
		} 
		else
		{
			return $target.width * _percent( $width );
		}
	}
	
	public function getHeight ( $height:*, $target:DisplayObject ):Number
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
		// Chomp off the percent ;-)
		var ar:Array = $numberString.split("%");
		return Number( ar[0] ) / 100;
	}
}

}