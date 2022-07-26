package game;

import flambe.Disposer;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

using game.ButtonUtil;

class PlayButton extends Component {
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
		var spr = new ImageSprite(pack.getTexture("playButton")).centerAnchor().setXY(1920 / 2, 800);
		this._root.add(spr);

		spr.addStates(() -> {
			trace("click");
		}, this._disposer);
	}

	private var _root:Entity;
	private var _disposer:Disposer;
}
