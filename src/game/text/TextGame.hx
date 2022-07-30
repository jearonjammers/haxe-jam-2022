package game.text;

import flambe.System;
import game.runner.RunnerGame;
import flambe.script.CallFunction;
import flambe.animation.Ease;
import flambe.script.AnimateTo;
import flambe.script.Parallel;
import flambe.script.Delay;
import flambe.script.Sequence;
import flambe.script.Script;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.FillSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class TextGame extends Component {
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
		this._root = new Entity();
		this._root.add(new FillSprite(0x000000, width, height));
		this._root.addChild(new Entity().add(_phone = new ImageSprite(pack.getTexture("text/phone")).centerAnchor()));
		_phone.setXY(1810, 935);
		Audio.playSound_("sfx/text/passOut");

		var offset = 550;
		var Y_0 = 250 + offset;
		var Y_1 = 80 + offset;
		var Y_2 = -250 + offset;
		var Y_3 = -643 + offset;
		var Y_4 = -1030 + offset;

		var x = 320;
		this._root //
			.addChild(new Entity().add(_texts = new Sprite().setXY(x, Y_0))
				.addChild(new Entity().add(_text1 = new ImageSprite(pack.getTexture("text/text1")).setXY(0, 0))) //
				.addChild(new Entity().add(_text2 = new ImageSprite(pack.getTexture("text/text2")).setXY(0, 330))) //
				.addChild(new Entity().add(_text3 = new ImageSprite(pack.getTexture("text/text3")).setXY(0, 712))) //
				.addChild(new Entity().add(_text4 = new ImageSprite(pack.getTexture("text/text4")).setXY(0, 1100)))); //
		_text1.alpha._ = 0;
		_text2.alpha._ = 0;
		_text3.alpha._ = 0;
		_text4.alpha._ = 0;
		this._root.add(new Script()).get(Script).run(new Sequence([
			new Delay(1),
			new CallFunction(() -> {
				// Audio.playSound_("sfx/text/vibrate");
			}),
			new Sequence([
				new AnimateTo(_phone.rotation, -5, 0.125),
				new AnimateTo(_phone.rotation, 5, 0.125),
				new AnimateTo(_phone.rotation, 0, 0.125),
			]),
			new CallFunction(() -> {
				Audio.playSound_("sfx/text/bing");
			}),
			new Parallel([
				new AnimateTo(_text1.alpha, 1, 0.5),
				new AnimateTo(_texts.y, Y_1, 0.5, Ease.backOut)
			]),
			new Delay(2.5),
			new CallFunction(() -> {
				// Audio.playSound_("sfx/text/vibrate");
			}),
			new Sequence([
				new AnimateTo(_phone.rotation, -5, 0.125),
				new AnimateTo(_phone.rotation, 5, 0.125),
				new AnimateTo(_phone.rotation, 0, 0.125),
			]),
			new CallFunction(() -> {
				Audio.playSound_("sfx/text/bing");
			}),
			new Parallel([
				new AnimateTo(_text2.alpha, 1, 0.5),
				new AnimateTo(_texts.y, Y_2, 0.5, Ease.backOut)
			]),
			new Delay(2.5),
			new CallFunction(() -> {
				// Audio.playSound_("sfx/text/vibrate");
			}),
			new Sequence([
				new AnimateTo(_phone.rotation, -5, 0.125),
				new AnimateTo(_phone.rotation, 5, 0.125),
				new AnimateTo(_phone.rotation, 0, 0.125),
			]),
			new CallFunction(() -> {
				Audio.playSound_("sfx/text/bing");
			}),
			new Parallel([
				new AnimateTo(_text3.alpha, 1, 0.5),
				new AnimateTo(_texts.y, Y_3, 0.5, Ease.backOut)
			]),
			new Delay(2.5),
			new CallFunction(() -> {
				// Audio.playSound_("sfx/text/vibrate");
			}),
			new Sequence([
				new AnimateTo(_phone.rotation, -5, 0.125),
				new AnimateTo(_phone.rotation, 5, 0.125),
				new AnimateTo(_phone.rotation, 0, 0.125),
			]),
			new CallFunction(() -> {
				Audio.playSound_("sfx/text/bing");
			}),
			new Parallel([
				new AnimateTo(_text4.alpha, 1, 0.5),
				new AnimateTo(_texts.y, Y_4, 0.5, Ease.backOut)
			]),
			new Delay(2.5),
			new CallFunction(() -> {
				this.dispose();
				System.root.add(new RunnerGame(pack, 1920, 1080));
			})
		]));
	}

	private var _root:Entity;
	private var _phone:Sprite;
	private var _texts:Sprite;
	private var _text1:Sprite;
	private var _text2:Sprite;
	private var _text3:Sprite;
	private var _text4:Sprite;
}
