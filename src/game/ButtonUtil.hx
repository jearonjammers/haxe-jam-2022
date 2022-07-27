package game;

import flambe.System;
import flambe.display.Sprite;
import flambe.Disposer;

class ButtonUtil {
	public static function addStates(sprite:Sprite, onClick:Void->Void, ?disposer:Null<Disposer> = null):Disposer {
		if (disposer == null) {
			disposer = new Disposer();
		}
		var isDown = false;

		disposer.add(sprite.pointerIn.connect(_ -> {
			sprite.setScale(1.05);
		}));

		disposer.add(sprite.pointerOut.connect(_ -> {
			sprite.setScale(1);
		}));

		disposer.add(sprite.pointerDown.connect(_ -> {
			sprite.setScale(0.95);
			isDown = true;
		}));

		disposer.add(System.pointer.up.connect(e -> {
			sprite.setScale(1);
			if (isDown && e.hit == sprite) {
				isDown = false;
				onClick();
			}
		}));

		return disposer;
	}
}
