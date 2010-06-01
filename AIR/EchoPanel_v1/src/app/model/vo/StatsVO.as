package app.model.vo
{

public class StatsVO
{
	// ID
	public var id:String;
	// Data
	public var fps:Number;
	public var frameRate:Number;
	public var memoryUsed:Number;
	public var ms:Number;		
	
	/** 
	*	@param		Stats object: 
	*					fps : frames per second
	*					fr  : frame rate
	*					mem : memory
	*					ms  : miliseconds to render the frame
	*/
	public function StatsVO( $statObj:Object ):void
	{
		fps        = $statObj.fps
		frameRate  = $statObj.fr;
		memoryUsed = $statObj.mem;
		ms         = $statObj.ms;
	}
}

}