package  {
	import flash.display.MovieClip;
  import flash.events.Event;
  import flash.utils.getDefinitionByName;
	public class Ball extends MovieClip {
    
    public var position:Vector2D;
    public var velocity:Vector2D;
    public var acceleration:Vector2D;
    public var radius:Number;
    public var mass:Number = 1;
    
    public function Ball(linkageId:String = "testBall") {
      // if linkageId is provided, use it to create the ball with a specific graphic
      if (linkageId) {
        var ballGraphic:MovieClip = new (getDefinitionByName(linkageId) as Class)();
        this.addChild(ballGraphic);
      }
      radius = Math.random() * 20 + 10;
      mass = radius * 0.1;
      position = new Vector2D();
      velocity = new Vector2D();
      acceleration = new Vector2D();
      acceleration.y = 1; // gravity
      
      graphics.beginFill(0xFF0000);
      graphics.drawCircle(0, 0, radius);
      graphics.endFill();
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(event:Event):void
    {
      update();
    }

    public function update():void {
      velocity.add(acceleration);
      position.add(velocity);
      x = position.x;
      y = position.y;
    }
    
  }
}