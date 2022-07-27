package game.cafe;

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
	}

	public function showItem(slotIndex:Int, instant:Bool):Void {
		var slot = _slots[slotIndex];
		slot.show(instant);
	}

	public function init(pack:AssetPack, arms:ThirstyArms) {
		this._root = new Entity();
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
			drink.hide();
			_slots.push(drink);
			this._root.addChild(e);
		}
		showItem(0, true);
		showItem(1, true);
		showItem(4, true);
	}

	private var _root:Entity;
	private var _slots:Array<BarDrink>;
}

class BarDrink extends Component {
	public var isAvailable(default, null):Bool;

	public function new(pack:AssetPack, x:Float, y:Float, arms:ThirstyArms) {
		this.isAvailable = true;
		this.init(pack, x, y, arms);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	override function onUpdate(dt:Float) {
		if (this.isAvailable && System.pointer.isDown()) {
			var vX = System.pointer.x;
			var vY = System.pointer.y;
			handPos(vX, vY);
		}
	}

	private function handPos(viewX:Float, viewY:Float):Bool {
		var rootSpr = this._root.get(Sprite);
		var local = rootSpr.localXY(viewX, viewY);

		if (isHit(local.x, local.y)) {
			// trace("hit");
		} else {}
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
		var anchorY = tex.height - 10;
		var spr = new ImageSprite(tex).setAnchor(_anchorX, anchorY).setXY(x, y + anchorY / 2);
		_root.add(spr);
	}

	public function show(instant:Bool) {
		var spr = this._root.get(Sprite);
		if (instant) {
			this.isAvailable = true;
			spr.anchorX._ = this._anchorX;
		} else {
			this._root.add(new Script()).get(Script).run(new Sequence([
				new AnimateTo(spr.anchorX, _anchorX, 0.666, Ease.cubeOut),
				new CallFunction(() -> {
					this.isAvailable = true;
				})
			]));
		}
		spr.visible = true;
	}

	public function hide() {
		this.isAvailable = false;
		var spr = this._root.get(Sprite);
		spr.visible = false;
		var isLeft = spr.x._ < 1920 / 2;
		spr.anchorX._ = isLeft ? 2000 : -2000;
	}

	public function fly() {
		this.isAvailable = false;
		var spr = this._root.get(Sprite);
		spr.visible = false;
		var isLeft = spr.x._ < 1920 / 2;
		spr.anchorX._ = isLeft ? 2000 : -2000;
	}

	private var _root:Entity;
	private var _anchorX:Float;
	private var _arms:ThirstyArms;
}
