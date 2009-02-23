package delorum.utils
{
import flash.utils.*;


/**
* 	A class for inspecting a strongly typed object's public vars
* 	
* 	@example Sample usage:
* 	<listing version=3.0>
* 		import delorum.utils.Inspector;
*		var vars:String = Inspector.toString( someObject);
* 	</listing>
* 	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson - 2009-02-23
* 	@rights	  Copyright (c) Delorum 2009. All rights reserved	
*/


public class Inspector extends Object
{
	
	private var target:Object;
	private var keys:Array;
	private var index:int;
	private static var descriptions:Object;
	
	public function Inspector(obj:*, keys:Array){
		this.target = obj;
		this.keys = keys;
		index = 0;
	}
	
	// ______________________________________________________________ API
	
	/** 
	*	Returns an object listing all public vars in the specified object
	*	@param		The object to introspect
	*	@param		Whether to list the inherited properties
	*	@return		An object of name value pair ex: {a:1, b:"23", c:true}
	*/
	public static function toObject ( $obj:*, $inherited:Boolean=false ):Object
	{
		var inspector:Inspector = create($obj,$inherited);
		var key:Object;
		var returnObj:Object = new Object;
		
		while( key = inspector.next() )
		{
			returnObj[key] = $obj[key]
		}
		
		return returnObj;
	}
	
	/** 
	*	Returns an object listing all public vars in the specified object
	*	@param		The object to introspect
	*	@param		Whether to list the inherited properties
	*	@return		A String of namve value pairs
	*/
	public static function toString ( $obj:*, $inherited:Boolean=false ):String
	{
		var inspector:Inspector = create($obj,$inherited);
		var key:Object;
		var str:String = "";
		
		while( key = inspector.next() )
		{
			str+=key  + '  :  ' + $obj[key] + "\n";
		}
		
		return str;
	}
	
	/** 
	*	Returns an Array listing all public vars in the specified object
	*	@param		The object to introspect
	*	@param		Whether to list the inherited properties
	*	@return 	An array of name value pairs ex: [ [a",1], ["b","23"], ["c",true] ]
	*/
	public static function toArray ( $obj:*, $inherited:Boolean=false ):Array
	{
		var inspector:Inspector = create($obj,$inherited);
		var key:Object;
		var ar:Array = new Array();
		
		while( key = inspector.next() )
		{
			ar.push( new Array(key, $obj[key]) );
		}
		
		return ar;
	}
	
	
	
	// ______________________________________________________________ Helpers
	/**
	 * Returns the next key, or false if we are done.
	 */
	public function next():Object
	{
		var key:String = keys[index];
		index++;
		if(key == null){
			return false;
		}
		return key;
	}
	
	/**
	 * Creates an array of keys for a class object if they do not exist.
	 * Keys are hashed and reused later.
	 */
	private static function create($obj:*, $inherited:Boolean=false):Inspector
	{
		if(!descriptions){
			descriptions = {};
		}
		
		var name:String = getQualifiedClassName($obj);
		var id:String;
		var description:XML = describeType($obj);
		var keys:Array = new Array();
		var varsList:XMLList;
		var somethingCreated:Boolean = false;
		
		// we are grabbing the inherited vars...
		if( $inherited ) {
			id = name + "_full";
			if(! descriptions[id] )	{
				somethingCreated = true;		
				var profile:XML = describeType($obj);				// Get list of all data
				varsList = description..variable;					// All public vars
				var parentsVarsList:XMLList = profile..accessor;	// All inherited public vars
				
				for each(var node_a:XML in varsList){				// Add public vars to array
					keys.push(node_a.@name);
				}
				for each(var node_b:XML in parentsVarsList){		// Add inherited vars to array
					if( node_b.@access != "writeonly" ) 
						keys.push(node_b.@name);
				}
			}
		}
		// we are only grabbing the class vars...
		else { 
			id = name;
			if(! descriptions[name]){	
				somethingCreated = true;							
				varsList = description..variable;
				for each(var node_c:XML in varsList ){
					keys.push(node_c.@name);
				}
			}
		}
		
		// alphabetize and create
		if( somethingCreated ) {
			keys.sort(); 
			descriptions[id] = keys;
		}
		
		//ok, we have a description, lets create our enumerator.
		return new Inspector($obj, descriptions[id]);
	}
}

}
