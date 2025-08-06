package  {
	
	import flash.display.MovieClip;
  import flash.events.Event;
	
	public class Main extends MovieClip {
		
		private var balls:Array = [];
		public function Main() {
			initialize();
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function initialize():void
		{
			for (var i:int = 0; i < 10; i++) {
				var ball:Ball = new Ball();
				ball.position.x = Math.random() * stage.stageWidth;
				ball.position.y = Math.random() * stage.stageHeight - 50;
				balls.push(ball);
				addChild(ball);
			}
		}

		private function onEnterFrame(event:Event):void
    {
			for each (var ball:Ball in balls) {
				ball.update();
				ball.handleWallCollision(stage.stageWidth, stage.stageHeight);
				for each (var other:Ball in balls) {
					if (ball != other) {
						ball.handleBallCollision(other);
					}
				}
			}
    }
	}
	
}
