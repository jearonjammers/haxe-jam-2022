package game.runner;

import flambe.animation.Sine;
import flambe.math.Rectangle;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class EnemyWorm extends Component {
	public function new(pack:AssetPack, x:Float, y:Float) {
		this.init(pack, x, y);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	private function init(pack:AssetPack, x:Float, y:Float) {
		var anchorX = 77;
		var anchorY = 230;
		var tex = pack.getTexture("runner/puke/worm");
		this._root = new Entity() //
			.add(new Sprite().setXY(x, y)) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/puke/wormHole")) //
				.centerAnchor())) //
			.addChild(new Entity() //
				.add(_clip = new Sprite()) //
				.addChild(new Entity().add(_worm = new ImageSprite(pack.getTexture("runner/puke/worm")) //
					.setAnchor(anchorX, anchorY)))) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/puke/wormHoleClip")) //
				.setAnchor(128.5, -11))); //
		_clip.scissor = new Rectangle(-(anchorX + PADDING), -(anchorY + PADDING), tex.width + PADDING * 2, (tex.height + PADDING) - CLIP_LENGTH);

		_worm.y.behavior = new Sine(0, 300, 2);
		_worm.rotation.behavior = new Sine(-15, 15, 1);
	}

	private var _root:Entity;
	private var _clip:Sprite;
	private var _worm:Sprite;

	private static inline var PADDING = 60;
	private static inline var CLIP_LENGTH = 30;
}
