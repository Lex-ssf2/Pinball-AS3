package  {
	
	import flash.display.MovieClip;
	
	public class Main extends MovieClip {
		
		
		public function Main() {
			initialize();
		}

		private function initialize():void
		{
			for (var i:int = 0; i < 10; i++) {
				var ball:Ball = new Ball();
				ball.position.x = Math.random() * stage.stageWidth;
				ball.position.y = Math.random() * stage.stageHeight;
				addChild(ball);
			}
		}
	}
	
}
