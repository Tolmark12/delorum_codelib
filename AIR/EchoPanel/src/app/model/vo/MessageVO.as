package app.model.vo
{

public class MessageVO
{
	public var msg:String;
	public var tall:Number;
	
	public function MessageVO ( $msg:String, $tall:Number ):void
	{
		msg = $msg;
		tall = $tall;
	}
}

}