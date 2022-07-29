package game.runner;

import flambe.animation.Sine;
import flambe.animation.Ease;
import game.cafe.CafeGame;
import flambe.System;
import flambe.Disposer;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.FillSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class RunnerGame extends Component {
	public function new(pack:AssetPack, width:Float, height:Float) {
		this.init(pack, width, height);
	}

	override function onUpdate(dt:Float) {
		if (_hasLost) {
			return;
		}
		_elapsed += dt;
		_sceneryBack.get(Sprite).x._ = -_elapsed * 450;
		_sceneryMid.get(Sprite).x._ = -_elapsed * 450;
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
		_disposer.dispose();
	}

	private function init(pack:AssetPack, width:Float, height:Float) {
		var METER_Y = 180;
		this._root = new Entity();
		this._root //
			.add(new FillSprite(0xEB3B24, width, height)) //
			.addChild(_sceneryBack = new Entity().add(new Sprite()))
			.addChild(new Entity().add(new FillSprite(0x0957E9, width, 180).setXY(0, height - 180))) //
			.addChild(new Entity().add(new FillSprite(0xffffff, width, 6).setXY(0, height - 186))) //
			.add(new RunnerSun(pack)) //
			.addChild(_sceneryMid = new Entity().add(new Sprite()))
			.add(_controlDesktop = new ControlDesktop())
			.add(_person = new Person(pack)) //
			.add(_homeButton = new Button(pack, "homeButton", width - 121, 90)) //
			.add(new Meter(pack, 1760, METER_Y, "drinkFront", "drinkMid").show(true)); //

		_sceneryBack.add(new Bush(pack, 1400, 729));
		_sceneryMid.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/bar")).setXY(300, 403)));
		_disposer = new Disposer();
		_person.move(Walk);

		_disposer.add(_homeButton.click.connect(() -> {
			this.dispose();
			System.root.add(new RunnerGame(pack, width, height));
		}));

		_disposer.add(_person.hasFallen.connect(() -> {
			_hasLost = true;
			var lostSpr = new ImageSprite(pack.getTexture("runner/lost")).centerAnchor().setXY(1920 / 2, 1080);
			lostSpr.y.animateTo(1080 / 2, 0.5, Ease.backOut);
			lostSpr.rotation.behavior = new Sine(-5, 5, 4);
			lostSpr.scaleX.behavior = new Sine(0.9, 1, 4);
			lostSpr.scaleY.behavior = new Sine(0.9, 1, 4);
			this._root.addChild(new Entity().add(lostSpr));
		}).once());

		_disposer.add(_controlDesktop.state.changed.connect((s, _) -> {
			switch [s, _person.movetype] {
				// request jump
				case [Up, Jump]: // ignore if in jump state
				case [Up, Surf]: // ignore if in surf state
				case [Up, Crouch]: // ignore if in crouch state
				case [Up, _]:
					_person.move(Jump);
				// request surf
				case [Right, Jump]: // ignore if in jump state
				case [Right, Surf]: // ignore if in surf state
				case [Right, Crouch]: // ignore if in crouch state
				case [Right, _]:
					_person.move(Surf);
				// request crouch
				case [Down, Jump]: // ignore if in jump state
				case [Down, Surf]: // ignore if in surf state
				case [Down, Crouch]: // ignore if in crouch state
				case [Down, _]:
					_person.move(Crouch);
				// request walk lean forward
				case [Space, Jump]: // ignore if in jump state
				case [Space, Surf]: // ignore if in surf state
				case [Space, Crouch]: // ignore if in crouch state
				case [Space, _]:
					_person.move(Walk);
				// request walk lean backwards
				case [Idle, Jump]: // ignore if in jump state
				case [Idle, Surf]: // ignore if in surf state
				case [Idle, Crouch]: // ignore if in crouch state
				case [Idle, _]:
					_person.move(Walk);
			}

			switch [s] {
				// request walk lean forward
				case [Space]: // ignore if in jump state
					_person.press();
				// request walk lean backwards
				case [Idle]: // ignore if in jump state
					_person.lift();
				case _:
			}
		}));
	}

	private var _root:Entity;
	private var _elapsed:Float = 0;
	private var _hasLost:Bool = false;
	private var _person:Person;
	private var _controlDesktop:ControlDesktop;
	private var _homeButton:Button;
	private var _sceneryBack:Entity;
	private var _sceneryMid:Entity;
	private var _disposer:Disposer;
}
