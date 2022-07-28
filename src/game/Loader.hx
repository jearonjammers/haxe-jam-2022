package game;

import flambe.animation.Sine;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.Disposer;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Loader extends Component {
	public function new(pack:AssetPack, width:Int, height:Int) {
		this.init(pack, width, height);
	}

	override public function onAdded() {
		this.owner.addChild(this._root);
	}

	override public function onRemoved() {
		this.owner.removeChild(this._root);
		this._disposer.dispose();
	}

	private function init(pack:AssetPack, width:Int, height:Int) {
		this._disposer = new Disposer();
		this._root = new Entity();

		this._root //
			.add(new ImageSprite(pack.getTexture("loadingBack"))) //
			.add(new LoaderBall(pack, width, height));
	}

	private var _root:Entity;
	private var _disposer:Disposer;
}

class LoaderBall extends Component {
	public function new(pack:AssetPack, width:Int, height:Int) {
		this.init(pack, width, height);
	}

	override public function onAdded() {
		this.owner.addChild(this._root);
	}

	override public function onRemoved() {
		this.owner.removeChild(this._root);
	}

	private function init(pack:AssetPack, width:Int, height:Int) {
		var BALL_X = 898;
		var BALL_Y = 786;
		var BALL_X_MOVE = 50;
		var BALL_Y_MOVE = 10;
		this._root = new Entity();
		var rootSpr = new Sprite().setXY(BALL_X, BALL_Y);
		this._root.add(rootSpr);
		var lineSpr = new ImageSprite(pack.getTexture("ballLineWater"));
		var ballSpr = new ImageSprite(pack.getTexture("ball")).centerAnchor().setXY(75, -250);
		this._root.addChild(new Entity().add(ballSpr));
		this._root.addChild(new Entity().add(lineSpr));
		ballSpr.rotation.behavior = new Sine(-10, 10, 4);
		rootSpr.x.behavior = new Sine(BALL_X - BALL_X_MOVE, BALL_X + BALL_X_MOVE, 4);
		rootSpr.y.behavior = new Sine(BALL_Y, BALL_Y + BALL_Y_MOVE, 2);
	}

	private var _root:Entity;
}
