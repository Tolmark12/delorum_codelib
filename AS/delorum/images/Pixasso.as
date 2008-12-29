/*
COMMON FUNCTIONS

scale
setWidth
setHeight
addShape
reflect
addBackgroundColor
addDisplayObject
addExternalImage
bringOriginalImageToFront

FUTURE IDEAS
- Tiling a background image, wide, tall, checkers
- Combine filter sets

BUGS

*/

package delorum.images 
{
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.filters.*;
import delorum.loading.ImageLoader;
import delorum.images.helpers.*;


/**
* 	An image manipulation class used to create various bitmap effects. 
*	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2008-08-14
* 	@rights	  Copyright (c) Delorum 2008. All rights reserved	
*/


public class Pixasso extends EventDispatcher
{
	public static const EFFECT_COMPLETE:String = "effect_complete";
	public static const BATCH_COMPLETE:String = "batch_complete";
	
	//Methods list
	public static const ADD_BACKGROUND_COLOR:String 			= "addBackgroundColor";
	public static const REFLECT:String              			= "reflect";
	public static const ADD_DISPLAY_OBJECT:String				= "addDisplayObject";
	public static const ADD_EXTERNAL_IMAGE:String				= "addExternalImage";
	public static const BRING_ORIGINAL_IMAGE_TO_FRONT:String 	= "bringOriginalImageToFront";
	public static const ADD_SHAPE:String 						= "addShape";
	public static const SCALE:String	 						= "scale";
	public static const SET_WIDTH:String 						= "setWidth";
	public static const SET_HEIGHT:String 						= "setHeight";
	public static const ROUND_CORNERS:String 					= "round_corners";
	public static const CROP:String 							= "crop";
	
	// Copy of the original image
	private var _pristineBmData:BitmapData;
	private var _pristinePosition:Point;
	
	// Bitmap data that gets modified by the various effects
	private var _bmData:BitmapData;
	
	// Effect chain
	private var _effects:EffectList;
	
	// --- Vars used in the various methods
	// addExternalImage() ::: 
	private var _imageHolder:Sprite;
	private var _imageX:*;
	private var _imageY:*;
	private var _addToFront:Boolean;
	
	/**	
	*	Constructor 
	*	
	*	@param		BitmapData object to be manipulated
	*/
	public function Pixasso ( $bitmapData:BitmapData ):void
	{
		_pristinePosition = new Point(0,0);
		_pristineBmData = $bitmapData;
		_bmData = $bitmapData;
	}
	
	///
	/// ______________________________________________________________ API
	///
	
	/// REFLECTION
	/** 
	*	Create an image reflection
	*	
	*	@param		0-1 : How "shiny" the surface is. ie: how faded the reflection is
	*	@param		0-1 : How "reflective" the surface is. ie: how much gradient. A value of 1 would show the gradient sitting on a mirror.
	*	@param		0-1 : Percentage of the original image's height. 1 would have a reflection as tall as the image. 0.2 would reflect the bottom 20% of the image
	*	@param		Amount of blur 
	*	@param		Vertical Shift - The distance to move the reflection up
	*/
	public function reflect ( 	$surfaceShinyness:Number=0.2, 
							  	$surfaceReflectivity:Number=0, 
								$reflectionHeight:Number=1,
								$surfaceBlur:Number=0,
								$verticalShift:Number=0	 ):void
	{
		var reflectionHeight:Number 	= $reflectionHeight * _bmData.height;
		/*var reflectionRectangle:Number	= ( bmData.heigh)bmData.height - reflectionHeight*/
		
		// Image bitmap
		var sprite:Sprite = new Sprite();
		var originBitmap = new Bitmap( _bmData );
		// add bitmap
		sprite.addChild(originBitmap);
				
		// Reflection bitmap
		var tempBitmapData = new BitmapData( _bmData.width, reflectionHeight );
		// Copy the image's bottom pixels we're reflecting
		tempBitmapData.copyPixels( _bmData, new Rectangle(0, _bmData.height - reflectionHeight, _bmData.width, reflectionHeight), new Point(0,0) )
		var reflectBitmap = new Bitmap( tempBitmapData );
		reflectBitmap.scaleY = -1;
		reflectBitmap.y = reflectBitmap.height
		
		// Sprite to hold reflection bitmap
		var spriteReflection = new Sprite()
		spriteReflection.addChild(reflectBitmap);
		
		// Create gradient & gradient mask
		var gradientMask:Shape = new Shape();
		var gradientMatrix:Matrix = new Matrix();
		gradientMatrix.createGradientBox(spriteReflection.width, spriteReflection.height, 1.57079633 );
		gradientMask.graphics.beginGradientFill("linear",[0x000000,0xFFFFFF],[1,0],[$surfaceReflectivity * 255, 255],gradientMatrix);
		gradientMask.graphics.drawRect(0,0, spriteReflection.width, spriteReflection.height);
		
		// Blurring
		var tempSprite:Sprite = new Sprite();
		tempSprite.addChild(spriteReflection);
		var blurredSprite:Sprite = _blur( spriteReflection, $surfaceBlur );
		gradientMask.width = blurredSprite.width;
		gradientMask.x -= $surfaceBlur;
		blurredSprite.addChild(gradientMask);
		
		// mask
		spriteReflection.alpha = $surfaceShinyness;
		spriteReflection.cacheAsBitmap = true;
		gradientMask.cacheAsBitmap = true;
	    spriteReflection.mask = gradientMask;
	    spriteReflection.parent.addChild(gradientMask);
		
		// Save ne coordinates for the pristine image
		_pristinePosition = new Point($surfaceBlur/2, originBitmap.y);
		
		// Copy bitmap data out of sprite snapshot
		_bmData = new BitmapData(sprite.width, sprite.height, true, 0x000000);
		_bmData.draw( sprite );
		addDisplayObject(blurredSprite, "middle", "bottom-"+$verticalShift, true, false );
		_fireEffectComplete();
	}
	
	/// BACKGROUND COLOR
	/** 
	*	Places a background color behind the bitmap. (bitmap must be transparent for any effect to show).
	*/
	public function addBackgroundColor ( $bgColor:uint ):void
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill( $bgColor );
		shape.graphics.drawRect( 0,0, _bmData.width, _bmData.height );
		var bitmap:Bitmap = new Bitmap( _bmData );
		
		var sprite:Sprite =  new Sprite();
		sprite.addChild(shape);
		sprite.addChild(bitmap);
		_bmData = new BitmapData(_bmData.width, _bmData.height, true, 0x000000)
		_bmData.draw(sprite);
		_fireEffectComplete();
	}
	
	/// CROP
	/** 
	*	Crop
	*	
	*	@param		x position. can be a number, or string. valid examples: 25, "right", "left", "left-40", "right+12"
	*	@param		y position. can be a number, or string. valid examples: 25, "top", "bottom", "top-40", "bottom+12"
	*	@param		width. can be a number or a string. valid examples: 100, "25%"
	*	@param		height. can be a number or a string. valid examples: 30, "65%"
	*/
	public function crop ( $x:*, $y:*, $width:*, $height:* ):void
	{
		var tempRectangle:Rectangle = new Rectangle(0,0,$width,$height);
		var aligner = new Aligner();
		var sizer	= new Sizer();
		
		var x:Number = aligner.getX($x, _bmData, tempRectangle );
		var y:Number = aligner.getY($y, _bmData, tempRectangle );
		var wid:Number = sizer.getWidth( $width, _bmData );
		var tal:Number = sizer.getWidth( $height, _bmData );
		
		var tempBM:BitmapData = _bmData;
		tempBM.copyPixels( _bmData, new Rectangle(x,y,wid,tal), new Point(0,0) );
		_pristinePosition = new Point(0, 0);
		_bmData = new BitmapData( wid, tal, true, 0x000000 );
		_bmData.draw( tempBM );
		_fireEffectComplete();
	}
	
	/// ADD A GRAPHIC
	/** 
	*	Add Display object to the bitmap at the specified co-ordinates.
	*	
	*	@param		Display object to add to the graphic
	*	@param		x position. can be a number, or string. valid examples: 25, "right", "left", "left-40", "right+12"
	*	@param		y position. can be a number, or string. valid examples: 25, "top", "bottom", "top-40", "bottom+12"
	*/
	public function addDisplayObject ( $displayObject:DisplayObject, $x:*=0, $y:*=0, $addToFront:Boolean=true, $alignToPristine:Boolean=true  ):void
	{
		var sprite:Sprite = new Sprite();
		var bitmap:Bitmap = new Bitmap( _bmData );
		
		var alignPosition:Point = ( $alignToPristine )? _pristinePosition : new Point(0,0);
		var holderBitmapData	= ( $alignToPristine )? _pristineBmData : _bmData;
		
		var aligner = new Aligner();
		$displayObject.x = aligner.getX( $x, holderBitmapData, $displayObject ) + alignPosition.x;
		$displayObject.y = aligner.getY( $y, holderBitmapData, $displayObject ) + alignPosition.y;
		
		sprite.addChild( bitmap );
		sprite.addChild( $displayObject );
		
		// depth management
		if( !$addToFront )
			_refreshPristineCopy(sprite);
					
		_bmData = new BitmapData( sprite.width, sprite.height, true, 0x000000);
		var rectX:Number = ($displayObject.x < 0)? $displayObject.x : 0;
		var rectY:Number = ($displayObject.y < 0)? $displayObject.y : 0;
		
		var sprite2:Sprite = new Sprite()
		sprite.x = -rectX;
		sprite.y = -rectY;
		sprite2.addChild(sprite);

		_pristinePosition.x -= rectX;
		_pristinePosition.y -= rectY;
		
		_bmData.draw( sprite2 );
		_fireEffectComplete();
	}
	
	/// ADD AN EXTERNAL IMAGE
	/** 
	*	Loads an external image file, and adds it to the bitmap at the specified coordinates.
	*	
	*	@param		Path to the image
	*	@param		x position. can be a number, or string. valid examples: 25, "right", "left", "left-40", "right+12"
	*	@param		y position. can be a number, or string. valid examples: 25, "top", "bottom", "top-40", "bottom+12"
	*/
	public function addExternalImage ( $imagePath:String, $x:*=0, $y:*=0, $addToFront:Boolean=true ):void
	{
		_addToFront = $addToFront;
		_imageX = $x;
		_imageY = $y;
		_imageHolder = new Sprite();
		var ldr:ImageLoader = new ImageLoader( $imagePath, _imageHolder );
		ldr.addEventListener( Event.COMPLETE, _handleExternalImageLoad );
		ldr.loadItem();
	}
	
	private function _handleExternalImageLoad ( e:Event ):void
	{
		addDisplayObject( _imageHolder, _imageX, _imageY, _addToFront );
	}
	
	/// DRAW A SHAPE
	/** 
	*	Adds a colored shape
	*	
	*	@param		Shape kind: "square", "circle"
	*	@param		Color in this format: 0xFFFFFF
	*	@param		x position. can be a number, or string. valid examples: 25, "right", "left", "left-40", "right+12"
	*	@param		y position. can be a number, or string. valid examples: 25, "top", "bottom", "top-40", "bottom+12"
	*	@param		width  // Todo. make this accept a fraction
	*	@param		height
	*	@param		alpha
	*	@param		blur 
	*/
	public function addShape( $shape:String="square", $color:uint=0x000000, $x:*=0, $y:*=0, $w:*=100, $h:*=100, $alpha:Number=1, $blur:Number=0 ):void
	{
		var shape:Shape = new Shape();
		shape.alpha = $alpha;
		shape.graphics.beginFill( $color );
		
		var bitmap:Bitmap = new Bitmap( _pristineBmData );
		var sizer:Sizer = new Sizer();
		var wid:Number = sizer.getWidth( $w, bitmap );
		var tal:Number = sizer.getWidth( $h, bitmap );
		
		if( $shape == "square" )
			shape.graphics.drawRect(0,0,wid,tal);
		else if( $shape == "circle" )
			shape.graphics.drawEllipse(0,0,wid,tal);
		else
			shape.graphics.drawEllipse(0,0,wid,tal);
		
		var blurredShape:Sprite = _blur( shape, $blur );
		addDisplayObject(blurredShape,$x,$y);
	}
	
	// CHANGE THE SCALE
	/** 
	*	Rescale the bitmap - Note, Scaling to very small percentages of the original creates less than desirable effects
	*	
	*	@param		0-1.  The new percentage to scale to ex: 0.8
	*/
	public function scale ( $newScale:Number ):void
	{
		var scaleMatrix:Matrix = new Matrix();
		scaleMatrix.scale($newScale, $newScale);
		
		// Scale the active bitmap data
		var _snapShot:BitmapData = _bmData;
		
		_bmData = new BitmapData(_bmData.width * $newScale, _bmData.height * $newScale, true, 0x000000);		
		_bmData.draw(_snapShot, scaleMatrix, null, null, null, true);
		
		// Scale the pristine data
		var bitmap2 = new Bitmap( _pristineBmData );
		_pristineBmData = new BitmapData(bitmap2.width * $newScale, bitmap2.height * $newScale, true, 0x000000);		
		_pristineBmData.draw(bitmap2, scaleMatrix);		
		_pristinePosition = new Point( _pristinePosition.x * $newScale, _pristinePosition.y * $newScale );
		_fireEffectComplete();
	}
	
	/** 
	*	Change the bitmap's size based on the width
	*	@param		The new width
	*/
	public function setWidth ( $width:Number ):void
	{
		scale( $width / _bmData.width );
	}
	
	/** 
	*	Change the bitmap's size based on the height
	*	@param		The new height
	*/
	public function setHeight ( $height:Number ):void
	{
		scale( $height / _bmData.height );
	}
	
	/// ROUND CORNERS
	/** 
	*	Round the corners of the image
	*	
	*	@param		The radius of the rounded corner
	*/
	public function roundCorners ( $cornerRadius:Number ):void
	{
		// draw rounded corners shape
		var masker:Sprite = new Sprite();
		masker.graphics.beginFill(0xFF0000);
		masker.graphics.drawRoundRect(0,0, _bmData.width, _bmData.height, $cornerRadius);
		
		// use shape to mask current bitmap data 
		var maskedSprite:Sprite = _addMaskToBitmapData( masker );
		
		_bmData = new BitmapData( maskedSprite.width, maskedSprite.height, true, 0x000000 );
		_bmData.draw( maskedSprite );
		_fireEffectComplete();
	}
	
	/// BRING THE ORIGINAL IMAGE TO THE FRONT OF THE EFFECTS
	/** 
	*	Brings the original image back in front of any effects.
	*/
	public function bringOriginalImageToFront (  ):void
	{
		var sprite:Sprite = new Sprite();
		var bitmap:Bitmap = new Bitmap( _bmData );
		sprite.addChild(bitmap);
		_refreshPristineCopy(sprite);
		
		_bmData = new BitmapData(sprite.width, sprite.height, true, 0x000000);
		_bmData.draw( sprite );
		_fireEffectComplete();
	}
	
	// ______________________________________________________________ Helpers
	
	// Draws the pristine bitmap data over the top of any effects 
	private function _refreshPristineCopy ( $sprite:Sprite ):void
	{
		var bitmap:Bitmap = new Bitmap( _pristineBmData );
		bitmap.x = _pristinePosition.x;
		bitmap.y = _pristinePosition.y ;
		//bitmap.alpha = 0.3;
		$sprite.addChild( bitmap );
	}
	
	// Apply a blur effect to a display object
	private function _blur ( $displayObject:DisplayObject, $blurAmount:Number ):Sprite
	{
		var blurSprite:Sprite		= new Sprite();
		blurSprite.addChild( $displayObject );
		var blurFilter:BlurFilter 	= new BlurFilter( $blurAmount, $blurAmount, BitmapFilterQuality.HIGH );
		blurSprite.filters 			= [ blurFilter ];
//		blurSprite.cacheAsBitmap = true;

		// Account for blur bleed
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0x000000,0);
		$displayObject.x += $blurAmount*2;
		$displayObject.y += $blurAmount*2;
		shape.graphics.drawRect( -$blurAmount, -$blurAmount, $displayObject.width  - $blurAmount, $displayObject.height  - $blurAmount );
		blurSprite.addChild(shape);
		return blurSprite;
	}
	
	private function _addMaskToBitmapData ( $mask:DisplayObject ):Sprite
	{
		var sprite:Sprite = new Sprite();
		var bitmap:Bitmap = new Bitmap( _bmData );
		bitmap.mask = $mask;
		bitmap.cacheAsBitmap = true
		sprite.addChild( bitmap );
		sprite.addChild( $mask );
		return sprite;
	}
	
	/// 
	/// ______________________________________________________________ Batching
	///
	
	/** 
	*	Run a series of effects
	*	
	*	@param		A list of effects to run
	*/
	public function runBatch ( $effectList:EffectList ):void{
		_effects = $effectList;
		this.addEventListener( EFFECT_COMPLETE, _runNextEffect );
		_fireEffectComplete()
	}
	
	private function _runNextEffect ( e:Event ):void 
	{
		if( _effects.isEffectsLeft ) {
			var nextEffect:Object 	= _effects.getNextEffect();
			var params:Array 		= nextEffect.params;
			
			// Call the next method
			switch( nextEffect.method ) {
				case REFLECT:
					reflect( params[0], params[1], params[2], params[3], params[4] );
				break;
				case ADD_BACKGROUND_COLOR:
					addBackgroundColor( params[0] );
				break;
				case ADD_EXTERNAL_IMAGE:
				case ADD_DISPLAY_OBJECT:
						params[1] = (params[1] == null)? 0 : params[1];
						params[2] = (params[2] == null)? 0 : params[2];
						params[3] = (params[3] == null)? true : params[3];
					case ADD_EXTERNAL_IMAGE:
						addExternalImage( params[0],params[1],params[2],params[3]  );
					break;
					case ADD_DISPLAY_OBJECT:
						addExternalImage( params[0],params[1],params[2],params[3]  );
					break;
				case BRING_ORIGINAL_IMAGE_TO_FRONT:
					bringOriginalImageToFront();
				break;
				case ADD_SHAPE:
					addShape( params[0],params[1],params[2],params[3],params[4],params[5],params[6],params[7]);
				break;
				case SCALE:
					scale( params[0] );
				break;
				case SET_WIDTH:
					setWidth( params[0] );
				break;
				case SET_HEIGHT:
					setHeight( params[0] );
				break;
				case ROUND_CORNERS:
					roundCorners( params[0] ); 
				break;
				case CROP:
					crop( params[0],params[1],params[2],params[3] );
				break;
			}
		}else{
			this.removeEventListener( EFFECT_COMPLETE, _runNextEffect );
			this.dispatchEvent( new Event( BATCH_COMPLETE ) );
		}
		
	}
	
	private function _fireEffectComplete (  ):void {
		this.dispatchEvent( new Event(EFFECT_COMPLETE) );
	}
	
	// ______________________________________________________________ GETTERS / SETTERS
	
	/**	The Bitmap Data object */
	public function get bitmapData (  ):BitmapData { return _bmData; };
	public function get xOffSet (  ):Number{ return _pristinePosition.x; };
	public function get yOffSet (  ):Number{ return _pristinePosition.y; };
}

}