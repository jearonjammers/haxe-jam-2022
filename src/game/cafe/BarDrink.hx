package game.cafe;

import flambe.math.Point;
import flambe.util.Value;
import flambe.script.CallFunction;
import flambe.script.AnimateTo;
import flambe.script.Sequence;
import flambe.script.Script;
import flambe.animation.Ease;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

using game.SpriteUtil;

enum BarDrinkState {
	Destroyed(ref:{time:Float});
	Idle;
	Sliding;
	Active(ref:{time:Float});
	Off;
}

class BarDrink extends Component {
	public var state(default, null):Value<BarDrinkState>;

	public function new(pack:AssetPack, x:Float, y:Float) {
		this._x = x;
		this._y = y;
		this.state = new Value(Off);
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	override function onStart() {
		this._pSprite = owner.getFromParents(Sprite);
	}

	override function onUpdate(dt:Float) {
		switch this.state._ {
			case Destroyed(ref):
				ref.time += dt;
				if (ref.time >= DESTROYED_DURATION) {
					this.show(false);
				}
			case Idle:
			case Active(ref):
				ref.time += dt;
				if (ref.time >= ACTIVE_DURATION) {
					this.toss();
				}
			case Off:
			case Sliding:
		}
	}

	public function handPos(viewX:Float, viewY:Float):Bool {
		var rootSpr = this._root.get(Sprite);
		var point = getXY(viewX, viewY);

		switch this.state._ {
			case Destroyed(ref):
			case Idle:
				if (isHit(point.x, point.y)) {
					this.grab(point.x, point.y);
					return true;
				}
			case Active(ref):
				rootSpr.x._ = point.x;
				rootSpr.y._ = point.y;
			case Off:
			case Sliding:
		}
		return false;
	}

	private inline function getXY(viewX:Float, viewY:Float):Point {
		return this._pSprite.localXY(viewX, viewY);
	}

	private function isHit(x:Float, y:Float):Bool {
		var rootSpr = this._root.get(Sprite);
		var x1 = rootSpr.x._ - rootSpr.anchorX._;
		var y1 = rootSpr.y._ - rootSpr.anchorY._;

		var x2 = x1 + rootSpr.getNaturalWidth();
		var y2 = y1 + rootSpr.getNaturalHeight();

		return x1 <= x && x <= x2 && y1 <= y && y <= y2;
	}

	public function show(instant:Bool) {
		var spr = this._root.get(Sprite);
		var isLeft = spr.x._ < 1920 / 2;
		spr.x._ = isLeft ? -2000 : 2000;
		spr.rotation._ = 0;
		spr.y._ = _y;
		this.state._ = Sliding;
		if (instant) {
			this.state._ = Idle;
			spr.x._ = this._x;
		} else {
			this._root.add(new Script()).get(Script).run(new Sequence([
				new AnimateTo(spr.x, _x, 0.666, Ease.cubeOut),
				new CallFunction(() -> {
					this.state._ = Idle;
				})
			]));
		}
		spr.visible = true;
	}

	public function turnOff() {
		this.state._ = Off;
		var spr = this._root.get(Sprite);
		spr.visible = false;
	}

	public function grab(x:Float, y:Float) {
		this.state._ = Active({time: 0});
		var spr = this._root.get(Sprite);
		spr.x._ = x;
		spr.y._ = y;
	}

	public function toss() {
		this.state._ = Destroyed({time: 0});
		var spr = this._root.get(Sprite);
		var throwLeft = Math.random() > 0.5;
		var x = throwLeft ? -500 : 500;
		var rotation = throwLeft ? -180 : 180;
		spr.x.animateTo(spr.x._ + x, 0.3333, Ease.sineIn);
		spr.y.animateTo(-300, 0.3333, Ease.sineOut);
		spr.rotation.animateTo(rotation, 0.3333, Ease.sineOut);
	}

	private function init(pack:AssetPack) {
		this._root = new Entity();
		var tex = pack.getTexture("beerStar");
		var anchorX = tex.width / 2;
		var anchorY = tex.height - 10;
		_root.add(new ImageSprite(tex).setAnchor(anchorX, anchorY).setXY(_x, _y));
	}

	private var _root:Entity;
	private var _pSprite:Sprite;
	private var _x:Float;
	private var _y:Float;

	private static var DESTROYED_DURATION = 2;
	private static var ACTIVE_DURATION = 2;
}
