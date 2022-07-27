package game.cafe;

import flambe.animation.Ease;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class BarDrinks extends Component {
	public function new(pack:AssetPack) {
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function addItem(slotIndex:Int):Void {
		var slot = _slots[slotIndex];
		var spr = slot.get(Sprite);
		spr.anchorX._ = slotIndex > 2 ? -2000 : 2000;
		spr.anchorX.animateTo(this._anchorX, 0.666, Ease.cubeOut);
		slot.get(Sprite).visible = true;
	}

	public function init(pack:AssetPack) {
		this._root = new Entity();
		_slots = [];
		var bottlePositions = [
			{x: 406, y: 885},
			{x: 573, y: 913},
			{x: 810, y: 895},
			{x: 1200, y: 927},
			{x: 1516, y: 907}
		];
		var tex = pack.getTexture("beerStar");
		for (i in 0...bottlePositions.length) {
			var pos = bottlePositions[i];
			this._anchorX = tex.width / 2;
			var anchorY = tex.height - 10;
			var e = new Entity().add(new Sprite().setAnchor(this._anchorX, anchorY).setXY(pos.x, pos.y + anchorY / 2));
			e.addChild(new Entity().add(new ImageSprite(tex)));
			e.get(Sprite).visible = false;
			_slots.push(e);
			this._root.addChild(e);
		}
		addItem(0);
		addItem(1);
		addItem(4);
	}

	private var _root:Entity;
	private var _slots:Array<Entity>;
	private var _anchorX:Float = 0;
}
