library dynablock_html;

import 'dynablock.dart' as dynablock;
import 'dart:html' as html;
import 'dart:async';

class DynaHtmlView {
  List<String> rootId;
  dynablock.DynaBlockCore core = null;
  int margineW;
  int margineH;
  DynaHtmlView({this.rootId: const["fire-listcontainer"],this.margineW:15,this.margineH:15}){
    //updateSize();
  }
  getRootElm() {
    var parent = html.document.body;
    for(String id in this.rootId) {
      parent = parent.querySelector("#${id}");
    }
    return parent;
  }
  updateSize() {
      var rootElm = getRootElm();
      if(rootElm != null) {
        core = new dynablock.DynaBlockCore(rootWidth: rootElm.clientWidth);
     }
  }

  dynablock.FreeSpaceInfo add(html.Element elm) {
    var rootElm = getRootElm();
    rootElm.style.position = "relative";
    if(false == rootElm.contains(elm)) {
      rootElm.children.add(elm);
    }
    if(core == null) {
      updateSize();
    }
    dynablock.FreeSpaceInfo info = core.addBlock(elm.clientWidth+margineW, elm.clientHeight+margineH);
    elm.style.position = "absolute";
    elm.style.left = "${info.xs}px";
    elm.style.top = "${info.y}px";
    return info;
  }
}

class DynaViewHelper {
  //
  // todo
  Future<html.Element> waitByOnLoadImg(html.Element elm) async {
    //
    html.ElementList<html.ImageElement> imgs = html.document.querySelectorAll("img");
    Completer c = new Completer();
    bool isA = false;
    if (imgs.length > 0) {
      imgs.onLoad.listen((ev) {
        if (isA == false) {
          c.complete(elm);
          isA = true;
        }
      });
    } else {
      c.complete(elm);
    }
    return c.future;
  }
}
