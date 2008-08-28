package delorum.upload
{
import flash.external.ExternalInterface;
import flash.events.*;
import flash.net.*;

/**
* 	A class with methods common to uploading files
* 	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Tyler Flint & Mark Parson. 2008-08-27
* 	@rights	  Copyright (c) Delorum 2008. All rights reserved	
*/

/*

Todo:
- create api for different file types.
	
*/

public class FileUploader extends EventDispatcher
{
	// Events
	public static const FILE_UPLOADED:String 	= "file_uploaded";
	public static const UPLOAD_ERROR:String 	= "upload_error";
	public static const IMAGE_SELECTED:String 	= "image_selected";
	
	// Contains the data loaded from file
	public var filePath:String;
	
	// Upload objects
	private var _urlRequest:URLRequest;
	private var _fileRef:FileReference;
	private var _uploadPath:String;
	
	// Javascript method called on image upload success
	private var _javascriptCallBack:String

	public function FileUploader( $fileLocation:String="" ):void
	{
		_urlRequest = new URLRequest();
		_urlRequest.url = $fileLocation;
		deleteFileRef()
	}
	
	public function deleteFileRef (  ):void
	{
		_fileRef = new FileReference();
	}
	
	// ______________________________________________________________ API
	
	/** 
	*	Open file browser, and browse for a file
	*/
	public function browse(  ):void
	{
		_fileRef = new FileReference();
		_fileRef.addEventListener( Event.SELECT, _selectHandler );
		_fileRef.browse( [_getFileTypes()] );
	}
	
	/** 
	*	Open file browser, and browser for a file, then upload it to the upload path
	*	
	*	@param		Path to send the user's selected file to
	*/
	public function browseAndUpload( $uploadPath:String):void
	{
		_uploadPath = $uploadPath;
		_fileRef = new FileReference();
		_fileRef.addEventListener( Event.SELECT, _selectAndUpload );
		_fileRef.browse( [_getFileTypes()] );
	}
	
	/** 
	*	Manually upload a <code>FileReference</code> selected via browse and triggered by the IMAGE_SELECTED event
	*	
	*	@param		a file reference
	*	@param		path to upload to
	*/
	public function upload( $fileRef:FileReference, $uploadPath:String ):void
	{
		var urlRequest:URLRequest = new URLRequest();
		urlRequest.url = $uploadPath;
		$fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _uploadCompleteHandler);
		$fileRef.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
		$fileRef.upload( urlRequest );
	}
	
	// ______________________________________________________________ Event handlers
	
	private function _selectHandler ( e:Event ):void
	{
		var event:SelectEvent = new SelectEvent( IMAGE_SELECTED );
		event.fileReference = e.target as FileReference;
		this.dispatchEvent( event );
	}
	
	private function _selectAndUpload ( e:Event ):void
	{
		upload( e.target as FileReference, _uploadPath );
	}
	
	private function _uploadCompleteHandler( e:DataEvent ):void
	{
		var event:DataEvent = new DataEvent( FILE_UPLOADED );
		event.data = e.data;
		this.dispatchEvent( event );
	}
	
	private function _ioErrorHandler( e:IOErrorEvent ):void
	{
		var event:IOErrorEvent = new IOErrorEvent( UPLOAD_ERROR );
		this.dispatchEvent( event );
		trace( "Upload Error" + e.toString() );
	}
	
	// ______________________________________________________________ File Types
	
	private function _getFileTypes():FileFilter 
	{
        return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
    }
}

}