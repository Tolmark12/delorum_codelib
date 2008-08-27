package delorum.slides
{
	

/**
* 	A simple slideshow
* 	
* 	@example Sample usage:
* 	<listing version=3.0>
*		import delorum.slides.SlideShow;
*		import delorum.slides.Slide_VO;
*		
*		// Example 1:
* 		var mySlideShow = new SlideShow( 200, 300, 4, 2 );
*		mySlideShow.buildFromImagePaths( ["image1.jpg","image2.png","image3.gif"] );
*		this.addChild( mySlideShow );
*		
*		// Example 2: 
*		var mySlideShow = new SlideShow();
*		mySlideShow.slidesWidth = 200;
*		mySlideShow.slidesHeight = 300;
*		mySlideShow.slideDisplayTime = 4;
*		mySlideShow.transitionSpeed = 2;
*	
*		// (untested yet)
*		var values:Array = new Array()
*		values.push( new Slide_VO( "image1.jpg" ) );
*		values.push( new Slide_VO( "image2.gif" ) );
*	
*		this.addChild( mySlideShow );
*		
*		// TODO:
*		// set graphics for thumbnails
*		// set pre-loader
*		// alternate thumbnails
*		// alternate controls
* 	</listing>
* 	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2008-07-30
* 	@rights	  Copyright (c) Delorum 2008. All rights reserved	
*/


import flash.display.Sprite;
import flash.events.*;

public class SlideShow extends Sprite
{
	private var _facade:SlideShowFacade;
	private static var _showCount:uint = 0;
	
	/** 
	*	Creates a slideshow
	*	
	*	@param		The slide width
	*	@param		The slide height
	*	@param		The slide display time in seconds
	*	@param		The transition speed in seconds
	*/
	public function SlideShow( 	$slidesWidth:Number		 = 100, 
								$slidesHeight:Number	 = 100, 
								$slideDisplayTime:Number = 5.5, 
								$transitionSpeed:Number	 = 1.8   ) :void
	{
		slidesWidth      = $slidesWidth;
		slidesHeight     = $slidesHeight;
		slideDisplayTime = $slideDisplayTime;
		transitionSpeed  = $transitionSpeed;

		this.addEventListener( Event.REMOVED_FROM_STAGE, _unmake );
		_facade = SlideShowFacade.getInstance( "slideShow" + _showCount++  );
		_facade.startup( this );
	}
	
	
	// ______________________________________________________________ Removing
	
	private function _unmake ( e:Event ):void
	{
		_facade.unmake();
	}
	
	// ______________________________________________________________ API
	
	/** 
	*	Build the slideshow based on an array of SlideShow_VOs
	*	@param		Value object with data for slide show
	*/
	public function buildSlideShow ( slideShowVo:SlideShow_VO ):void{
		_facade.buildSlideShow( slideShowVo );
	}
	
	/** 
	*	Build the slideshow from an array of image paths
	*	
	*	@param		And array of image paths.
	*	@example 	<listing version="3.0" > buildFromImagePaths( new Array("image1.jpg","path/image2.jpg") ); </listing>
	*/
	public function buildFromImagePaths ( imageArray:Array ):void 
	{
		// Create Slide_Vo objects
		var len:uint = imageArray.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var vo:Slide_VO = new Slide_VO();
			vo.imagePath = imageArray[i];
			imageArray[i] = vo;
		}
		
		var slideShowVo:SlideShow_VO = new SlideShow_VO( imageArray );
		
		_facade.buildSlideShow( slideShowVo );
	}
	
	// ______________________________________________________________ Setters
	/**	 The slide width */
	public function set slidesWidth  		( $v:Number ):void { SlideShowFacade.slidesWidth = $v; };
	/**	The slide height */
	public function set slidesHeight 		( $v:Number ):void { SlideShowFacade.slidesHeight = $v; };
	/**	The slide display time in seconds */
	public function set slideDisplayTime 	( $v:Number ):void { SlideShowFacade.slideDisplayTime = $v; };
	/**	The transition speed in seconds */
	public function set transitionSpeed		( $v:Number ):void { SlideShowFacade.transitionSpeed = $v; };
	
}

}