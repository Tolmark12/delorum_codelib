package delorum.images
{
import flash.geom.*;
import flash.display.*;
import flash.utils.getTimer;
import flash.events.*;
import flash.text.*;

public class EdgeFinder
{
	public static const RIGHT:uint 	= 1;
	public static const LEFT:uint 	= 2;
	public static const UP	:uint 	= 3;
	public static const DOWN:uint 	= 4;
	public static const directions:Array = [ "","RIGHT","LEFT","UP","DOWN" ];
	
	private var _bmd:BitmapData;
	
	// Array full of rectangles around letters
	private var _returnAr:Array;
	private var _direction:uint;							
	
	// A block of points like		a1 a2	. .
	// used to test the pixel       b1 b2	. .
	// visibility of shapes
	private var _a1:FinderPoint  = new FinderPoint();
	private var _a2:FinderPoint  = new FinderPoint();
	private var _b1:FinderPoint  = new FinderPoint();
	private var _b2:FinderPoint  = new FinderPoint();
	
	private var _tempBitmapData:BitmapData;
	private var _mc:DisplayObjectContainer;
	
	public var maxWidth:Number = 700;
	public var maxLines:Number = 4;
	public var leading:Number = 23;
	public var yPos:Number = 14;
	public var alphaAir:Number = 0;
	public var diffAir:Number;
	public var totalExtraAir:Number;
	
	public function EdgeFinder( $mc:DisplayObjectContainer, $textField:TextField ):void
	{
		var tf:TextFormat = $textField.getTextFormat();
		var tempSpacing = tf.letterSpacing;
		tf.letterSpacing = alphaAir;
		$textField.setTextFormat(tf);
		_mc = $mc;
		_a1.logPositions = true;
		_a1.addEventListener( FinderPoint.INFINITE_LOOP, _onInfiniteLoop, false,0,true );
		_a1.reset();
		_bmd = new BitmapData( $mc.width, $mc.height, true, 0x00000000 );
		_bmd.draw($mc);
		
		//tf.letterSpacing = 0;
		//$textField.setTextFormat(tf);
		
		_tempBitmapData = new BitmapData( $mc.width, $mc.height );
		_tempBitmapData.draw($mc)
		var bitmap:Bitmap = new Bitmap(_tempBitmapData);
		bitmap.y = 140;
		$mc.addChild( bitmap )
	}
	
	private var _allLettersFound:Boolean;
	
	public function findLetters (  ):Array
	{
		_direction = RIGHT;
		_returnAr = new Array();		
		var start:Number = getTimer()
		
		
		for ( var i:uint=0; i<maxLines; i++ ) 
		{
			_resetForNextLine();
			_allLettersFound = false;
			totalExtraAir = 0;
			while ( !_allLettersFound ){
				if( _moveToEdgeOfLetter() )
					break;
				var rect:Rectangle = _findNextLetter()
				_returnAr.push( new Rectangle(rect.x - totalExtraAir, rect.y, rect.width, rect.height) );
				totalExtraAir += alphaAir*2;
			}
			yPos += leading;
		}
		
		
		trace(start  + '  :  ' +  getTimer() )
		_drawRectangles(_returnAr);
		return _returnAr;
	}
	
	private function _drawRectangles ( $ar:Array ):void
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xFF0000, 1);
		
		var len:uint = $ar.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			var rect:Rectangle = $ar[i];
			//var shape:Shape = new Shape();
			shape.graphics.clear();
			shape.graphics.beginFill(0xFFFFFF)
			//shape.graphics.lineStyle(1, 0x00AAAA, 0.2)
			shape.graphics.drawRect(rect.x-1, rect.y-4,rect.width+3,rect.height+6);
			shape.graphics.endFill();
			_mc.addChild(shape);
			
			_tempBitmapData.draw(shape);
		}
	}
	
	private var _letterIsClosed:Boolean;
	private var _letterRectangle:Rectangle = new Rectangle(0,0,0,0) ;
	private var _letterStartX:Number;
	private var _letterStartY:Number;
	
	private function _findNextLetter (  ):Rectangle
	{                                                         
		_letterIsClosed 	= false;
		_letterStartX		= _a1.x;
		_letterStartY		= _a1.y;
		while( !_letterIsClosed ){
			_moveAndTestBlock();
		}
		
		return _letterRectangle;
	}
	
	
	private function _moveAndTestBlock (  ):void
	{
		switch (_direction)
		{
			case RIGHT :
				incramentBlocksX( 1 );
				if( _a2.lastChange == FinderPoint.EMPTIED )
					_direction = UP;
				else if ( _b2.lastChange == FinderPoint.EMPTIED )
					_direction = DOWN;
				else if( _a2.lastChange == FinderPoint.FILLED )
					_direction = UP;
				else if( _b2.lastChange == FinderPoint.FILLED )
					_direction = DOWN;
			break;
			case LEFT :
				incramentBlocksX( -1 );
				if( _a1.lastChange == FinderPoint.EMPTIED )
					_direction = UP;
				else if ( _b1.lastChange == FinderPoint.EMPTIED )
					_direction = DOWN;
				else if( _a1.lastChange == FinderPoint.FILLED )
					_direction = UP;
				else if( _b1.lastChange == FinderPoint.FILLED )
					_direction = DOWN;
			break;
			case UP :
				incramentBlocksY( -1 );
				if( _a1.lastChange == FinderPoint.EMPTIED )
					_direction = LEFT;
				else if ( _a2.lastChange == FinderPoint.EMPTIED )
					_direction = RIGHT;
				else if( _a1.lastChange == FinderPoint.FILLED )
					_direction = LEFT;
				else if( _a2.lastChange == FinderPoint.FILLED )
					_direction = RIGHT;
			break;
			case DOWN :
				incramentBlocksY( 1 );
				if( _b1.lastChange == FinderPoint.EMPTIED )
					_direction = LEFT;
				else if ( _b2.lastChange == FinderPoint.EMPTIED )
					_direction = RIGHT;
				else if( _b1.lastChange == FinderPoint.FILLED )
					_direction = LEFT;
				else if( _b2.lastChange == FinderPoint.FILLED )
					_direction = RIGHT;
			break;
		}
		_drawRed(_a1)
	}
	
	
	
	// _____________________________ Helpers
	
	//// Move the points along y axis:
	private function incramentBlocksY ( $inc:Number ):void{
		_a1.incramentY($inc);
		_a2.incramentY($inc);
		_b1.incramentY($inc);
		_b2.incramentY($inc);
		_testBlock();
	}
	
	//// Move the points along the x axis
	private function incramentBlocksX ( $inc:Number ):void{
		_a1.incramentX($inc);
		_a2.incramentX($inc);
		_b1.incramentX($inc);
		_b2.incramentX($inc);
		_testBlock()
	}
	
	//// Test each pixel's value and see if it
	//// has changed since last test:
	private function _testBlock (  ):void{
		_a1.testPixelValue( _bmd );
		_a2.testPixelValue( _bmd );
		_b1.testPixelValue( _bmd );
		_b2.testPixelValue( _bmd );
	}
	
	
	private function _drawRed ( $pnt:FinderPoint ):void{
		// X and Width test
		if( $pnt.x < _letterRectangle.x )
			_letterRectangle.x = $pnt.x;
		else if( $pnt.x - _letterRectangle.x > _letterRectangle.width )
			_letterRectangle.width = $pnt.x - _letterRectangle.x;
		
		// Y and Height test
		if( $pnt.y < _letterRectangle.y )
			_letterRectangle.y = $pnt.y;
		else if( $pnt.y - _letterRectangle.y > _letterRectangle.height )
			_letterRectangle.height = $pnt.y - _letterRectangle.y;	
		
		//_tempBitmapData.setPixel($pnt.x, $pnt.y, 0xFF0000 );
	}
	
	private var _haveHitLetterEdge:Boolean;
	private function _moveToEdgeOfLetter (  ):Boolean{
		_haveHitLetterEdge = false;
		_a1.x = _letterRectangle.x + _letterRectangle.width;
		_a2.x = _letterRectangle.x + _letterRectangle.width+1;
		_b1.x = _letterRectangle.x + _letterRectangle.width;
		_b2.x = _letterRectangle.x + _letterRectangle.width+1;
		
	   	_a1.y = yPos;
	   	_a2.y = yPos;
	   	_b1.y = yPos + 1;
	   	_b2.y = yPos + 1;
				
		_drawRed(_a1)
		_letterRectangle	= new Rectangle(_a1.x,_a1.y,0,0);		
		_a1.reset();
		
		while (!_haveHitLetterEdge)
		{
			// Make sure we don't exceed the max width 
			if( _a1.x > maxWidth )
				return true;
				
			incramentBlocksX(1)
			if( _a2.lastChange == FinderPoint.FILLED || _b2.lastChange == FinderPoint.FILLED ){
				//incramentBlocksX(-1)
				_haveHitLetterEdge = true;
				if( _a2.lastChange == FinderPoint.EMPTIED )
					_direction = UP;
				else if ( _b2.lastChange == FinderPoint.EMPTIED )
					_direction = DOWN;
				else if( _a2.lastChange == FinderPoint.FILLED )
					_direction = UP;
				else if( _b2.lastChange == FinderPoint.FILLED )
					_direction = DOWN;
				_letterRectangle.x = _a1.x-1;
			}
		}
		return false;
	}
	
	private function _resetForNextLine (  ):void
	{
		_a1.x = 0;
		_a2.x = 1;
		_b1.x = 0;
		_b2.x = 1;
		_letterRectangle = new Rectangle(0,0,0,0);
	}
	
	private function _onInfiniteLoop ( e:Event ):void {
		_letterIsClosed = true;
	}
}

}