package  {
	import flash.display.MovieClip;
  import flash.utils.getDefinitionByName;
  public class Ball extends MovieClip {

    public var position:Vector2D;
    public var velocity:Vector2D;
    public var acceleration:Vector2D;
    public var radius:Number;
    public var mass:Number = 1;
    public var restitution:Number = 0.8;
    
    public function Ball(linkageId:String = "testBall") {
      // if linkageId is provided, use it to create the ball with a specific graphic
      if (linkageId) {
        var ballGraphic:MovieClip = new (getDefinitionByName(linkageId) as Class)();
        this.addChild(ballGraphic);
      }
      radius = Math.random() * 10 + 20;
      mass = 1 * radius;
      position = new Vector2D();
      velocity = new Vector2D();
      acceleration = new Vector2D();
      acceleration.y = 1;
      acceleration.x = 0;
      
      graphics.beginFill(0xFF0000);
      graphics.drawCircle(0, 0, radius);
      graphics.endFill();
    }

    public function update():void {
      velocity.add(acceleration);
      position.add(velocity);
      x = position.x;
      y = position.y;
    }

    public function handleWallCollision(terrain:Array):void {
      
      for each (var wall:PinballStage in terrain) {
        if(wall.hitTestPoint(position.x + radius, position.y, true) || 
           wall.hitTestPoint(position.x - radius, position.y, true) ) {
          velocity.x *= -.8;
        }
        if(wall.hitTestPoint(position.x, position.y + radius, true) || 
           wall.hitTestPoint(position.x, position.y - radius - 1, true)) {
          velocity.y *= -.8;
        }
        while(wall.hitTestPoint(position.x, position.y + radius, true)) {
          position.y -= .1;
          y = position.y;
        }
        while(wall.hitTestPoint(position.x, position.y - radius, true)) {
          position.y += .1;
          y = position.y;
        }
        while(wall.hitTestPoint(position.x + radius, position.y + radius/2, true) ||
              wall.hitTestPoint(position.x + radius, position.y - radius/2, true)) {
          position.x -= .1;
          x = position.x;
        }
        while(wall.hitTestPoint(position.x - radius, position.y + radius/2, true)
              || wall.hitTestPoint(position.x - radius, position.y - radius/2, true)) {
          position.x += .1;
          x = position.x;
        }
      }
      /*if (position.x - radius < 0 || position.x + radius > stageWidth) {
        position.x = Math.max(radius, Math.min(position.x, stageWidth - radius));
        velocity.x *= -1; // reverse horizontal velocity
      }
      if (position.y - radius < 0 || position.y + radius > stageHeight) {
        position.y = Math.max(radius, Math.min(position.y, stageHeight - radius));
        velocity.y *= -1; // reverse vertical velocity
      }*/
    }

    public function handleBallCollision(other:Ball):void {
      var n:Vector2D = new Vector2D(this.position.x - other.position.x, this.position.y - other.position.y);
      var distance:Number = n.length();
      
      if (distance >= this.radius + other.radius || distance == 0) return;

      n.scale(1 / distance);
      
      // Separate overlapping balls.
      var overlap:Number = this.radius + other.radius - distance;
      this.position.x += n.x * overlap / 2;
      this.position.y += n.y * overlap / 2;
      other.position.x -= n.x * overlap / 2;
      other.position.y -= n.y * overlap / 2;
      
      // Compute the relative velocity.
      var relativeVelocity:Vector2D = new Vector2D(this.velocity.x - other.velocity.x, this.velocity.y - other.velocity.y);
      var speed:Number = relativeVelocity.x * n.x + relativeVelocity.y * n.y;
      
      // If balls are moving apart, do nothing.
      if (speed > 0) return;
      
      var impulse:Number = restitution * (2 * speed) / (this.mass + other.mass);
      
      this.velocity.x -= impulse * other.mass * n.x;
      this.velocity.y -= impulse * other.mass * n.y;
      other.velocity.x += impulse * this.mass * n.x;
      other.velocity.y += impulse * this.mass * n.y;
    }
    
  }
}