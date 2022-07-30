package game;

import flambe.util.Value;
import flambe.Component;

class OverallScore extends Component {
	public var scoreFirst:Value<Int>;
	public var scoreSecond:Value<Int>;

	public function new() {
		this.init();
	}

	public function reset():Void {
		this.scoreFirst._ = 0;
		this.scoreSecond._ = 0;
	}

	private function init() {
		this.scoreFirst = new Value(0);
		this.scoreSecond = new Value(0);
	}
}
