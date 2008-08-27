package {
import flash.display.Sprite;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.external.ExternalInterface;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.URLRequest;

public class FileUploader extends Sprite 
{
	private var _uploadURL:URLRequest;
	
	private var _file:FileReference;
	
	private var _callback:String;

	public function FileUploader() 
	{
		_file = new FileReference();
		_uploadURL = new URLRequest();
		
		_initExternalInterface();
	}
	
	private function _initExternalInterface():void
	{
		if( ExternalInterface.available ){
			ExternalInterface.addCallback("browse", _browse);
			ExternalInterface.addCallback("upload", _uploadFile);
			ExternalInterface.addCallback("remove", _remove);
		}
	}
	
	 private function _getTypes():Array {
        var allTypes:Array = new Array(_getImageTypeFilter());
        return allTypes;
    }

    private function _getImageTypeFilter():FileFilter {
        return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
    }
	
	private function _browse( e:Event=null ):void
	{
		_file.browse(_getTypes());
	}
	
	private function _uploadFile( $url:String=null, $callBack:String=null ):void
	{
		_uploadURL.url = $url;
		_callback = $callBack;
		_file.upload(_uploadURL, "image");
		_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, _completeHandler);
		_file.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
		
	}
	
	private function _remove():void
	{
		_file = new FileReference();
	}
	
	private function _completeHandler( event:DataEvent ):void
	{
		ExternalInterface.call(_callback, event.data);
		_remove();
	}
	
	private function _ioErrorHandler( event:IOErrorEvent ):void
	{
		ExternalInterface.call(_callback, "Error: " + event.toString());
	}
	
	
	
}
}
