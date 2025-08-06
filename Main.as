package  {
	
	import flash.display.MovieClip;
  import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Main extends MovieClip {
		
		private var balls:Array = [];
		private var bumpers:Array = [];
		private var flippers:Array = [];
		public function Main() {
			initialize();
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function initialize():void
		{
			for (var i:int = 0; i < 10; i++) {
				var ball:Ball = new Ball();
				ball.position.x = Math.random() * stage.stageWidth;
				ball.position.y =  0 - Math.random() * 200;
				balls.push(ball);
				addChild(ball);
			}
			var bumper:Bumpers = new Bumpers(200, 400, 30,"testBall");
			bumpers.push(bumper);
			addChild(bumper);
			var leftFlipper:Flipper = new Flipper(100, 350, 100, true,"testBall");
			var rightFlipper:Flipper = new Flipper(300, 350, 100, false,"testBall");
			flippers.push(leftFlipper);
			flippers.push(rightFlipper);
			addChild(leftFlipper);
			addChild(rightFlipper);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		private function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.LEFT) {
				for each (var flipper:Flipper in flippers) {
					if (flipper.isLeft) {
						flipper.moveDownFlipper();
					}
				}
			} else if (event.keyCode == Keyboard.RIGHT) {
				for each (flipper in flippers) {
					if (!flipper.isLeft) {
						flipper.moveDownFlipper();
					}
				}
			}
		}

		private function keyUpHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.LEFT) {
				for each (var flipper:Flipper in flippers) {
					if (flipper.isLeft) {
						flipper.moveUpFlipper();
					}
				}
			} else if (event.keyCode == Keyboard.RIGHT) {
				for each (flipper in flippers) {
					if (!flipper.isLeft) {
						flipper.moveUpFlipper();
					}
				}
			}
		}

		private function onEnterFrame(event:Event):void
    {
			for each (var ball:Ball in balls) {
				ball.update();
				ball.handleWallCollision(stage.stageWidth, stage.stageHeight);
				for each (var bumper:Bumpers in bumpers) {
					bumper.handleBallCollision(ball);
				}
				for each (var flipper:Flipper in flippers) {
					flipper.update();
					flipper.handleBallCollision(ball);
				}
				for each (var other:Ball in balls) {
					if (ball != other) {
						ball.handleBallCollision(other);
					}
				}
			}
    }
	}
	
}
