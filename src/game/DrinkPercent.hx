package game;

import flambe.math.FMath;
import flambe.Component;

class DrinkPercent extends Component {
	public var percent(get, set):Float;

	public function new() {
		this.init();
	}

	private function get_percent():Float {
		return this._percent;
	}

	private function set_percent(percent:Float):Float {
		return this._percent = FMath.clamp(percent, 0, 1);
	}

	public function reset():Void {
		this._percent = 1;
	}

	private function init() {
		this._percent = 1;
	}

	private var _percent:Float;
}
