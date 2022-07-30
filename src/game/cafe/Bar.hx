package game.cafe;

import flambe.display.Sprite;
import flambe.input.PointerEvent;
import flambe.Disposer;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

using game.SpriteUtil;

class Bar extends Component {
	public var drink:Null<BarDrink> = null;
	public var liquid:Liquid;

	public function new(pack:AssetPack, liquid:Liquid, game:CafeGame) {
		this.liquid = liquid;
		this.init(pack, game);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
		this._disposer.dispose();
	}

	public function toss() {
		for (slot in _slots) {
			slot.toss();
		}
		this.drink = null;
	}

	override function onUpdate(dt:Float) {
		if (System.pointer.isDown()) {
			var point = this._root.get(Sprite).localXY(System.pointer.x, System.pointer.y);
			for (slot in _slots) {
				var isTouching = slot.isHit(point.x, point.y);
				if (isTouching) {
					switch slot.state._ {
						case Destroyed(ref):
						case Idle:
							if (this.drink != slot) {
								if (this.drink != null) {
									this.drink.toss();
								}
								this.drink = slot;
								this.drink.grab(point.x, point.y);
								this.liquid.visible = true;
								this.liquid.setXY(point.x, point.y, this.drink.rotation, 230);
							}
						case Sliding:
						case Active(ref):
							slot.moveTo(point.x, point.y);
							this.liquid.setXY(point.x, point.y, this.drink.rotation, 230);
						case Off:
					}
				} else {
					if (this.drink != null) {
						this.drink.moveTo(point.x, point.y);
					}
				}
			}
		}
	}

	private function init(pack:AssetPack, game:CafeGame) {
		this._root = new Entity().add(new Sprite());
		this._disposer = new Disposer();
		_slots = [];
		var offset = 100;
		var bottlePositions = [
			{x: 406, y: 885 + offset},
			{x: 573, y: 913 + offset},
			{x: 810, y: 895 + offset},
			{x: 1200, y: 927 + offset},
			{x: 1516, y: 907 + offset}
		];
		for (i in 0...bottlePositions.length) {
			var pos = bottlePositions[i];
			var drink = new BarDrink(pack, pos.x, pos.y, this, game);
			var e = new Entity().add(drink);
			drink.turnOff();
			_slots.push(drink);
			this._root.addChild(e);
		}

		_disposer.add(System.pointer.up.connect(_ -> {
			if (this.drink != null) {
				this.drink.toss();
				this.liquid.visible = false;
				this.drink = null;
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
