package game;

import flambe.util.Value;
import flambe.Component;

class OverallScore extends Component {
	public var score:Value<Int>;

	public function new() {
		this.init();
	}

	public function reset():Void {
		this.score._ = 0;
	}

	private function init() {
		this.score = new Value(0);
	}
}
