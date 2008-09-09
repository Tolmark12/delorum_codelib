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
			ldr.addEventListener( Event.COMPLETE, _handleImageLoaded );
			ldr.addItemToLoadQueue();
		}
	}
	
	private function _handleImageLoaded ( e:Event ):void
	{
		
	}
}

}