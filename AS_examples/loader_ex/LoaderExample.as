package
{

import flash.display.*;
import delorum.loading.ImageLoader;
import flash.events.*;

public class LoaderExample extends MovieClip
{
	
	// Constructor
	public function LoaderExample():void{
		_loadImages();
	}

	private function _loadImages (  ):void
	{
		var imageList:Array = [ "img1.jpg", "img2.jpg", "img3.jpg", "img4.jpg", "img5.jpg" ];
		
		var len:uint = imageList.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			// Create holder sprite for image
			var imageHolder:Sprite = new Sprite();
			// Position the holder sprite
			imageHolder.x = i * 140;
			// Add to display list
			this.addChild(imageHolder);
			
			// Create image loader, and add to load queue
			var ldr:ImageLoader = new ImageLoader( "images/" + imageList[i], imageHolder );
			
			// Add event listeners
			ldr.addEventListener( Event.OPEN, _onOpen );
			ldr.addEventListener( ProgressEvent.PROGRESS, _onProgress );
			ldr.addEventListener( Event.COMPLETE, _handleImageLoaded );
			
			// Add to queue
			ldr.addItemToLoadQueue();
		}
	}
	
	// ______________________________________________________________ Event Handlers
	
	// Called when load starts
	private function _onOpen ( e:Event ):void
	{
		trace( "opening..." );
	}
	
	// Called as load progresses
	private function _onProgress ( e:ProgressEvent ):void
	{
		trace( "progress..." + e.bytesLoaded + '  :  ' + e.bytesTotal );
	}
	
	// Called when load is complete
	private function _handleImageLoaded ( e:Event ):void
	{
		trace( "load complete" );
	}	
}
}