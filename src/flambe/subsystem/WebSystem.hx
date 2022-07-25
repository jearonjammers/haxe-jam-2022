//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt
package flambe.subsystem;

import flambe.web.WebView;

/**
 * Functions related to the environment's web browser.
 */
interface WebSystem {
	var stack(default, null):Array<WebView>;

	function addView(comp:VueComponent, methods:Dynamic, props:Dynamic):WebView;
}
