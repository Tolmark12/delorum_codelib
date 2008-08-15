package delorum.stage
{


import flash.display.Stage;
import flash.display.DisplayObject;
import flash.events.*;


/**
* 	Used for handling basic stage resize events and values
* 	
* 	@example Sample usage:
* 	<listing version=3.0>
* 	
*	import delorum.stage.StageInfo;
*	StageInfo.setPublishDimmensions( 1020, 768);
*	StageInfo.addResizeListener( mySprite, myCallbackFn );
*	var right:uint = StageInfo.stageRight;
* 	
*	</listing>
* 	
* 	@language ActionScript 3, Flash 9.0.0
* 	@author   Mark Parson. 2008-02-13
* 	@rights	  Copyright (c) Delorum inc. 2008. All rights reserved	
*/


public class StageInfo
{      
	/**	 dimImagemensions of swf */
	public static var _movieWidth	:uint
	public static var _movieHeight	:uint 
	/**	 Dimmensions of area to be centered upon */
	public static var _pseudoWidth	:uint
	public static var _pseudoHeight :uint
	public static var _stageWidth	:uint 	
	public static var _stageHeight	:uint 
	public static var _stageRight	:uint 	
	public static var _stageLeft	:uint 	
	public static var _stageBottom	:uint 
	public static var _stageTop		:uint 
		
	// callback
	private static var callBackFunctions	:Array;
	// state
	private static var alreadyListening		:Boolean;
	// stage
	private static var testStage			:Stage;
	
	public function StageInfo():void
	{
	}
	
	// ______________________________________________________________ Start listening 
	/** 
	*	Start listening for the Stage Resizing event
	*	
	*	@param		Display Object with a stage
	*	@param		CallBack method to call on Stage resize
	*/
	public static function addResizeListener( $mc:DisplayObject=null, $fn:Function=null ):void
	{
		// Called the first time listner is activated
		if( !alreadyListening ) 
		{
			// Make sure there is a valid DisplayObject
			if( $mc == null ) 
			{
				throw new Error( "When adding the first resize listener to StageInfo, you must pass in a valid DisplayObject" +
				 				 " (Sprite, MovieClip, etc..).\n ex: StageInfo.addResizeListener(mySprite, myCallback);\n" );

			}
			callBackFunctions = new Array();
			alreadyListening = true;
			testStage = $mc.stage;
			$mc.stage.addEventListener( Event.RESIZE, resizeHandler );
			resizeHandler();
		}
		
		// Add callback to the list
		if( $fn != null ) 
		{
			callBackFunctions.push( $fn );
		}
	}
	
	// ______________________________________________________________ Stage resize handler
	/** 
	*	@private 	Update the varios values after a stage resize
	*/
	private static function resizeHandler ( e:Event=null ):void
	{
		_stageWidth 		= testStage.stageWidth;
		_stageHeight 		= testStage.stageHeight;
		var diffW:Number 	= _stageWidth  - _movieWidth;
        
		// todo: allow multiple scale align modes... 
		if( 0 == 0 /* Stage Mode == center... */ )
		{
			_stageRight	= _movieWidth + diffW/2;
			_stageLeft	= 0 - diffW /2;
		}
		
		if( 0 == 0 /* Stage Mode == Align to top... */ )
		{
			_stageTop	 = 0;
			_stageBottom = ( _stageHeight < _movieHeight )? _stageHeight : movieHeight;
		}
		
		// Trigger any call backs
		var len:Number = callBackFunctions.length;
		if( len != 0 ) 
		{
			for ( var i:Number=0; i<len; i++ ) 
			{
				callBackFunctions[i]();
			}
		}
	}
	
	
	// ______________________________________________________________ Set the size of the swf
	/** 
	*	Set the size of the swf
	*	
	*	@param		Width
	*	@param		Height
	*/
	public static function setPublishDimmensions ( $w:uint, $h:uint ):void
	{
		_movieWidth 	= $w;
		_movieHeight	= $h;
		_pseudoWidth	= $w
		_pseudoHeight	= $h
	}
	
	// ______________________________________________________________ Set the size of the swf
	/** 
	*	Set the size of the swf
	*	
	*	@param		Width
	*	@param		Height
	*/
	public static function setPseudoDimmensions ( $w:uint, $h:uint ):void
	{
		_pseudoWidth	= $w
		_pseudoHeight	= $h
	}
	
	
	public static function get movieWidth	():uint {return _pseudoWidth; };
	public static function get movieHeight	():uint {return _pseudoHeight; };
	public static function get stageWidth	():uint {return _stageWidth; };
	public static function get stageHeight	():uint {return _stageHeight; };
	public static function get stageTop		():uint {return _stageTop; };
	public static function get stageBottom	():uint {return _stageBottom; };
	public static function get stageRight	():uint {return _stageRight; };
	public static function get stageLeft	():uint {return _stageLeft; };
	
}	
}