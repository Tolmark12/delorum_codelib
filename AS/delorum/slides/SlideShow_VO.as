package delorum.slides
{

import flash.display.Sprite;

public class SlideShow_VO extends Sprite
{
	public var slides:Array;
	
	/** 
	*	Constructor
	*	
	*	@param		An array of Slide_VO objects
	*/
	public function SlideShow_VO ( $slideVoArray:Array=null ):void
	{
		slides = ( $slideVoArray == null)? new Array() : $slideVoArray;
	}

	/** 
	*	Create slideshow from xml
	*	
	*	@param		An xml list full of img tags ex: <img src="my_image.jpg" /> etc...
	*	@param		The directory where the images live
	*/
	public function parseXml ( $slideShowXml:XMLList, $imagePath:String="" ):void
	{
		slides = new Array();
		var count:uint = 0;
		
		for each( var node:XML in $slideShowXml.img)
		{
			var vo:Slide_VO	 = new Slide_VO(  );
			vo.imagePath 	 = $imagePath + node.@src;
			vo.thumbnailPath = $imagePath + node.@thmb;
			vo.index		 = slides.length;
			vo.id			 = "slide" + count++;
			slides.push( vo );
		}
	}

}
}
