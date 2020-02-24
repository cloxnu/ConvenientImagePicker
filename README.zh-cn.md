![Header](Documentation/ConvenientHeader.png)

![ConvenientImagePicker](Documentation/picture.png)
# ConvenientImagePicker
**ConvenientImagePicker** 基于 Swift 语言开发，是一个用于 iOS 开发、简洁优美的图像选择器解决方案。它能让你轻松地在任何 `ViewController` 中呈现。它有出色的手势交互、近乎完美的视觉体验，并支持 iOS 13 深色模式。

<p align="center">
<a href="https://starkidstory.com"><img src="Documentation/starkidstorylogo_badge.png" height=20></a>
<a href="https://github.com/CLOXnu/ConvenientImagePicker"><img src="Documentation/convenientlogo_badge.png" height=20/></a>
<br/>
<a href="https://cocoapods.org/pods/ConvenientImagePicker"><img src="https://img.shields.io/cocoapods/v/ConvenientImagePicker.svg?style=flat"/></a>
<a href="https://cocoapods.org/pods/ConvenientImagePicker"><img src="https://img.shields.io/cocoapods/l/ConvenientImagePicker.svg?style=flat"/></a>
<a href="https://cocoapods.org/pods/ConvenientImagePicker"><img src="https://img.shields.io/cocoapods/p/ConvenientImagePicker.svg?style=flat"/></a>
<img src="https://img.shields.io/badge/Xcode-9.0%2B-blue.svg"/>
<img src="https://img.shields.io/badge/iOS-8.0%2B-blue.svg"/>
<img src="https://img.shields.io/badge/Swift-4.0%2B-orange.svg"/>
<a href="https://github.com/CLOXnu/ConvenientImagePicker/blob/master/README.zh-cn.md"><img src="https://img.shields.io/badge/%E4%B8%AD%E6%96%87-README-blue.svg?style=flat"/></a>
</p>

## Release Notes

the newest version is 0.2.2, Add `assetsSortKey` and `assetsSortAscending` property, the order of pictures is now customizable! thanks for @Édouard. More information see [Release Notes](ReleaseNotes.md).

## 概览

**ConvenientImagePicker** 有顺滑出色的手势交互、近乎完美的视觉体验，它不仅能选择系统相册，还能显示自定义图片。

值得强调的是，**ConvenientImagePicker** 有精确的手势控制，深受大众的酷爱。

![Overview](Documentation/overview.GIF)![Detailview](Documentation/detailview.GIF)

## 版本要求

- iOS 9.3+
- Xcode 9.0+
- Swift 4.0+

## 安装

