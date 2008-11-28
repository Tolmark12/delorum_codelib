package 
{

import flash.display.Sprite;
import delorum.upload.*;
import flash.events.*;

public class FileUploaderTester extends Sprite
{
	private var _uploader:FileUploader;
	
	public function FileUploaderTester():void
	{
		// create new file uploader
		_uploader = new FileUploader();
		_uploader.addEventListener( FileUploader.FILE_UPLOADED, _uploadComplete );
		_uploader.addEventListener( FileUploader.UPLOAD_ERROR, _uploadFailed    );
		
		// Browse for file
		_uploader.browseAndUpload("http://codelib.dev/AS_examples/uploader_ex/uploadSaver.php");
	}
	
	// ______________________________________________________________ Event handlers
	
	private function _uploadComplete ( e:DataEvent ):void
	{
		trace( e.data );
	}
	
	private function _uploadFailed ( e:IOErrorEvent ):void
	{
		trace( e.toString() );
	}

}

}