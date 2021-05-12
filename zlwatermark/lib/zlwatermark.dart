library zlwatermark;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ZLWaterView extends StatefulWidget {
  final Widget child;
  final List<Widget>? children;
  const ZLWaterView({Key? key, required this.child, this.children}) : super(key: key);

  @override
  _ZLWaterViewState createState() => _ZLWaterViewState();
}

class _ZLWaterViewState extends State<ZLWaterView> {

  List<Widget> deleChildList = [];
  @override
  void initState() {
    super.initState();
    _createChildren();
  }

  @override
  void didUpdateWidget(covariant ZLWaterView oldWidget) {
    if(widget.children != null) {
      if((deleChildList.length - 1) != widget.children!.length || deleChildList.length == 0) {
        _createChildren();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _createChildren() {
    deleChildList.clear();
    deleChildList.add(widget.child);
    if(widget.children != null) {
      widget.children!.forEach((element) { 
        deleChildList.add(
          _WaterWidget(child: element, key: ValueKey("${widget.children!.indexOf(element)}water"), onClose: () {
            _deleteChildren("${widget.children!.indexOf(element)}water");
          },)
        );
      });
    }
    if(mounted) setState(() {});
  }

  void _deleteChildren(String key) {
    deleChildList.removeWhere((element) => element.key == ValueKey(key));
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: deleChildList,
    );
  }
}


class _WaterWidget extends StatefulWidget {
  final Widget child;
  final Function()? onClose;
  const _WaterWidget({Key? key, required this.child, this.onClose}) : super(key: key);
  @override
  _WaterWidgetState createState() => _WaterWidgetState();
}

class _WaterWidgetState extends State<_WaterWidget> {
  
  double top = 0;
  double left = 0;
  double rotation = 0;
  double scale = 1;
  Offset _lastOffset = Offset.zero;
  double _lastScale = 1;
  double _lastRotation = 0;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        transform: Matrix4.rotationZ(rotation).scaled(scale),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onClose,
          onScaleStart: (scaleStartDetail) {
            _lastOffset = scaleStartDetail.focalPoint;
          },
          onScaleUpdate: (scaleUpdateDetail) {
            if(scaleUpdateDetail.pointerCount > 1) {
              scale += scaleUpdateDetail.scale - _lastScale;
              rotation += scaleUpdateDetail.rotation - _lastRotation;
            } else {
              left += scaleUpdateDetail.focalPoint.dx - _lastOffset.dx;
              top += scaleUpdateDetail.focalPoint.dy - _lastOffset.dy;
              _lastOffset = scaleUpdateDetail.focalPoint;
            }
            _lastScale = scaleUpdateDetail.scale;
            _lastRotation = scaleUpdateDetail.rotation;
            setState(() {});
          },
          onScaleEnd: (scaleEndDetail) {
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
