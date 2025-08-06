package {
  import flash.display.MovieClip;
  import flash.utils.getDefinitionByName;
  public class Flipper extends MovieClip {
    private const FLIPPER_SPEED:Number = 0.05;
    public var position:Vector2D;
    public var length:Number;
    public var angle:Number; // in radians
    public var angularVelocity:Number = 0;
    public var angularAcceleration:Number = 0;
    public var maxAngle:Number;
    public var minAngle:Number;
    public var isLeft:Boolean;
    public var isFlipped:Boolean = false;

    public function Flipper(x:Number, y:Number, length:Number, isLeft:Boolean, linkageId:String = "flipper") {
      var flipperGraphic:MovieClip = new (getDefinitionByName(linkageId) as Class)();
      addChild(flipperGraphic);
      position = new Vector2D(x, y);
      this.length = length;
      if (isLeft) {
        angle = Math.PI / 4; // down
        minAngle = -Math.PI / 8; // up
        maxAngle = Math.PI / 4; // down
      } else {
        angle = -Math.PI / 4; // down
        minAngle = -Math.PI / 4; // down
        maxAngle = Math.PI / 8; // up
      }
      this.isLeft = isLeft;
      graphics.beginFill(0x0000FF);
      if(!isLeft){
        graphics.drawRect(-length, -5, length, 10);
      } else {
        graphics.drawRect(0, -5, length, 10);
      }
      graphics.endFill();
      this.x = x;
      this.y = y;
      isFlipped = false;
    }

    public function update():void {
      this.rotation = angle * (180 / Math.PI);
      angle += angularVelocity;
      if (angle < minAngle) {
        angle = minAngle;
        angularVelocity = 0;
      } else if (angle > maxAngle) {
        angle = maxAngle;
        angularVelocity = 0;
      }
      angularVelocity += angularAcceleration;
      angularAcceleration = 0;
    }

    public function applyForce(force:Number):void {
      angularAcceleration += force;
    }

    public function getEndPosition():Vector2D {
      return new Vector2D(
        position.x + length * Math.cos(angle),
        position.y + length * Math.sin(angle)
      );
    }

    public function handleBallCollision(ball:Ball):void
    {
      var flipperEnd:Vector2D = getEndPosition();
      var flipperVector:Vector2D;
      // For right flipper, reverse the vector direction.
      if (isLeft) {
        flipperVector = new Vector2D(flipperEnd.x - position.x, flipperEnd.y - position.y);
      } else {
        flipperVector = new Vector2D(position.x - flipperEnd.x - 10, position.y - flipperEnd.y + 25);
      }
      
      var ballVector:Vector2D = new Vector2D(ball.position.x - position.x, ball.position.y - position.y);

      var flipperLength:Number = flipperVector.length();
      if (flipperLength == 0) return; // Avoid division by zero
      flipperVector.scale(1 / flipperLength); // Normalize

      var projectionLength:Number = ballVector.productDot(flipperVector);
      projectionLength = Math.max(0, Math.min(flipperLength, projectionLength)); // Clamp to flipper length

      var closestPoint:Vector2D = new Vector2D(
        position.x + projectionLength * flipperVector.x,
        position.y + projectionLength * flipperVector.y
      );

      var n:Vector2D = new Vector2D(ball.position.x - closestPoint.x, ball.position.y - closestPoint.y);
      var distance:Number = n.length();

      if (distance >= ball.radius*1.2 || distance == 0) return;

      n.scale(1 / distance);

      // Separate overlapping ball and flipper.
      var overlap:Number = ball.radius*1.2 - distance;
      ball.position.x += n.x * overlap;
      ball.position.y += n.y * overlap;

      // Reverse ball velocity along the normal and apply restitution.
      var speed:Number = ball.velocity.productDot(n);
      if (speed > 0) return;
      ball.velocity.x -= ball.restitution * speed * n.x;
      ball.velocity.y -= ball.restitution * speed * n.y;
      if(angle != minAngle && angle != maxAngle) {
        var additionalForce:Vector2D = new Vector2D(n.x * 10, n.y * 20 - 5);
        ball.velocity.add(additionalForce);
      }
    }
    public function moveDownFlipper():void {
      if (!isFlipped) {
        angularVelocity = isLeft ? -FLIPPER_SPEED : FLIPPER_SPEED;
        isFlipped = true;
      }
    }
    public function moveUpFlipper():void {
      if (isFlipped) {
        angularVelocity = isLeft ? FLIPPER_SPEED : -FLIPPER_SPEED;
        isFlipped = false;
      }
    }
  }
}