package app.model.vo
{

import app.view.components.EchoItem;

public class EchoItemVo
{
	private var _instance:EchoItem;
	
	public function EchoItemVo(  ):void
	{
	}
	
	/** 
	*	I think this is where the vo should instantiate a new item, measure the height
	*	and return that height
	*/
	public function getHeight ( $width:uint ):uint
	{
		if( _instance == null ){
			var instance:E = new EchoItem();
			return _instance.changeWidth( $width );	
		}
		
	}
	
	/** 
	*	Returns the instance if it exists
	*/
	public function getInstance (  ):void
	{
		if( _instance == null ){
			_instance = new EchoItem();
		}
		
		return _instance;
	}
	
	/** 
	*	Destroy the instance if it exists
	*/
	public function destroyInstance (  ):void
	{
		if( _instance != null )
			_instance.destroy();
		_instance = null;
	}
	
	
	
}

}