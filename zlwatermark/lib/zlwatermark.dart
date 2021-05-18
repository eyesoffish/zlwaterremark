library zlwatermark;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ZLWaterView extends StatefulWidget {
  final Widget child;
  final Size? size;
  final List<Widget>? children;
  const ZLWaterView({Key? key, required this.child, this.size, this.children}) : super(key: key);

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
    if(widget.size != null) {
      deleChildList.add(SizedBox(
          width: widget.size!.width,
          height: widget.size!.height,
          child: widget.child,
        )
      );
    } else {
      deleChildList.add(widget.child);
    }
    if(widget.children != null) {
      widget.children!.forEach((element) { 
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Size _size = box.size;
        deleChildList.add(
          _WaterWidget(child: element, maxSize: _size, key: ValueKey("${widget.children!.indexOf(element)}water"), onClose: () {
            _deleteChildren("${widget.children!.indexOf(element)}water");
            widget.children!.removeAt(widget.children!.indexOf(element));
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
  final Size maxSize;
  const _WaterWidget({Key? key, required this.child, required this.maxSize, this.onClose}) : super(key: key);
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
            final RenderBox box = context.findRenderObject() as RenderBox;
            final Size _size = box.size;
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
            /// 边距判定
            double _currWith = _size.width * scale;
            double _currHeight = _size.height * scale;
            if(left < 0) left = 0;
            if(top < 0) top = 0;
            if(left > widget.maxSize.width - _currWith) left = widget.maxSize.width - _currWith;
            if(top > widget.maxSize.height - _currHeight) top = widget.maxSize.height - _currHeight;
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
