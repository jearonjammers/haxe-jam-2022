package game;

import flambe.animation.Ease;
import flambe.math.Rectangle;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.math.FMath;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;

class Meter extends Component {
	public function new(pack:AssetPack, x:Float, y:Float, front:String, mid:String) {
		this.init(pack, x, y, front, mid);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function show(instant:Bool):Meter {
		if(instant) {
			this._root.get(Sprite).anchorY._ = 0;
		}
		else {
			this._root.get(Sprite).anchorY.animateTo(0, 1, Ease.cubeOut);
		}
		return this;
	}

	public function setFill(percent:Float):Meter {
		var p = FMath.clamp(percent, 0, 1);
		var val = this._fill.getNaturalHeight() - p * this._fill.getNaturalHeight();
		this._fill.scissor.y = val;
		return this;
	}

	private function init(pack:AssetPack, x:Float, y:Float, front:String, mid:String) {
		this._root = new Entity().add(new Sprite().setXY(x, y));
		this._root.get(Sprite).anchorY._ = 1000;

		var back = new Entity().add(new ImageSprite(pack.getTexture("meterBack")));
		var mid = new Entity().add(_fill = new ImageSprite(pack.getTexture(mid)));
		this._fill.scissor = new Rectangle(0, 0, this._fill.getNaturalWidth(), this._fill.getNaturalHeight());
		var front = new Entity().add(new ImageSprite(pack.getTexture(front)).setXY(-26, 0));

		this._root.addChild(back).addChild(mid).addChild(front);
	}

	private var _fill:ImageSprite;
	private var _root:Entity;

	private static var HEIGHT_MAX = 694;
}
