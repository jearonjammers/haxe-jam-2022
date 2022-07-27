package game.cafe;

import flambe.Disposer;
import flambe.util.Value;
import flambe.System;
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

class BarDrinks extends Component {
	public function new(pack:AssetPack, arms:ThirstyArms) {
		this.init(pack, arms);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
		this._disposer.dispose();
	}

	public function init(pack:AssetPack, arms:ThirstyArms) {
		this._root = new Entity();
		this._disposer = new Disposer();
		_slots = [];
		var bottlePositions = [
			{x: 406, y: 885},
			{x: 573, y: 913},
			{x: 810, y: 895},
			{x: 1200, y: 927},
			{x: 1516, y: 907}
		];
		for (i in 0...bottlePositions.length) {
			var pos = bottlePositions[i];
			var drink = new BarDrink(pack, pos.x, pos.y, arms);
			var e = new Entity().add(drink);
			drink.turnOff();
			_slots.push(drink);
			this._root.addChild(e);
		}

		_disposer.add(System.pointer.move.connect(e -> {
			if (System.pointer.isDown()) {
				for (slot in _slots) {
					slot.handPos(e.viewX, e.viewY);
				}
			}
		}));

		_slots[0].show(true);
		_slots[1].show(true);
		_slots[2].show(true);
		_slots[3].show(true);
		_slots[4].show(true);
	}

	private var _root:Entity;
	private var _disposer:Disposer;
	private var _slots:Array<BarDrink>;
}

enum BarDrinkState {
	Destroyed(ref:{time:Float});
	Idle;
	Sliding;
	Active(ref:{time:Float});
	Off;
}

class BarDrink extends Component {
	public var state(default, null):Value<BarDrinkState>;

	public function new(pack:AssetPack, x:Float, y:Float, arms:ThirstyArms) {
		this.state = new Value(Off);
		this.init(pack, x, y, arms);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	override function onUpdate(dt:Float) {
		switch this.state._ {
			case Destroyed(ref):
				ref.time += dt;
				if (ref.time >= DESTROYED_DURATION) {
					this.show(true);
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
		var local = rootSpr.localXY(viewX, viewY);

		if (isHit(local.x, local.y)) {
			this.toss();
		}
		return false;
	}

	private inline function isHit(x:Float, y:Float):Bool {
		var rootSpr = this._root.get(Sprite);
		var x1 = 0;
		var y1 = 0;

		var x2 = x1 + rootSpr.getNaturalWidth();
		var y2 = y1 + rootSpr.getNaturalHeight();

		return x1 <= x && x <= x2 && y1 <= y && y <= y2;
	}

	private function init(pack:AssetPack, x:Float, y:Float, arms:ThirstyArms) {
		this._arms = arms;
		this._root = new Entity();
		var tex = pack.getTexture("beerStar");
		this._anchorX = tex.width / 2;
		this._anchorY = tex.height - 10;
		var spr = new ImageSprite(tex).setAnchor(_anchorX, _anchorY).setXY(x, y + _anchorY / 2);
		_root.add(spr);
	}

	public function show(instant:Bool) {
		var spr = this._root.get(Sprite);
		var isLeft = spr.x._ < 1920 / 2;
		spr.anchorX._ = isLeft ? 2000 : -2000;
		spr.anchorY._ = _anchorY;
		this.state._ = Sliding;
		if (instant) {
			this.state._ = Idle;
			spr.anchorX._ = this._anchorX;
		} else {
			this._root.add(new Script()).get(Script).run(new Sequence([
				new AnimateTo(spr.anchorX, _anchorX, 0.666, Ease.cubeOut),
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

	public function grab() {
		this.state._ = Active({time: 0});
		var spr = this._root.get(Sprite);
	}

	public function toss() {
		this.state._ = Destroyed({time: 0});
		var spr = this._root.get(Sprite);
		var x = Math.random() > 0.5 ? -500 : 500;
		spr.anchorX.animateTo(x, 0.3333, Ease.sineIn);
		spr.anchorY.animateTo(1350, 0.3333, Ease.sineOut);
	}

	private var _root:Entity;
	private var _anchorX:Float;
	private var _anchorY:Float;
	private var _arms:ThirstyArms;

	private static var DESTROYED_DURATION = 2;
	private static var ACTIVE_DURATION = 2;
}
