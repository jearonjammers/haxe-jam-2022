package game.runner;

import game.cafe.CafeSun;
import game.score.ScoreGame;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Sequence;
import flambe.script.Script;
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
		_pack = pack;
		this.init(width, height);
	}

	override function onUpdate(dt:Float) {
		if (_hasLost || _hasFinishedWalking) {
			return;
		}

		var dp = System.root.get(DrinkPercent);
		var sc = System.root.get(OverallScore);
		if (dp.percent > 0) {
			dp.percent -= dt * 0.03;
			_drinkMeter.setFill(dp.percent);
		} else if (!_hasWon) {
			_hasWon = true;
			handleSuccess();
		}
		if (!_hasWon) {
			_distWorld += dt * 450;
		} else {
			_distWorld += dt * 225;
			_distPerson += dt * 225;
		}
		if (_person.movetype == Surf) {
			_surfDist += 10 * dt;
		}

		if (!_hasWon) {
			sc.scoreSecond._ = Math.floor(_distWorld / 80) + Math.floor(_surfDist);
		}

		_bg.setPercent(dp.percent);
		_floor.setPercent(dp.percent);
		_cloud1.rotation._ = 180 * Ease.sineOut(dp.percent);
		_cloud2.rotation._ = 180 * dp.percent;

		if (_distPerson < 690) {
			_sceneryBack.get(Sprite).x._ = -_distWorld;
			_sceneryMid.get(Sprite).x._ = -_distWorld;
			_sceneryFront.get(Sprite).x._ = -_distWorld;
			_personSpr.x._ = _distPerson;
		} else {
			_hasFinishedWalking = true;
			this._person.dispose();
			this._root.add(new Script()).get(Script).run(new Sequence([
				new Delay(1),
				new CallFunction(() -> {
					this.dispose();
					System.root.add(new CafeGame(_pack, 1920, 1080));
				})
			]));
		}
		handleEnemy(dt, dp.percent);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
		_disposer.dispose();
	}

	private inline function handleEnemy(dt:Float, percent:Float) {
		if (!_hasWon && !_hasLost && percent < 0.8) {
			_enemyElapsed += dt;
			if (_enemyElapsed >= _enemyDuration) {
				_enemyElapsed = 0;
				_enemyDuration = ENEMY_DUR_MIN + Math.random() * (ENEMY_DUR_MAX - ENEMY_DUR_MIN);
				var xpos = -_sceneryMid.get(Sprite).x._ + 2400;
				addEnemy(xpos);
			}
		}
	}

	private function handleSuccess() {
		_person.sturdy();
		_sun.owner.add(new CafeSun(_pack, 440, 90));
		_sun.dispose();
		var xpos = -_sceneryMid.get(Sprite).x._ + 1920;
		_sceneryMid.addChild(new Entity().add(new ImageSprite(_pack.getTexture("runner/job")).setXY(xpos, 403)));
	}

	private function init(width:Float, height:Float) {
		Audio.playMain_();
		var METER_Y = 180;
		_bg = new RGBSprite(235, 59, 36, 172, 221, 229, width, height);
		_floor = new RGBSprite(9, 87, 233, 204, 204, 204, width, height);
		this._root = new Entity();
		this._root //
			.add(_bg) //
			.addChild(_sceneryBack = new Entity().add(new Sprite()))
			.addChild(new Entity().add(_floor.setXY(0, height - 180))) //
			.addChild(new Entity().add(new FillSprite(0xffffff, width, 6).setXY(0, height - 186))) //
			.addChild(new Entity().add(_cloud1 = new ImageSprite(_pack.getTexture("cloud")) //
				.setRotation(180) //
				.setScale(0.7) //
				.setXY(1000, 280) //
				.centerAnchor())) //
			.addChild(new Entity().add(_cloud2 = new ImageSprite(_pack.getTexture("cloud")) //
				.setRotation(180) //
				.setXY(1400, 130) //
				.centerAnchor())) //
			.addChild(new Entity() //
				.add(_sun = new RunnerSun(_pack, 440, 90))) //
			.addChild(_sceneryMid = new Entity().add(new Sprite()))
			.add(_controlDesktop = new ControlDesktop())
			.addChild(new Entity() //
				.add(_personSpr = new Sprite()) //
				.add(_person = new Person(_pack))) //
			.addChild(_sceneryFront = new Entity().add(new Sprite()))
			.add(_homeButton = new Button(_pack, "homeButton", width - 121, 90)) //
			.add(_points = new Points(_pack, 1550, 49)) //
			.add(_drinkMeter = new Meter(_pack, 1760, METER_Y, "drinkFront", "drinkMid").show(true)); //

		_cloud1.x.behavior = new Sine(970, 1030, 4);
		_cloud1.y.behavior = new Sine(280, 250, 8);

		_cloud2.x.behavior = new Sine(1370, 1430, 4.5);
		_cloud2.y.behavior = new Sine(130, 100, 8.5);
		_disposer = new Disposer();
		_person.move(Walk);

		_disposer.add(System.root.get(OverallScore).scoreSecond.changed.connect((to, _) -> {
			_points.setScore(to + System.root.get(OverallScore).scoreFirst._);
		}));

		_disposer.add(_homeButton.click.connect(() -> {
			this.dispose();
			Audio.playSound_("click");
			System.root.get(DrinkPercent).reset();
			System.root.add(new CafeGame(_pack, width, height));
		}));

		_disposer.add(_person.hasFallen.connect(() -> {
			_hasLost = true;
			Audio.playSound_("sfx/cafe/partyHarder");
			var lostSpr = new ImageSprite(_pack.getTexture("runner/lost")).centerAnchor().setXY(1920 / 2, 1080);
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
					if (!_hasWon && !_hasLost) {
						var xpos = -_sceneryMid.get(Sprite).x._ + 680;
						var ypos = 940;
						_sceneryMid.addChild(new Entity().add(new ImageSprite(_pack.getTexture("runner/mess")).setScale(0.6).setXY(xpos, ypos)));
					}
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

		_sceneryMid.addChild(new Entity().add(new ImageSprite(_pack.getTexture("runner/bar")).setXY(300, 403)));
		addBushBack(900);
		addTreeBack(1600);
		addBushBack(2800);
		addBushBack(1600);
		addTreeBack(3800);
		addBushBack(5100);
		addTreeBack(7000);
		addBushBack(8100);
		addBushBack(11100);
		addTreeBack(13000);
		addBushBack(14100);
		addBushBack(15900);
		addBushFront(0);
		addBushFront(1800);
		addBushFront(4300);
		addBushFront(7300);
		addBushFront(13300);
	}

	private function addBushBack(xPos:Float) {
		_sceneryBack.addChild(new Entity().add(new Bush(_pack, xPos, 729)));
	}

	private function addBushFront(xPos:Float) {
		_sceneryFront.addChild(new Entity().add(new Bush(_pack, xPos, 929)));
	}

	private function addTreeBack(xPos:Float) {
		_sceneryBack.addChild(new Entity().add(new Tree(_pack, xPos, 620)));
	}

	private var _crouchIndex = 0;

	private function addBird(xPos:Float) {
		_sceneryMid.addChild(new Entity().add(new EnemyBird(_pack, _crouchIndex++, xPos, 525)));
	}

	private var _jumpIndex = 0;

	private function addWorm(xPos:Float) {
		_sceneryMid.addChild(new Entity().add(new EnemyWorm(_pack, _jumpIndex++, xPos, 985)));
	}

	private function addCar(xPos:Float) {
		_sceneryMid.addChild(new Entity().add(new EnemyCar(_pack, _jumpIndex++, xPos, 985)));
	}

	private function addEnemy(xPos:Float) {
		var type = Math.floor(Math.random() * 3);
		switch type {
			case 0:
				addWorm(xPos);
			case 1:
				addBird(xPos);
			case 2:
				addCar(xPos);
		}
	}

	private static inline var ENEMY_DUR_START = 0.5;
	private static inline var ENEMY_DUR_MIN = 2;
	private static inline var ENEMY_DUR_MAX = 6;

	private var _root:Entity;
	private var _bg:RGBSprite;
	private var _floor:RGBSprite;
	private var _enemyElapsed:Float = 0;
	private var _enemyDuration:Float = ENEMY_DUR_START;
	private var _distWorld:Float = 0;
	private var _distPerson:Float = 0;
	private var _hasLost:Bool = false;
	private var _hasWon:Bool = false;
	private var _hasFinishedWalking:Bool = false;
	private var _personSpr:Sprite;
	private var _cloud1:Sprite;
	private var _cloud2:Sprite;
	private var _sun:RunnerSun;
	private var _person:Person;
	private var _controlDesktop:ControlDesktop;
	private var _homeButton:Button;
	private var _sceneryBack:Entity;
	private var _sceneryMid:Entity;
	private var _sceneryFront:Entity;
	private var _drinkMeter:Meter;
	private var _pack:AssetPack;
	private var _points:Points;
	private var _surfDist:Float = 0;
	private var _disposer:Disposer;
}
