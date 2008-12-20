/**
 * Hi-ReS! Stats
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * How to use:
 * 
 *	addChild( new Stats() );
 * 
 * version log:
 *
 *	08.12.14		1.4		Mr.doob			+ Code optimisations and version info on MOUSE_OVER
 *	08.07.12		1.3		Mr.doob			+ Some speed and code optimisations
 *	08.02.15		1.2		Mr.doob			+ Class renamed to Stats (previously FPS)
 *	08.01.05		1.2		Mr.doob			+ Click changes the fps of flash (half up increases,
 *											  half down decreases)
 *	08.01.04		1.1		Mr.doob & Theo	+ Log shape for MEM
 *											+ More room for MS
 *											+ Shameless ripoff of Alternativa's FPS look :P
 * 	07.12.13		1.0		Mr.doob			+ First version
 **/

package net.hires.debug
{
	import flash.system.Capabilities;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	public class Stats extends Sprite
	{	
		
		private static const BG_COLOR:Number = 0xFF000000;
		private static const MEM_COLOR:Number = 0xFFFF0000;
		private static const FRAME_COLOR:Number = 0xFF00FF00;
		private static const MS_TO_RENDER_FRAME_COLOR:Number = 0xFF0000FF;
		
		private var graph : BitmapData;
		private var ver : Sprite;
		
		private var fpsText : TextField, msText : TextField, memText : TextField, verText : TextField, format : TextFormat;
		
		private var fps :int, timer : int, ms : int, msPrev	: int = 0;
		private var mem : Number = 0;
		
		private var rectangle : Rectangle;
		
		public function Stats( ):void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage( e : Event ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
			//graphics.beginFill( BG_COLOR );
			//graphics.drawRect( 0, 0, 65, 40 );
			//graphics.endFill();
		
			ver = new Sprite();
			//ver.graphics.beginFill( BG_COLOR );
			//ver.graphics.drawRect( 0, 0, 65, 30 );
			//ver.graphics.endFill();
			ver.y = 90;
			ver.visible = false;
			addChild(ver);
			
			verText = new TextField();
			fpsText = new TextField();
			msText = new TextField();
			memText = new TextField();
			
			format = new TextFormat( "_sans", 9 );
			
			verText.defaultTextFormat = fpsText.defaultTextFormat = msText.defaultTextFormat = memText.defaultTextFormat = format;
			verText.width = fpsText.width = msText.width = memText.width = 65;
			verText.selectable = fpsText.selectable = msText.selectable = memText.selectable = false;
			
			verText.textColor = 0xFFFFFF;
			verText.text = Capabilities.version.split(" ")[0] + "\n" + Capabilities.version.split(" ")[1];
			ver.addChild(verText);
			
			fpsText.textColor = FRAME_COLOR;
			fpsText.text = "FPS: ";
			addChild(fpsText);
			
			msText.y = 10;
			msText.textColor = MS_TO_RENDER_FRAME_COLOR;
			msText.text = "MS: ";
			addChild(msText);
			
			memText.y = 20;
			memText.textColor = MEM_COLOR;
			memText.text = "MEM: ";
			addChild(memText);
			
			
			graph = null;
			graph = new BitmapData( 65, 50, true, 0xFFFFFF );
			var gBitmap:Bitmap = new Bitmap(graph);
			gBitmap.y = 40;
			addChild(gBitmap);
			
			rectangle = new Rectangle( 0, 0, 1, graph.height );
			
			//addEventListener(MouseEvent.CLICK, onClick);
			//addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			//addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			//addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function update( $fps:Number, $mem:Number, $fr:Number, $ms:Number ) : void
		{
			var fpsGraph:int = Math.min( 50, 50 / stage.frameRate * $fps );
			var memGraph:Number =  Math.min( 50, Math.sqrt( Math.sqrt( $mem * 5000 ) ) ) - 2;
			
			graph.scroll( -1, 0 );
			
			graph.setPixel32( graph.width - 10, graph.height - fpsGraph, FRAME_COLOR);
			graph.setPixel32( graph.width - 10, graph.height - ( ( $ms) >> 1 ), MS_TO_RENDER_FRAME_COLOR );
			graph.setPixel32( graph.width - 10, graph.height - memGraph, MEM_COLOR);
			
			fpsText.text = "FPS: " + $fps + " / " + $fr;
			memText.text = "MEM: " + $mem;
			msText.text = "MS: " + $ms;
		}
		
		public function clear (  ):void
		{
			if( graph != null ) {
				graph.fillRect(graph.rect,0x00FFFFFF)
				
				//graph.floodFill(0, 0, 0x00FF0000 );
			}
		}
		
		private function onClick( e : MouseEvent ) : void
		{
			(this.mouseY > this.height * .35) ? stage.frameRate-- : stage.frameRate++;
			fpsText.text = "FPS: " + fps + " / " + stage.frameRate;
		}	
		
		private function onMouseOver( e : MouseEvent ) : void
		{
			ver.visible = true;
		}
		
		private function onMouseOut( e : MouseEvent ) : void
		{
			ver.visible = false;
		}
	}
}