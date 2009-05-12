package delorum.utils 
{

import flash.utils.ByteArray;
import flash.net.*;
import flash.events.*;

public class SendBytes extends ByteArray {
	
	private static const BOUNDARY:String = '---------------------------7d76d1b56035e';
	
	public function SendBytes():void
	{
		this.writeMultiByte('--' + SendBytes.BOUNDARY + '\r\n', "ascii");
	}
	
	/** 
	*	Add a file to the POST in the form of a byte array
	*	@param		Name of the object holding the file
	*	@param		Name of the file
	*	@param		The file data
	*/
	public function addFile(var_name:String, file_name:String, file_data:ByteArray):void
	{
		var header:String = 'Content-Disposition: form-data; name="' + var_name + '"; filename="' + file_name + '"\r\n'
		 + 'Content-Type: application/octet-stream\r\n\r\n';
		
		this.writeMultiByte(header, "ascii");
		this.writeBytes(file_data);
		this.writeMultiByte('\r\n--' + SendBytes.BOUNDARY + '\r\n', "ascii");
	}
	
	/** 
	*	Add a variable to the Post vars
	*	@param		Name of the variable
	*	@param		Value of the variable
	*/
	public function addVar(var_name:String, var_string:String):void
	{
		var header:String =	'Content-Disposition: form-data; name="' + var_name + '"\r\n\r\n'
		 + var_string + '\r\n'
		 + '--'  +  SendBytes.BOUNDARY  +  '\r\n';
		
		this.writeMultiByte(header, "ascii");
	}
	
	/** 
	*	Get the url request 
	*	@param		The service ex: http://site.com/some/service.php
	*/
	public function urlRequest( $destination:String ) : URLRequest
	{
		var url_request:URLRequest = new URLRequest($destination);
		url_request.method = URLRequestMethod.POST;
		url_request.contentType = "multipart/form-data; boundary=" + SendBytes.BOUNDARY;
		url_request.data = this;
		
		return url_request;
	}
}

}
