package ui
{

import flash.display.Sprite;
import flash.text.*;
import flash.geom.ColorTransform;
import flash.net.LocalConnection;

public class Content extends Sprite
{
	private var _displayText:TextField;
	private var _count:Number = 1;
	private var _conn:LocalConnection;
	private var _appHeight:Number;
	private var _totalString:String = "";
	
	public function Content():void
	{
		// TEMP - Replace this
		var format:TextFormat = new TextFormat();
        format.font = "Monaco";
        format.color = 0xAAAA44;
        format.size = 9;

		_displayText = new TextField();
		//_displayText.defaultTextFormat = format;
	
		_displayText.autoSize = "left";
		_displayText.wordWrap = true;
		_displayText.antiAliasType = "advanced";
		_displayText.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 225, 0);
		this.addChild(_displayText);
		// TEMP - and this
		_conn = new LocalConnection();
		_conn.client = this;
		_conn.allowDomain('*');
		try {
		    _conn.connect("_delorum_air_connect");
		} catch (error:ArgumentError) {
		    addText("Can't connect...the connection name is already being used by another SWF");
		}
	}
	
	// TEMP
	public function echo ( $str:String ):void
	{
		addText( $str);
	}
	
	public function addText ( $str:String ):void
	{
		var nm:String   = String(_count++);
		var space:String = "";
		var len:uint = nm.length;
		for ( var i:uint=len; i<4; i++ ) 
		{
			space += " ";
		}
		
		_totalString += "<n>" + nm + "</n>" + space + $str + "\n";
		_displayText.htmlText = "<body>" + _totalString + "</body>";
		var style:StyleSheet = new StyleSheet();
        
		var num:Object = new Object();
		num.color = "#333333";
		num.display = "inline";
		var body:Object = new Object();
		body.fontFamily = "Monaco";
		body.color		= "#AAAA44";
		body.fontSize	= 9;
		style.setStyle("n", num);
		style.setStyle("body", body);
		_displayText.styleSheet = style;
		setPosition();
	}
	
	public function resize ( $width:Number, $height:Number ):void
	{
		_appHeight = $height;
		_displayText.width = $width
		setPosition();
	}
	
	public function setPosition (  ):void
	{
		if( this.height > _appHeight - this.parent.y ) 
			this.y = _appHeight - this.height - this.parent.y;
		else
			this.y = 0;
		
		
	}
}

}