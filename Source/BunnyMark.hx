package;





import crashdumper.CrashDumper;
import crashdumper.SessionData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import openfl.display.FPS;
import openfl.Assets;
import tests.*;
#if (windows || mac || linux)
	import openfl.events.UncaughtErrorEvent;
#elseif flash
	import flash.events.UncaughtErrorEvent;
#end


/**
 * @author Joshua Granick
 * @author Iain Lobb
 * @author Philippe Elsass
 */
class BunnyMark extends Sprite {
	
	
	private var background:Background;
	private var fps:FPS;
	var crashDumper:crashdumper.CrashDumper;
	
	
	public function new () {
		
		super ();
		
		trace("start");
		var unique_id:String = SessionData.generateID("fooApp_"); 
    //generates unique id: "fooApp_YYYY-MM-DD_HH'MM'SS_CRASH"
	
		this.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, error);

		crashDumper = new CrashDumper(unique_id); 
    //starts the crashDumper
		#if (windows || mac || linux)
			var fakeConfigFile:String = Assets.getText("assets/config.xml");
			crashDumper.session.files.set("config.xml", fakeConfigFile);
		
		#end

		Env.setup ();
		Lib.current.scaleX = Lib.current.scaleY = Env.screenDensity;
		
		background = new Background ();
		background.texture = Assets.getBitmapData ("assets/grass.png");
		background.cols = 8;
		background.rows = 12;
		background.x = -50;
		background.y = -50;
		background.setSize (Env.width + 100, Env.height + 100);
		addChild (background);
		
		addChild (new TilesheetTest ());
		//addChild (new DrawRectTest ()); // Does not support alpha or rotation
		//addChild (new BitmapTest ());
		//addChild (new DrawTrianglesTest ()); // Does not support rotation
		//addChild (new CopyPixelsTest ());
		//addChild (new NoBatchTilesheetTest ());
		
		fps = new FPS ();
		addChild (fps);
		
		fps.addEventListener (MouseEvent.CLICK, fps_onClick);
		stage.addEventListener (Event.RESIZE, stage_onResize);
		trace("finish init");
		
	}
	
	private function error(e:Event):Void 
	{
		trace("Error");
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function fps_onClick (event:MouseEvent):Void {
		
		stage.frameRate = 90 - stage.frameRate;
		
	}
	
	
	private function stage_onResize (event:Event):Void {
		
		if (Env.width > Env.height) {
			
			background.cols = 12;
			background.rows = 8;
			
		} else {
			
			background.cols = 8;
			background.rows = 12;
			
		}
		
		background.setSize (Env.width + 100, Env.height + 100);
		
	}
	
	
}