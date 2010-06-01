package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;
import flash.display.*;
import delorum.utils.echo;

public class LogProxy extends Proxy implements IProxy
{
	public static const NAME:String = "log_proxy";
	
	private var _logs:Object = new Object();
	
	public function LogProxy( ):void
	{
		super( NAME );
	}
	
	
	
	private var _tempLineNumber:Number = 0;
	// ______________________________________________________________ Message disbursion 
	/** 
	*	Adds a new item to the log stack
	*	@param		The id of the swf that sent the message
	*	@param		The message, can be string, number, object, etc...
	*/
	public function addMessageToStack ( $id:String, $item:* ):void
	{
		var vo:LogItemVO = new LogItemVO();
		vo.id = $id;

		if( $item is String ) {				// String
			vo.echoTxt   = $item;
			vo.echoColor = 0x0000FF;
		} else if( $item is Number ) {		// Number
			vo.echoTxt   = String($item);
			vo.echoColor = 0xFF0000;
		} else if( $item is DisplayObject ) {	// Display Object
			var mc:DisplayObject = $item;
			vo.echoTxt   = String( mc );
			vo.echoColor = 0x00FF00;
			vo.metaTxt   = "x:" + mc.x + ", y:" + mc.y + ", width:" + mc.width + 
							", height:" + mc.height + ", alpha:" + mc.alpha + ", vis:" + 
							mc.visible + ", added:" + ((mc.parent == null)? "no" : "yes" ); 
			vo.metaColor = 0xCCCCCC;
		}else{
			vo.echoTxt   = $item.toString();
			vo.echoColor = 0x00FF00;
		}
		
		// Add a line number
		vo.echoTxt = (_tempLineNumber++) + "  " +  vo.echoTxt;
		
		var log:LogVO = _getLog($id);
		log.logStack.push( vo );
		sendNotification( AppFacade.NEW_ITEM_IN_STACK, $id );
	}
	
	// ______________________________________________________________ Data retrieval
	
	/** 
	*	Dispatches a group of LogItemVO objects
	*	@param		id of the log to retrieve data from 
	*	@param		start index of slice
	*	@param		end index of slices
	*/
	public function dispatchStackSlice ( $id:String, $start:Number, $stackSize:Number ):void
	{
		var log:LogVO = _getLog($id);
		var end:Number = ( $start + $stackSize > log.logStack.length )? log.logStack.length : $start + $stackSize ;
		sendNotification( AppFacade.CELL_DATA_TO_ID, new CellDataUpdateVO($id, log.logStack.slice($start, end) ) );
	}
	
	public function dispatchCellData( $id:String, $percent:Number, $stackSize:Number ):void
	{
		var log:LogVO = _getLog($id);
		var window:Number = log.logStack.length - $stackSize;
		dispatchStackSlice($id, Math.round(window*$percent), $stackSize );
	}
	
	// ______________________________________________________________ Create / Destroy logs
	
	/** 
	*	Create a new LogVO
	*	@param		All the necessary values
	*/
	public function addNewLog ( $vo:OutputerVO ):void{
		_logs[ $vo.id ] = new LogVO();
	}
	
	/** 
	*	Delete a LogVO
	*	@param		id of the logvo to delete
	*/
	public function deleteLog ( $id:String ):void {
		delete _logs[ $id ];
	}
	
	// ______________________________________________________________ Helpers
	
	/** 
	*	Gets a LogVO vo by id 
	*/
	private function _getLog ( $id:String ):LogVO {
		return _logs[$id] as LogVO;
	}
	
}
}