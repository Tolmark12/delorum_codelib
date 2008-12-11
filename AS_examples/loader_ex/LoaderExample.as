package
{

import flash.display.*;
import delorum.loading.ImageLoader;
import flash.events.*;

public class LoaderExample extends MovieClip
{
	public function LoaderExample():void
	{
		_loadImages();
	}

	private function _loadImages (  ):void
	{
		var imageList:Array = [ "img1.jpg",
								"img2.jpg",
								"img3.jpg",
								"img4.jpg",
								"img5.jpg" ];
		
		var len:uint = imageList.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			// Create holder for images
			var imageHolder:Sprite = new Sprite();
			imageHolder.x = i * 140;
			this.addChild(imageHolder);
			
			// Create image loader, and add to load queue
			var ldr:ImageLoader = new ImageLoader( "images/" + imageList[i], imageHolder );
			
			// Event listeners
			ldr.addEventListener( Event.OPEN, _onOpen );
			ldr.addEventListener( ProgressEvent.PROGRESS, _onProgress );
			ldr.addEventListener( Event.INIT, _onInit );
			ldr.addEventListener( Event.COMPLETE, _handleImageLoaded );
			
			// Add to queue
			ldr.addItemToLoadQueue();
		}
	}
	
	// ______________________________________________________________ Event Handlers
	// placed in the orter tha they will fire
	
	// 1st
	private function _onOpen ( e:Event ):void
	{
		trace( "opening..." );
	}
	
	// 2nd, 3rd, 4th.....
	private function _onProgress ( e:ProgressEvent ):void
	{
		trace( "progress..." + e.bytesLoaded + '  :  ' + e.bytesTotal );
	}
	
	// 5th, not sure how this is diff fom COMPLETE
	private function _onInit ( e:Event ):void
	{
		trace( "initialized" );
	}
	
	// 6TH, last
	private function _handleImageLoaded ( e:Event ):void
	{
		trace( "load complete" );
	}
	
	
	

}

}