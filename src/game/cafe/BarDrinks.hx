package game.cafe;

import flambe.input.PointerEvent;
import flambe.Disposer;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

using game.SpriteUtil;

class BarDrinks extends Component {
	public function new(pack:AssetPack) {
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
		this._disposer.dispose();
	}

	public function init(pack:AssetPack) {
		this._root = new Entity();
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
			var drink = new BarDrink(pack, pos.x, pos.y);
			var e = new Entity().add(drink);
			drink.turnOff();
			_slots.push(drink);
			this._root.addChild(e);
		}

		function onSlot(e:PointerEvent) {
			if (System.pointer.isDown()) {
				for (slot in _slots) {
					slot.handPos(e.viewX, e.viewY);
				}
			}
		}

		_disposer.add(System.pointer.move.connect(onSlot));
		_disposer.add(System.pointer.down.connect(onSlot));

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

