package {
  import flash.display.MovieClip;
  import flash.utils.getDefinitionByName;
  public class Bumpers extends MovieClip{
    public var position:Vector2D;
    public var radius:Number;
    public var restitution:Number = 1.5;

    public function Bumpers(x:Number, y:Number, radius:Number, linkageId:String = "bumper") {
      this.position = new Vector2D(x, y);
      this.radius = radius;

      var bumperGraphic:MovieClip = new (getDefinitionByName(linkageId) as Class)();
      this.addChild(bumperGraphic);
      graphics.beginFill(0x00FF00);
      graphics.drawCircle(0, 0, radius);
      graphics.endFill();
      position.x = x;
      position.y = y;
      this.x = position.x;
      this.y = position.y;
    }

    public function handleBallCollision(ball:Ball):void {
      var n:Vector2D = new Vector2D(ball.position.x - position.x, ball.position.y - position.y);
      var distance:Number = n.length();

      if (distance >= radius + ball.radius || distance == 0) return;

      n.scale(1 / distance);

      // Separate overlapping ball and bumper.
      var overlap:Number = radius + ball.radius - distance;
      ball.position.x += n.x * overlap;
      ball.position.y += n.y * overlap;

      // Reverse ball velocity along the normal and apply restitution.
      var speed:Number = ball.velocity.productDot(n);
      if (speed > 0) return;
      // Project velocity onto normal, reverse and scale by restitution
      ball.velocity.x -= restitution * speed * n.x;
      ball.velocity.y -= restitution * speed * n.y;
    }
  }
}