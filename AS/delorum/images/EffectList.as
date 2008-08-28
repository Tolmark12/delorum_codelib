package delorum.images
{

public class EffectList
{	
	public var effects:Array = new Array();
	public var effectParams:Array = new Array();
	
	public function EffectList():void
	{
		
	}
	
	public function addEffect ( $method:String, $params:Array ):void
	{
		effects.push($method);
		effectParams.push($params);
	}
	
	public function getNextEffect (  ):Object
	{
		return { method:effects.shift(), params:effectParams.shift() };
		trace( effects.length + '  :  ' + params.length );
	}
	
	public function addEffectsViaArray ( $effects:Array ):void
	{
		var len:uint = $effects.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			trace( Pixasso[ $effects[i].method ] );
			addEffect(Pixasso[ $effects[i].method ], $effects[i].params );
		}
	}
	
	public function get isEffectsLeft (  ):Boolean{ return ( effects.length > 0)? true : false; };
}

}