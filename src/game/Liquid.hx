package game;

import flambe.math.FMath;
import flambe.display.EmitterMold;
import flambe.display.EmitterSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Liquid extends Component {
	public var visible(get, set):Bool;

	public function new(pack:AssetPack, area :String) {
		this.init(pack, area);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function setXY(x:Float, y:Float, rotation:Float, dist:Float):Void {
		var spr = this._root.get(EmitterSprite);
		var r = FMath.toRadians(rotation);
		var nx = dist * Math.cos(r - 1.5708) + x;
		var ny = dist * Math.sin(r - 1.5708) + y;
		spr.setXY(nx, ny);
		spr.angle._ = FMath.toDegrees(MathUtil.reflectAngle(r, true));
	}

	private function get_visible():Bool {
		return this._root.get(EmitterSprite).visible;
	}

	private function set_visible(visible:Bool):Bool {
		return this._root.get(EmitterSprite).visible = visible;
	}

	private function init(pack:AssetPack, area :String) {
		this._root = new Entity();
		var mold = new EmitterMold(pack, '${area}/puke/puke');
		this._root.add(new EmitterSprite(mold).setRotation(90));
	}

	private var _root:Entity;
}
