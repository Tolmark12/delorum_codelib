package delorum.images
{

public class EffectList
{	
	/**	A list of effects to run */
	public var effects:Array = new Array();
	/**	A list of parameters. Indexes corrospond to <code>effects</code> array */
	public var effectParams:Array = new Array();
	
	public function EffectList():void
	{
		
	}
	
	/** 
	*	Add an effect to the effect list
	*	@param		The effect to call
	*	@param		Params
	*/
	public function addEffect ( $method:String, $params:Array ):void
	{
		effects.push($method);
		effectParams.push($params);
	}
	
	/** 
	*	Return the next effect in the list
	*	@return		An effect object: { method:"METHOD_TO_CALL", params:["the", "params"] }
	*/
	public function getNextEffect (  ):Object
	{
		return { method:effects.shift(), params:effectParams.shift() };
	}
	
	/** 
	*	Add all the effects at once in an array
	*	@param		An array of effects. ex: new Array( { method:"METHOD_TO_CALL", params:["the", "params"] }, { etc... } );
	*/
	public function addEffectsViaArray ( $effects:Array ):void
	{
		var len:uint = $effects.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			addEffect(Pixasso[ $effects[i].method ], $effects[i].params );
		}
	}
	
	/** 
	*	Returns true if there are any remaining effects to process
	*/
	public function get isEffectsLeft (  ):Boolean{ return ( effects.length > 0)? true : false; };
}

}