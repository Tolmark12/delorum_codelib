package delorum.utils
{

public class Sequence
{
	private var _currentItemIndex:uint;
	private var _totalItems:uint;
	private var _items:Array;
	
	public function Sequence( $items:Array ):void
	{
		_items 				= $items;
		_currentItemIndex 	= 0;
		_totalItems 		= _items.length;
	}
	
	// _____________________________ API
	
	/** 
	*	Incrament the item index
	*	@param		The incrament amount. This can be a positive OR a negative number.
	*/
	public function incramentItemIndex ( $incrament:int, $loopOnOverShoot:Boolean=false ):Boolean
	{
		var newIndex:int = _currentItemIndex + $incrament;
		
		// Make sure the new index falls within the range of items
		if( newIndex > _totalItems - 1 )		
			newIndex = ($loopOnOverShoot)? 0 : _totalItems - 1;	// if new index is greater than the last item, show last item.
		else if( newIndex < 0 )				
			newIndex = ($loopOnOverShoot)? _totalItems - 1 : 0;	// if the index is less than 0, show first item.
		
		// Make sure new item is different than old item
		if( _currentItemIndex != newIndex ){ 
			_currentItemIndex = newIndex;
			return true;
		}else
			return false;
	}
	
	/** 
	*	Change which item to display by passing the new item index
	*	@param		The index of the new item
	*/
	public function changeItemByIndex ( $newIndex:uint ):Boolean
	{
		var plusOrMinus:int 		= ($newIndex > _currentItemIndex)? 1 : -1;
		var incramentDifference:int	= Math.abs( _currentItemIndex - $newIndex ) * plusOrMinus;
		return incramentItemIndex( incramentDifference );
	}
	
	/** 
	*	Go to the next item
	*/
	public function next ( $loopOnOverShoot:Boolean=false ):Boolean{
		return incramentItemIndex( 1, $loopOnOverShoot );
	}
	
	/** 
	*	Go to the previous item
	*/
	public function prev ( $loopOnOverShoot:Boolean=false ):Boolean
	{
		return incramentItemIndex( -1, $loopOnOverShoot );
	}
	
	// _____________________________ Getters and setters
	
	public function get currentIndex 		(  ):uint{ return _currentItemIndex; 	};
	public function get totalItems			(  ):uint{ return _totalItems; 		};
	public function get currentItem 		(  ):*   { return _items[_currentItemIndex]; };

}
}