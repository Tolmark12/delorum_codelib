package delorum.utils
{

import flash.display.Sprite;

public class NumFormatter extends Sprite
{
	public function NumFormatter():void{}
	
	public static function formatAsDollars ( $num:* ):String
	{
		// round it
		var returnStr:String = addCommas($num, true)
		
		//check if we need to serve extra zeros
		var ar:Array = returnStr.split(".");
		if(ar[1]==null){
			returnStr += ".00";
		}
		else if( ar[1].split("").length == 1 ){
		    returnStr += "0";
		}
		
		//return the $num
		return "$" + returnStr;
	}
	
	public static function addCommas ( $num:*, $roundDecimal:Boolean=false ):String
	{
		var returnStr:String
		
		// round it
		if( $roundDecimal )
			returnStr = ((Math.round($num*100))/100).toString();
		else
			returnStr = $num.toString();
			
		
		// add commas
		var count:Number = 0
		var ar:Array = returnStr.split(".");
		var len:uint = ar[0].length;
		var str:String = ""
		for ( var i:Number=len; i>-1; i-- ) 
		{
			str = ar[0].charAt(i) + str;
			if( count++%3 == 0 && i!=0 && i!=len){
				str = ","+str;
			}
		}
		
		var decimal = (ar[1] != null)?  "." + ar[1] : '' ;
		return str + decimal;
	}
}

}