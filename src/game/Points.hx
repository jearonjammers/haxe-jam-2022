package game;

import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Points extends Component {
	public function new(pack:AssetPack, x:Float, y:Float) {
		this.init(pack, x, y);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function setScore(score:Int):Void {
		if (score < 10) {
			this._text.text = "00" + score;
		} else if (score < 100) {
			this._text.text = "0" + score;
		} else {
			this._text.text = "" + score;
		}
	}

	private function init(pack:AssetPack, x:Float, y:Float) {
		var font = new Font(pack, "testfont");
		this._text = new TextSprite(font, "000");

		this._root = new Entity() //
			.add(new ImageSprite(pack.getTexture("points")).setXY(x, y)) //
			.addChild(new Entity().add(_text.setScale(1.7).setXY(37, 0))); //
	}

	private var _root:Entity;
	private var _text:TextSprite;
}
