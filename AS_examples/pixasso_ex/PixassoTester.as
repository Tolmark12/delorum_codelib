package 
{

import flash.display.Sprite;
import flash.display.Sprite;
import delorum.loading.ImageLoader;
import delorum.images.Pixasso;
import delorum.images.EffectList;
import flash.events.*;
import com.adobe.images.JPGEncoder;
import com.adobe.images.PNGEncoder;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.utils.ByteArray;
import flash.net.*;
import flash.geom.*;

public class PixassoTester extends Sprite
{
	private var _imageHolder:Sprite;
	private var _pixasso:Pixasso;

	public function PixassoTester():void
	{
		this.stage.scaleMode = "noScale";
		this.stage.align = "T";
		_imageHolder = new Sprite();
		this.addChild(_imageHolder);
		var ldr:ImageLoader = new ImageLoader( "product.png", _imageHolder );
		ldr.addEventListener( Event.COMPLETE, _handleImageLoaded );
		ldr.loadItem();
	}
	
	private function _handleImageLoaded ( e:Event ):void
	{
		_imageHolder.buttonMode = true;
		_imageHolder.addEventListener( MouseEvent.CLICK, _handleClick )
		
		var myBitmapData:BitmapData = new BitmapData(_imageHolder.width, _imageHolder.height, true, 0x000000 );
		myBitmapData.draw( _imageHolder );
		
		
		
		var effectList:EffectList = new EffectList();
		effectList.addEffect( Pixasso.REFLECT, [0.2,0,0.6,3, 6] );
		effectList.addEffect( Pixasso.SCALE, [ 1 ]);
 	   	effectList.addEffect( Pixasso.ADD_SHAPE, ["elipse", 0x000000, "center", "bottom-9", "120%", "2%", 0.2, 5 ]);
 	   	effectList.addEffect( Pixasso.ADD_SHAPE, ["elipse", 0x000000, "center", "bottom-15", "95%", "10%", 0.1, 5 ]);
 	   	effectList.addEffect( Pixasso.ADD_SHAPE, ["square", 0x000000, "center", "bottom-9", "125%", "2%", 0.1, 5 ]);
 	   	effectList.addEffect( Pixasso.BRING_ORIGINAL_IMAGE_TO_FRONT, [] );
 	   	effectList.addEffect( Pixasso.ADD_SHAPE, ["square", 0x000000, "center", "bottom-3", "80%", 1.6, 0.23, 1.2 ]);
	   	effectList.addEffect( Pixasso.ADD_EXTERNAL_IMAGE, ["BUG.png","right-30","top+33",] );
		//effectList.addEffect( Pixasso.ADD_BACKGROUND_COLOR, [0xFFFFAA] );
 	   	//effectList.addEffect( Pixasso.SCALE, [ "50%" ]);
		
		_pixasso = new Pixasso( myBitmapData );
		_pixasso.runBatch(effectList);
		trace( _pixasso );
		//_pixasso.setHeight(1230);
		
		//_pixasso.reflect( 0.2, 0, 1, 0.5 );
		//_pixasso.addBackgroundColor(0xFFFFAA);
	}
	
	private function _handleClick ( e:Event ):void
	{
		var imageStream:ByteArray
		var fileName:String;
		
		this.removeChild(_imageHolder);
		var bitmap:Bitmap = new Bitmap( _pixasso.bitmapData );
		_imageHolder = new Sprite();
		_imageHolder.addChild( bitmap );
		this.addChild( _imageHolder );
		
		//var jpgEncoder 		= new JPGEncoder(85);
		//imageStream 			= jpgEncoder.encode(_pixasso.bitmapData);
		//fileName				= "sketch.jpg"
		
		imageStream 			= PNGEncoder.encode(_pixasso.bitmapData);
		fileName				= "sketch.png";

		if( this.stage.loaderInfo.url.indexOf("http://") == 0 )
		{
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var jpgURLRequest:URLRequest = new URLRequest("jpg_encoder_download.php?name=" + fileName);
			jpgURLRequest.requestHeaders.push(header);
			jpgURLRequest.method = URLRequestMethod.POST;
			jpgURLRequest.data = imageStream;
			navigateToURL(jpgURLRequest, "_blank");
		}
	}

}

}