package game;

import flambe.animation.Sine;
import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;

class Spinner extends Component {
	public function new(logo :Texture):Void {
		this._root = new Entity();
		var spr = new ImageSprite(logo);
        spr.centerAnchor();
		spr.setScale(2.5);
		spr.x.behavior = new Sine(150, 300, 1.5);
		spr.y.behavior = new Sine(0, 900, 2);
		this._root.add(spr);
	}

	override public function onAdded():Void {
		this.owner.addChild(this._root);
	}

	override public function onRemoved():Void {
		this.owner.removeChild(this._root);
	}

    override function onUpdate(dt:Float) {
        this._root.get(Sprite).rotation._ += dt * 60;
    }

	private var _root:Entity;
}
