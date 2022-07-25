//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt
package flambe.platform;

import flambe.subsystem.WebSystem;
import flambe.util.Assert;
import flambe.web.WebView;

class DummyWeb implements WebSystem {
	public var stack(default, null):Array<WebView>;

	public function new() {
		this.stack = [];
	}

	public function addView(component:String, methods:Array<VueMethod>, data:Array<VueData>, props:Array<VueProps>):WebView {
		Assert.fail("Web.createView is unsupported in this environment, check the `supported` flag.");
		return null;
	}

	public function addDef(name:String, def:Dynamic):WebView {
		return null;
	}
}
