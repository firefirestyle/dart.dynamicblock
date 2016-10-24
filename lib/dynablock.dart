library dynablock;

class DynaBlockCore {
  String rootID;
  List<FreeSpaceInfo> infos = [];
  int rootWidth = 0;
  int rootHeight = 0;
  bool useDebugLog;

  DynaBlockCore({this.rootWidth: 400, this.useDebugLog: true}) {
    infos.add(new FreeSpaceInfo()
      ..xs = 0
      ..y = 10
      ..xe = rootWidth);
  }

  FreeSpaceInfo addBlock(int elmW, int elmH) {
    (useDebugLog == true ? print("""\r\n\r\n## START call addBlock ${elmW} ${elmH} ##""") : null);
    //
    //
    FreeSpaceInfo info = null;
    for (int i = 0; i < infos.length; i++) {
      info = infos[i];
      var w = (info.xe - info.xs);
      if (w >= elmW) {
        (useDebugLog == true ? print("""    ## SELECT FREESPACEINFO ${info.toString()}""") : null);
        break;
      }
      info = null;
    }
    if (info == null) {
      // todo
      return null;
    }
    //
    updateIndex(info.xs, info.y, info.xs + elmW, info.y + elmH);

    if (useDebugLog) {
      for (var j in infos) {
        (useDebugLog == true ? print("""    ## INDEX: ${j.toString()}""") : null);
      }
    }
    return info;
  }

  updateIndex(int xs, int ys, int xe, int ye) {
    print("##> addInfo ${xs}, ${ys}, ${xe}, ${ye}");
    //
    // [width]
    bool added = false;
    {
      for (int i = 0; i < infos.length; i++) {
        var info = infos[i];
        if (!(info.y <= ye)) {
          print("##> none ${info.toString()}");
          continue;
        }
        if (info.xs <= xs && xs < info.xe) {
          // add
          print("##> in ${info.toString()}");
          if (added == false) {
            var v = new FreeSpaceInfo.fromPos(xe, ys, info.xe - xe, xs, xe);
            if (false == infos.contains(v)) {
              added = true;
              infos.add(v);
            }
          }
          {
            var base1 = new FreeSpaceInfo.clone(info);
            var base2 = new FreeSpaceInfo.clone(info);
            info.xs = info.xe = 0;
            base1.xe = xs;
            base2.xs = xe;
            if (base1.xs != base1.xe) {
              print("##> in a: ${base1.toString()}");
              if (false == infos.contains(base1)) {
                infos.add(base1);
              }
            }
            if (base2.xs != base2.xe) {
              print("##> in b:${base2.toString()}");
              if (false == infos.contains(base2)) {
                print("##> in bv:${base2.toString()}");
                infos.add(base2);
              }
            }
          }
        } else {
          print("##> ecase  ${info.toString()} ::${info.id} ${info.xs} <= ${xs} && ${xs} < ${info.xe}");
        }
      }
    }
    for (int i = 0; i < infos.length; i++) {
      var info = infos[i];
      if (info.xe <= info.xs) {
        print("##> delete ${info.toString()}");
        infos.remove(info);
        i--;
      }
    }
    //
    // [height] over
    {
      var head = new FreeSpaceInfo.fromPos(0, ye, rootWidth, xs, xe);
      print("##> heigh st ${head.toString()}");
      for (int i = 0; i < infos.length; i++) {
        var info = infos[i];
//s        print("##> heigh ${info.toString()}");
        if (info.y < head.y) {
          print("##> heigh cont ${info.toString()}");
          continue;
        }
        print("##> heigh fd ${info.toString()}");

        print("##> heigh c1 ${head.toString()}");
        if (info.baseXs < head.xs && head.xe < info.baseXe) {
          head = null;
          break;
        } else if (info.baseXs <= head.xs && head.xs <= info.baseXe) {
          head.xs = info.baseXe;
        } else if (info.baseXs <= head.xe && head.xe <= info.baseXe) {
          head.xe = info.baseXs;
        } else if (head.xs <= info.baseXs && info.baseXe <= head.xe) {
          if (info.baseXs <= head.baseXs) {
            head.xs = info.baseXe;
          } else {
            head.xe = info.baseXs;
          }
        }
        print("##> heigh c2 ${head.toString()}");
      }
      print("##> heigh c ${head.toString()}");
      //
      if (head != null) {
        infos.add(head);
      }
    }
    //
    // [sort] order high
    {
      infos.sort((FreeSpaceInfo a, FreeSpaceInfo b) {
        return a.y - b.y;
      });
    }
  }
}

class FreeSpaceInfo {
  int xs;
  int y;
  int xe;
  int id;
  static int idid = -1;
  int baseXs;
  int baseXe;
  FreeSpaceInfo() {
    id = idid++;
  }
  FreeSpaceInfo.clone(FreeSpaceInfo base) {
    this.xs = base.xs;
    this.y = base.y;
    this.xe = base.xe;
    this.baseXs = base.baseXs;
    this.baseXe = base.baseXe;
    id = idid++;
  }
  FreeSpaceInfo.fromPos(int x, int y, int width, this.baseXs, this.baseXe) {
    print("##> fromPos ${x},${y},${width}");
    id = idid++;
    this.xs = x;
    this.xe = x + width;
    this.y = y;
  }
  String toString() {
    return """[${id}] xs:xe=${xs}px,${xe}px; ys:${y}; ${baseXs}: ${baseXe}""";
  }

  bool operator ==(FreeSpaceInfo v) {
    return (xs == v.xs) && (xe == v.xe); //&& (y == v.y);// &&(baseXs == v.baseXs) &&(baseXe == v.baseXe);
  }
}
