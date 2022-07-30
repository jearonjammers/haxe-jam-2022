package game.runner;

import flambe.System;
import flambe.animation.Sine;
import flambe.math.Rectangle;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class EnemyWorm extends Component {
	public function new(pack:AssetPack, index:Int, x:Float, y:Float) {
		this.init(pack, index, x, y);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	override function onUpdate(dt:Float) {
		_elapsed += dt;
		if (_elapsed > 7) {
			this.owner.dispose();
		}
	}

	private function init(pack:AssetPack, index:Int, x:Float, y:Float) {
		Audio.playSound_("sfx/runner/worm");
		var anchorX = 77;
		var anchorY = 230;
		var tex = pack.getTexture("runner/worm/worm");
		this._root = new Entity() //
			.add(new Sprite().setXY(x, y)) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/worm/wormHole")) //
				.centerAnchor())) //
			.addChild(new Entity() //
				.add(_clip = new Sprite()) //
				.addChild(new Entity().add(_worm = new ImageSprite(pack.getTexture("runner/worm/worm")) //
					.setAnchor(anchorX, anchorY)))) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/worm/wormHoleClip")) //
				.setAnchor(128.5, -11))); //
		_clip.scissor = new Rectangle(-(anchorX + PADDING), -(anchorY + PADDING), tex.width + PADDING * 2, (tex.height + PADDING) - CLIP_LENGTH);

		_worm.y.behavior = new Sine(0, 300, 2);
		_worm.rotation.behavior = new Sine(-15, 15, 1);

		if (index == 0) {
			this._root.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/instructJump")).setXY(-220, -470)));
		}
	}

	private var _root:Entity;
	private var _clip:Sprite;
	private var _worm:Sprite;
	private var _elapsed = 0.0;

	private static inline var PADDING = 60;
	private static inline var CLIP_LENGTH = 30;
}
