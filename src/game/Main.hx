package game;

import game.score.ScoreGame;
import flambe.web.WebView;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.System;
import game.cafe.CafeGame;
import game.text.TextGame;
import game.runner.RunnerGame;

class Main {
	static function main() {
		System.init();
	}

	public static var vueSplash = js.Lib.require("./src/components/Splash.vue");

	@:expose static function start(width:Int, height:Int):Void {
		var container = new Container(width, height);
		container.visible = false;
		System.root.add(container);
		System.root.add(new DrinkPercent());
		System.root.add(new OverallScore());
		System.stage.resize.connect(() -> {
			container.setSize(System.stage.width, System.stage.height);
		});
		System.stage.resize.emit();
		var bootstrap = Manifest.fromAssets("bootstrap");
		System.loadAssetPack(bootstrap).success.connect(onDevRunner.bind(width, height)).once();
	}

	static function onDevText(width:Int, height:Int, pack:AssetPack):Void {
		var loader = new Loader(pack, width, height);
		System.root.add(loader);
		System.root.get(Container).visible = true;
		var main = Manifest.fromAssets("main");
		System.loadAssetPack(main).success.connect(mainPack -> {
			loader.dispose();
			System.root.add(new TextGame(mainPack, width, height));
		}).once();
	}

	static function onDevScore(width:Int, height:Int, pack:AssetPack):Void {
		var loader = new Loader(pack, width, height);
		System.root.add(loader);
		System.root.get(Container).visible = true;
		var main = Manifest.fromAssets("main");
		System.loadAssetPack(main).success.connect(mainPack -> {
			loader.dispose();
			System.root.add(new ScoreGame(mainPack, width, height));
		}).once();
	}

	static function onDevRunner(width:Int, height:Int, pack:AssetPack):Void {
		var loader = new Loader(pack, width, height);
		System.root.add(loader);
		System.root.get(Container).visible = true;
		var main = Manifest.fromAssets("main");
		System.loadAssetPack(main).success.connect(mainPack -> {
			loader.dispose();
			System.root.add(new RunnerGame(mainPack, width, height));
		}).once();
	}

	static function onDevCafe(width:Int, height:Int, pack:AssetPack):Void {
		var loader = new Loader(pack, width, height);
		System.root.add(loader);
		System.root.get(Container).visible = true;
		var main = Manifest.fromAssets("main");
		System.loadAssetPack(main).success.connect(mainPack -> {
			loader.dispose();
			System.root.add(new CafeGame(mainPack, width, height));
		}).once();
	}

	static function onBootstrapLoaded(width:Int, height:Int, pack:AssetPack):Void {
		var splash:WebView = null;
		splash = System.web.addView(vueSplash, {
			onClick: () -> {
				// initialize audio
				pack.getSound("silence").play();
				// remove splash screen
				splash.dispose();
				var loader = new Loader(pack, width, height);

				System.root.add(loader);
				// show game container
				System.root.get(Container).visible = true;
				// load Main
				var main = Manifest.fromAssets("main");
				System.loadAssetPack(main).success.connect(mainPack -> {
					loader.dispose();
					System.root.add(new CafeGame(mainPack, width, height));
				}).once();
			}
		}, {width: width, height: height});
	}
}
