# zlwatermark

flutter 添加水印

## Usage

```dart
ZLWaterView(
    child: SizedBox(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Image.asset("assets/gallery3.jpg", fit: BoxFit.cover,)
    ),
    children: [
        /// text 
        /// image
        Text("我是文字水印"),
        Image.assets("assets/图片水印.png")
    ],
),
```
