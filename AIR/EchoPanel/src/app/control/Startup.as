package app.control
{
import org.puremvc.as3.multicore.interfaces.*;
import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
import app.view.*;
import app.model.*;
import app.model.vo.*;
import flash.display.Sprite;

public class Startup extends SimpleCommand implements ICommand
{

	override public function execute( note:INotification ):void
	{		
		var rootSprite:Sprite = note.getBody() as Sprite;
		
		// Create proxies
		var swfTalkProxy:SwfTalkProxy = new SwfTalkProxy( rootSprite );
		
		// Create Mediators
		var chromeMediator = new ChromeMediator();
		var outputMediator = new OutputMediator();
		
		// Register Mediators
		facade.registerMediator( chromeMediator );
		facade.registerMediator( outputMediator );
		
		// Register proxies
		facade.registerProxy( swfTalkProxy );
		
		// Begin
		chromeMediator.make( rootSprite );
		outputMediator.make( rootSprite );
		chromeMediator.firstResize();
		//swfTalkProxy.tester();
	}
}
}