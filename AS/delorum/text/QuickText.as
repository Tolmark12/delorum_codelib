package delorum.text
{

import flash.display.*;
import flash.text.*;
import flash.events.*;
import flash.geom.Rectangle;

public class QuickText extends Sprite
{
	private var _useBitmap:Boolean = true;
	private var _textField:TextField;
	//private var _bitmap:Bitmap;
	private var _styleSheet:StyleSheet;
	private var _baseStyle:Object;
	
	// Bitmap Data
	private var _bmData:BitmapData = new BitmapData(400, 400, true, 0x000000);
	private var _bitmap:Bitmap;
	
	public function QuickText():void
	{
		_textField 				= new TextField();
		_textField.autoSize 	= "left";
		_textField.multiline	= true;
		//_textField.visible 		= false;
		//this.addChild( _textField );
		
		this.addEventListener( Event.ADDED_TO_STAGE, _addBitmap );
		this.addEventListener( Event.RENDER, _updateFormat )
		clearAllFormatting();
		
		_bitmap = new Bitmap( _bmData );
		this.addChild( _bitmap );
	}
	
	// ______________________________________________________________ API
	
	/** 
	*	Add css formatting rules to this text field
	*	@param		one or more css formated text data.
	*	@example	parseCss( "p{ color:#FF0000 }", "h1{ ... }", etc... );
	*/ 
	public function parseCss ( ...$cssObjects ):void
	{
		var tempStyleSheet:StyleSheet = new StyleSheet();
    
		// Parse all styles
		var len:uint = $cssObjects.length-1;
		for ( var i:int=len; i>=0; i-- ) 
		{
			tempStyleSheet.parseCSS( $cssObjects[i] );
		}
    
		// Copy styles into _styleSheet
		var len2:uint = tempStyleSheet.styleNames.length;
		for ( var j:uint=0; j<len2; j++ ) 
		{
			var tag:String = tempStyleSheet.styleNames[j];
			var newStyle:Object = tempStyleSheet.getStyle( tag );
			var oldStyle:Object = _styleSheet.getStyle( tag );
			// Copy any existing params from old style sheet
			for( var k:String in oldStyle )
			{
				// only copy if the new style does not have this param defined
				if( newStyle[k] == null )
					newStyle[k] = oldStyle[k];
			}
			_styleSheet.setStyle( tag, newStyle );
		}
    
		_updateFormat();
	}
	
	/** 
	*	Removes all formatting from textfield
	*/
	public function clearAllFormatting (  ):void
	{
		_styleSheet = new StyleSheet();
		_baseStyle	= new Object();
		_updateFormat();
	}
	
	// ______________________________________________________________ Private Helpers
	
	// apply any changes in the format to textfield
	private function _updateFormat ( e:Event=null ):void
	{
		_styleSheet.setStyle( "body", _baseStyle );
		_textField.styleSheet = _styleSheet;
		_addBitmap();
	}
	
	// Convert text into a bitmap for performance improvement
	private function _addBitmap ( e:Event = null ):void
	{
		if( _useBitmap && this.width + this.height != 0 ) 
		{
			// Make textfield visible for drawing
			//_textField.visible = true;
			
			// Remove existing bitmap
			//if( _bitmap != null ) 
			//	this.removeChild(_bitmap);
			
			// draws
			//var _bmData:BitmapData = new BitmapData(400, 400, true, 0x000000);
			_bmData.fillRect(_bmData.rect,0x00FFFFFF);
			_bmData.draw( _textField, null, null, null, new Rectangle(0,0,400,400) );
			
			// Create bitmap to display
			//_bitmap = new Bitmap( _bmData );
			//this.addChild( _bitmap );
			
			// hide text
			//_textField.visible = false;
		}
		else
		{
			//if( this.numChildren == 0)
			//{
				//_textField.visible = true;
				//this.addChild( _textField );
			//}
		}
		
	}
	
	
	// Remove all "\n" characters, and all white space between xml nodes
	private function _stripNewLines ( $str:String ):String
	{
		// remove new line chars
		var look:RegExp = /\n/g;
		$str = $str.replace(look, "");
		
		// remove white space between xml nodes
		look = /(?<=>)\s*(?=<)/g
		return $str.replace(look, "");
	}
	
	// ______________________________________________________________ Getters / Setters
	
	// Setting text
	public function set text 		( $str:String ):void { htmlText = $str; };
	public function set htmlText 	( $str:String ):void { _textField.htmlText = "<body>" + _stripNewLines( $str ) + "</body>"; _updateFormat();  };
	
	// Setting dimmension
	public function get txtField (  ):TextField 	 { return _textField; };
	public function set textWidth ( $val:uint ):void { _textField.width = $val; _addBitmap(); };
	public function get textWidth ():uint 			 { return _textField.textWidth; };
	
	// Manually setting formatting
	public function set size ( $size:Number ):void 		 { _baseStyle.fontSize = $size; _updateFormat();  };
	public function set color ( $hex:uint ):void 		 { _baseStyle.color = $hex; _updateFormat() };
	public function set leading ( $leading:Number ):void {  _baseStyle.leading = $leading; _updateFormat(); };
	public function set useBitmap ( $bool:Boolean ):void { 
		_useBitmap = $bool; 
		if( !_useBitmap && _bitmap != null ) 
			_bitmap.visible = false;
	};

}

}