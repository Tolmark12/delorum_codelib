package delorum.slides
{

public class Slide_VO
{
	/**	Path to the image */
	public var imagePath:String;
	/**	Path to the thumbnail */
	public var thumbnailPath:String;	// Optional
	public var index:uint;
	public var id:String;
	
	
	public function Slide_VO ( $imagePath:String=null, $thumbNailPath:String=null ):void
	{
		imagePath = $imagePath;
		thumbnailPath = $thumbNailPath;
	}

}

}