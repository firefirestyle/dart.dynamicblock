library dynablock_html;

import 'dynablock.dart' as dynablock;
import 'dart:html' as html;
import 'dart:async';

class DynaView {
  String rootId;
  dynablock.DynaBlockCore core = null;
  DynaView({this.rootId: "fire-listcontainer"}){
  }

  updateSize() {
      var rootElm = html.document.body.querySelector("#${rootId}");
      core = new dynablock.DynaBlockCore(rootWidth: rootElm.clientWidth);
  }
  Future addWithLoading(html.Element elm) async {
    var rootElm = html.document.body.querySelector("#${rootId}");
    rootElm.style.position = "relative";
    rootElm.children.add(elm);
    //
    html.ElementList<html.ImageElement> imgs = html.document.querySelectorAll("img");
    Completer c = new Completer();
    bool isA = false;
    if (imgs.length > 0) {
      imgs.onLoad.listen((ev) {
        if (isA == false) {
          _add(elm);
          c.complete();
          isA = true;
        }
      });
    } else {
      _add(elm);
      c.complete();
    }
    return c.future;
  }
  _add(html.Element elm) {
    if(core == null) {
      updateSize();
    }
    dynablock.FreeSpaceInfo info = core.addBlock(elm.clientWidth+25, elm.clientHeight+25);
    elm.style.position = "absolute";
    elm.style.left = "${info.xs}px";
    elm.style.top = "${info.y}px";
  }
}
