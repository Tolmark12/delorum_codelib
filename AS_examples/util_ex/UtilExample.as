package 
{

import flash.display.Sprite;
import delorum.utils.Inspector;

public class UtilExample extends Sprite
{
	public var someVar:Boolean;
	
	public function UtilExample():void
	{
		var obj:Obj = new Obj();
		var it:Object = Inspector.toObject( this, true );
		for( var i:String in it )
		{
			trace( i + '  :  ' + it[i]  + '  :  ' + typeof it[i] );
		}
		trace( "-----------------------------------------------" );
		
		trace( Inspector.toString(this, true) );
		
		trace( "-----------------------------------------------" );
		
		trace( Inspector.toArray(this, true) );
	}

}

}