**ConvenientImagePicker** 可以通过 [CocoaPods](http://cocoapods.org) 安装, 在你的 `Podfile` 文件中加入:

```ruby
pod 'ConvenientImagePicker'
```

然后运行 `pod install` 就大功告成啦，

在你需要的地方加上

```swift
import ConvenientImagePicker
```

来导入它。

## 用法

当你想要使用图像选择器时，假设你写了个方法可以实现这个功能，这个方法如下：

```swift
func PresentPhotoPicker()
```

紧接着，你在这个方法里写了下面这些语句，这是使用图像选择器选择相册图片最简单的版本：

```swift
let pickerViewController = PickerViewController()
pickerViewController.delegate = self
pickerViewController.isSupportLandscape = true // A Boolean value that determines whether the ability of landscape exists.
self.present(pickerViewController, animated: true, completion: nil)
```

最后一步，在你的父视图控制器（ViewController）中实现 ```ConvenientImagePickerDelegate``` 代理:

并实现这些代理方法:

```swift
func imagePickerDidCancel(_ selectedImages: [Int : UIImage])
func imageDidSelect(_ imagePicker: PickerViewController, index: Int, image: UIImage?)
func imageDidDeselect(_ imagePicker: PickerViewController, index: Int, image: UIImage?)
func imageSelectMax(_ imagePicker: PickerViewController, wantToSelectIndex: Int, wantToSelectImage: UIImage?)
```

这些代理方法在以下情景会触发：

当用户退出了图像选择器 ```imagePickerDidCancel``` 将会触发并返回用户选择的图片。

当用户每选择了一张图片 ```imageDidSelect``` 将会触发并返回用户选择的图片。

当用户每取消选择了一张图片 ```imageDidDeselect``` 将会触发并返回用户取消选择的图片。

当用户想要选择一张图片，但是图片选择数量已达上限时，```imageSelectMax``` 将会触发。

---

你可以在后三个代理方法中调用 ```imagePicker.selectedImageCount``` 来得到用户当前选择图片的数量。

不要试图在方法 `PresentPhotoPicker` 外初始化 `pickerViewController`，即每次显示图像选择器时在显示方法内操作。

## 更多配置

当然，你还可以使用这个图像选择器更多特性，甚至自定义它的样子。

让我们从这里 ```let pickerViewController = PickerViewController()``` 开始:

```swift
pickerViewController.maxNumberOfSelectedImage = 50 // The maximum number of pictures allowed.
pickerViewController.allowMultipleSelection = true // A Boolean value that determines whether the picker view can mutiple selection.
pickerViewController.numberOfPictureInRow = 4 // The number of pictures in a row.
pickerViewController.intervalOfPictures = 5.0 // The interval between pictures.
pickerViewController.isSimpleMode = true // A Boolean value that determines whether the title label, count view, and close button exist.
pickerViewController.images = nil // The displayed images, it's will be photo library if nil.
pickerViewController.isDarkMode = false // A Boolean value that determines whether darkmode enable.
pickerViewController.isSwitchDarkAutomately = true // A Boolean value that determines whether darkmode can switched automately. (only iOS 13 valid)
pickerViewController.initialSelectedIndex = [0,1,2,3,4] // A set of index of selected image when the picker appears.
pickerViewController.isAnimated = true // A Boolean value that determines whether the appear animation exists.
pickerViewController.customSelectedImage // A selectedImage type value that relates to the image of selected picture.
pickerViewController.isSupportLandscape = true // A Boolean value that determines whether the ability of landscape exists.
pickerViewController.assetsSortKey = "modificationDate" // A String value that determines whether the order key of all assets.
pickerViewController.assetsSortAscending = false // A Boolean value that determines whether the order way of all assets.
```

### 当 'isSimpleMode = false'

<img src="https://github.com/CLOXnu/ConvenientImagePicker/blob/master/Documentation/simpleMode=false.png" alt="simpleMode=false" align="right" width="200"/>

当你配置了 `pickerViewController.isSimpleMode = false`，你可以来了解下 `titleView`, `titleLabel`, `countLabel`, `doneButton`, 和 `titleViewEffectView`，以备自定义界面。（如右图所示）

除此之外，你还可以在任意时候自定义 ```titleViewEffectView```, ```mainView```, 和 ```collectionView```, 因为不管你的配置是什么，它们永远存在。

`decorationBar` 只能在 `isSimpleMode = true` 时才能自定义。

如果你想要在 `PickerViewController` 内写你想要的方法，`extension PickerViewController`是必要的。

## ⚠️注意

* 如果你想要选择相册里的照片的话，别忘了在你的 Info.plist 文件里加 ```NSPhotoLibraryUsageDescription```。
* 使用前，请确认该 App 是否有可读相册权限。
* 每当你想要显示新的图片选择器时，请重新初始化新的 `pickerViewController` ，别用以前的。

## 实例

这个已上架的 App [「文字卡片」](https://apps.apple.com/cn/app/%E6%96%87%E5%AD%97%E5%8D%A1%E7%89%87/id1473078157)，使用了该库 **ConvenientImagePicker**。

<img src="Documentation/TextBoxIconNew.png" alt="TextBoxIconNew" width="100"/>

<img src="Documentation/instance.jpg" alt="instance" width="300"/>


## 许可

**ConvenientImagePicker** 根据 MIT 许可证发布。详见 [LICENSE](LICENSE.md)。

感谢您的支持！🙏


