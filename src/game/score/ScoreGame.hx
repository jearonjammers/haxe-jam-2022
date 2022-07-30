package game.score;

import flambe.display.Sprite;
import flambe.animation.Sine;
import flambe.animation.Ease;
import game.cafe.CafeGame;
import flambe.System;
import flambe.display.ImageSprite;
import flambe.display.FillSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class ScoreGame extends Component {
	public function new(pack:AssetPack, width:Float, height:Float) {
		this.init(pack, width, height);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	private function init(pack:AssetPack, width:Float, height:Float) {
		Audio.stop_();
		Audio.playSound_("sfx/win");
		var x = width / 2;
		var scoreTop:Sprite;
		var scoreBottom:Sprite;
		this._root = new Entity() //
			.add(new FillSprite(0xacdde5, width, height)) //
			.addChild(new Entity() //
				.add(new ImageSprite(pack.getTexture("score/scoreBottomBubble")) //
					.centerAnchor() //
					.setXY(x, 476))) //
			.addChild(new Entity() //
				.add(scoreBottom = new ImageSprite(pack.getTexture("score/scoreBottom")) //
					.centerAnchor() //
					.setXY(x, 356))) //
			.addChild(new Entity() //
				.add(new ImageSprite(pack.getTexture("score/scoreTopBubble")) //
					.centerAnchor() //
					.setXY(x, 923))) //
			.addChild(new Entity() //
				.add(scoreTop = new ImageSprite(pack.getTexture("score/scoreTop")) //
					.centerAnchor() //
					.setXY(x, 853))) //
			.add(_homeButton = new Button(pack, "homeButton", width - 121, 90)); //

		scoreTop.y.animateTo(753, 0.75, Ease.backOut);
		scoreTop.rotation.behavior = new Sine(-5, 5, 4);
		scoreTop.scaleX.behavior = new Sine(0.9, 1, 4);
		scoreTop.scaleY.behavior = new Sine(0.9, 1, 4);

		scoreBottom.y.animateTo(256, 0.5, Ease.backOut);
		scoreBottom.rotation.behavior = new Sine(5, -5, 4);
		scoreBottom.scaleX.behavior = new Sine(1, 0.9, 4);
		scoreBottom.scaleY.behavior = new Sine(1, 0.9, 4);
		scoreBottom.alpha._ = 0;

		_homeButton.click.connect(() -> {
			this.dispose();
			Audio.playSound_("click");
			System.root.get(DrinkPercent).reset();
			System.root.add(new CafeGame(pack, width, height));
		}).once();
	}

	private var _root:Entity;
	private var _homeButton:Button;
}
