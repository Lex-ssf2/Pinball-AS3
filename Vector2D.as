package  {
	
	public class Vector2D {
		
		public var x:Number;
		public var y:Number;
		
		public function Vector2D(x:Number = 0, y:Number = 0) {
			this.x = x;
			this.y = y;
		}

		public function set(v:Vector2D):void {
			this.x = v.x;
			this.y = v.y;
		}

		public function clone():Vector2D {
			return new Vector2D(this.x, this.y);
		}

		public function add(v:Vector2D, scale:Number = 1):void {
			this.x += v.x * scale;
			this.y += v.y * scale;
		}

		public function subtract(v:Vector2D, scale:Number = 1):void
		{
			this.x -= v.x * scale;
			this.y -= v.y * scale;
		}

		public function addVectors(vectors:Array):void
		{
			for each (var v:Vector2D in vectors) {
				this.add(v);
			}
		}

		public function subtractVectors(vectors:Array):void
		{
			for each (var v:Vector2D in vectors) {
				this.subtract(v);
			}
		}

		public function scale(s:Number):void {
			this.x *= s;
			this.y *= s;
		}

		public function length():Number {
			return Math.sqrt(this.x * this.x + this.y * this.y);
		}

		public function normalize():void {
			var len:Number = this.length();
			if (len != 0) {
				this.x /= len;
				this.y /= len;
			}
		}

		public function productDot(v:Vector2D):Number {
			return this.x * v.x + this.y * v.y;
		}

		public function perpendicular():Vector2D {
			return new Vector2D(-this.y, this.x);
		}
		
		public function toString():String {
			return "(" + this.x + ", " + this.y + ")";
		}
	}
	
}
