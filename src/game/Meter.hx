package game;

import flambe.math.FMath;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;

class Meter extends Component {
	public function new(x:Float, y:Float) {
		this.init(x, y);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function setFill(percent:Float):Meter {
		var p = FMath.clamp(percent, 0, 1);
		this._fill.height._ = HEIGHT_MAX * p;
		this._fill.y._ = HEIGHT_MAX - this._fill.height._ + 3;
		return this;
	}

	public function init(x:Float, y:Float) {
		this._root = new Entity().add(new Sprite().setXY(x, y));

		var backing = new Entity().add(new FillSprite(0x111111, 100, 700));
		var fill = new Entity().add(this._fill = cast new FillSprite(0xffaaee, 94, HEIGHT_MAX).setXY(3, 3));

		this._root.addChild(backing).addChild(fill);
	}

	private var _fill:FillSprite;
	private var _root:Entity;

	private static var HEIGHT_MAX = 694;
}
