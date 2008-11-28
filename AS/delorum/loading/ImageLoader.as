package delorum.loading
{

import flash.net.URLRequest;
import flash.display.Loader;
import flash.display.DisplayObjectContainer;
import flash.events.*;
import flash.system.LoaderContext;

/**
* 	Used to load an image into a Sprite immediately,
* 	or it can be added to the end of the load queue
* 	
* 	@example Sample code
* 	<listing version="3.0">
* 		
*	import delorum.loading.ImageLoader                                                        	
*	var ldr:ImageLoader = new ImageLoader( 'images/myFile.jpg', this );			
*	
*	ldr.onComplete	= completeHandler;
*	ldr.onError		= errorHandler;
*	ldr.onProgress	= progressHandler;
*	ldr.onInit		= initHandler;
*	
*	// Add item to load queue... 
*	ldr.addItemToLoadQueue(); 
*	// ...or to load immediately: - 
*	//ldr.loadItem();
*	 
* 	</listing>
* 	
*	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2008-03-24
* 	@rights	  Copyright (c) Delorum 2008. All rights reserved
*/


public class ImageLoader extends BaseLoader implements LoaderIF
{
	private var _itemURL:URLRequest;
	private var _holderMc:DisplayObjectContainer;
	private var _loader:Loader;
	
	/**	Set this to true if you are loading images from a separate domain, and you need programatic access to their pixels  */
	public var checkCrossDomainXml:Boolean = false;
	
	// ______________________________________________________________ Constructor
	/** Constructor
	* 	
	* 	@param		Path to the image
	* 	@param		Sprite or MovieClip to load image into  */
	public function ImageLoader( $loadPath:String, $parent:DisplayObjectContainer ):void
	{
		super();
		
		// Create loader Object and the Url Request Object
		_loader 	= new Loader();
		_itemURL  	= new URLRequest( $loadPath );
		_holderMc 	= $parent;
	}
	
	// ______________________________________________________________ Event dispatcher
	override protected function get _eventListener (  ):EventDispatcher
	{
		return _loader.contentLoaderInfo;
	}
	
	// ______________________________________________________________ Make sure the holder hasn't been removed
	override protected function isStillActive():Boolean
	{
		return holder != null;
	}
	
	/** Loads item immediately */
	override public function loadItem (  ):void
	{
		// Cross domain xml:
		var loaderContext:LoaderContext = new LoaderContext ();
		loaderContext.checkPolicyFile = checkCrossDomainXml;
		
        _loader.load( _itemURL, loaderContext );
		_holderMc.addChild( _loader );
	}
	
	// ______________________________________________________________ Getters / Setters
	/** 
	* 	Gets the holder Sprite
	* 	
	* 	@return	The sprite that will hold the image
	*/
	public function get holder():DisplayObjectContainer {return _holderMc; };
	
}

}