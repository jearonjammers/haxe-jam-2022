package game;

import flambe.display.Sprite;
import flambe.animation.Sine;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Background extends Component {
	public function new(pack:AssetPack) {
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function init(pack:AssetPack) {
		this._root = new Entity();
		this._root.add(new ImageSprite(pack.getTexture("mainBack")));
		this._title = new Entity().add(new ImageSprite(pack.getTexture("title")).setXY(390, 179));

		var CLOUD_X_DIST = 30;
		var CLOUD_Y_DIST = 15;
		var CLOUD_TIME = 5;

		this._flamingo = new ImageSprite(pack.getTexture("flamingo")).setXY(1131, 594);
		this._flamingo.x.behavior = new Sine(1131 - CLOUD_X_DIST, 1131 + CLOUD_X_DIST, CLOUD_TIME);
		this._flamingo.rotation.behavior = new Sine(-5, 5, CLOUD_TIME * 2);

		var cloud1 = new ImageSprite(pack.getTexture("cloud")).setXY(0, 54);
		var cloud2 = new ImageSprite(pack.getTexture("cloud")).setXY(1039, 168);
		var cloud3 = new ImageSprite(pack.getTexture("cloud")).setXY(1340, 51);

		cloud1.x.behavior = new Sine(-CLOUD_X_DIST, CLOUD_X_DIST, CLOUD_TIME);
		cloud1.y.behavior = new Sine(54 - CLOUD_Y_DIST, 54 + CLOUD_Y_DIST, CLOUD_TIME * 2);
		cloud2.x.behavior = new Sine(1039 - CLOUD_X_DIST, 1039 + CLOUD_X_DIST, CLOUD_TIME);
		cloud2.y.behavior = new Sine(168 - CLOUD_Y_DIST, 168 + CLOUD_Y_DIST, CLOUD_TIME * 2);
		cloud3.x.behavior = new Sine(1340 - CLOUD_X_DIST, 1340 + CLOUD_X_DIST, CLOUD_TIME);
		cloud3.y.behavior = new Sine(51 - CLOUD_Y_DIST, 51 + CLOUD_Y_DIST, CLOUD_TIME * 2);

		this._root //
			.addChild(new Entity().add(cloud1))
			.addChild(new Entity().add(cloud2))
			.addChild(new Entity().add(cloud3))
			.addChild(this._title) //
			.addChild(new Entity().add(this._flamingo)); //
	}

	private var _root:Entity;
	private var _title:Entity;
	private var _flamingo:Sprite;
}