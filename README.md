# DynamicOverlay

<H4 align="center">
DynamicOverlay is a SwiftUI library. It makes easier to develop overlay based interfaces, such as the one presented in the Apple Maps, Stocks or Shortcuts apps.
</H4>

[![Version](https://img.shields.io/cocoapods/v/DynamicOverlay.svg?style=flat)](https://cocoapods.org/pods/DynamicOverlay)
[![License](https://img.shields.io/cocoapods/l/DynamicOverlay.svg?style=flat)](https://cocoapods.org/pods/DynamicOverlay)
<!-- [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) -->
<!-- [![Platform](https://img.shields.io/cocoapods/p/DynamicOverlay.svg?style=flat)](https://cocoapods.org/pods/DynamicOverlay) -->
<!-- [![Build Status](https://github.com/fabernovel/DynamicOverlay/workflows/CI/badge.svg?branch=master)](https://github.com/fabernovel/DynamicOverlay/actions) -->

- [Requirements](#requirements)
- [Getting started](#getting-started)
- [Magnetic notch overlay](#magnetic-notch-overlay)
  - [Specifying the notches](#specifying-the-notches)
  - [Drag gesture support](#drag-gesture-support)
  - [Scroll view support](#scroll-view-support)
  - [Responding to overlay update](#responding-to-overlay-update)
  - [Moving the overlay](#moving-the-overlay)
  - [Disabling notches](#disabling-notches)
  - [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Package Manager](#swift-package-manager)
- [Under the hood](#under-the-hood)
- [Author](#author)
- [License](#license)

## Requirements

`DynamicOverlay` is written in Swift 5. Compatible with iOS 13.0+.

## Getting started

You add a dynamic overlay as a regular one using a dedicated view modifier:

```swift
Color.blue.dynamicOverlay(Color.red)
```
You can modify its default behavior using the `dynamicOverlayBehavior(_:)` view modifier.

```swift
Color.blue
    .dynamicOverlay(Color.red)
    .dynamicOverlayBehavior(myOverlayBehavior())

func myOverlayBehavior() -> some DynamicOverlayBehavior {
    ...
}
```

## Magnetic notch overlay

`MagneticNotchOverlayBehavior` is a `DynamicOverlayBehavior` instance. It is the only behavior available for now.

It describes an overlay that can be dragged up and down alongside predefined notches. Whenever a drag gesture ends, the overlay motion will continue until it reaches one of its notches. 

### Specifying the notches

The preferred way to define the notches of a magnetic notch overlay is to declare an `CaseIterable` enum:

```swift
enum Notch: CaseIterable, Equatable {
    case min, max
}
```
You specify the dimensions of each notch when you create a  `MagneticNotchOverlayBehavior`  instance:

```swift
@State var isCompact = false

MagneticNotchOverlayBehavior<Notch> { notch in
    switch notch {
    case .max:
        return isCompact ? .fractional(0.5) : .fractional(0.8)
    case .min:
        return .fractional(0.3)
    }
}
```
There are two kinds of dimension:
```swift
extension NotchDimension {

    /// Creates a dimension with an absolute point value.
    static func absolute(_ value: Double) -> NotchDimension

    /// Creates a dimension that is computed as a fraction of the height of the overlay parent view.
    static func fractional(_ value: Double) -> NotchDimension
}
```
### Drag gesture support

By default, all the content of the overlay is draggable but you can limit this behavior using the `draggable`  view modifier.

Here only the table view header is draggable:

```swift
var body: some View {
    Color.green
        .dynamicOverlay(myOverlayContent())
        .dynamicOverlayBehavior(myOverlayBehavior())
}

func myOverlayContent() -> some View {
    VStack {
        Text("Header").draggable()
        List {
            Text("Row 1")
            Text("Row 2")
            Text("Row 3")
        }
    }
}

func myOverlayBehavior() -> some DynamicOverlayBehavior {
    MagneticNotchOverlayBehavior<Notch> { ... }
}
```
Here we disable the drag gesture:
```swift
func myOverlayContent() -> some View {
    VStack {
        Text("Header")
        List {
            Text("Row 1")
            Text("Row 2")
            Text("Row 3")
        }
    }
    .draggable(false)
}
```

### Scroll view support

A magnetic notch overlay can coordinate its motion with the scrolling of a scroll view. 

Mark a view of the overlay content as a `drivingScrollView` to do so.

```swift
func myOverlayContent() -> some View {
    VStack {
        Text("Header").draggable()
        List {
            Text("Row 1")
            Text("Row 2")
            Text("Row 3")
        }
        .drivingScrollView()
    }
}
```

### Responding to overlay update

You can track the overlay motions using the `onTranslation(_:)` view modifier. It is a great occasion to update the UI according to the current overlay state.

Here we define a control that should be right above the overlay:

```swift
struct ControlView: View {

    let height: CGFloat
    let action: () -> Void

    var body: some View {
        VStack {
            Button("Action", action: action)
            Spacer().frame(height: height)
        }
    }
}
```
We make sure the control is always visible thanks to the translation parameter:

```swift
@State var height: CGFloat = 0.0

var body: some View {
    ZStack {
        Color.blue
        ControlView(height: height, action: {})
    }
    .dynamicOverlay(Color.red)
    .dynamicOverlayBehavior(myOverlayBehavior())
}

func myOverlayBehavior() -> some DynamicOverlayBehavior {
    MagneticNotchOverlayBehavior<Notch> { ... }
    .onTranslation { translation in
        height = translation.height
    }
}
```
You can also be notified when a notch is reached using a binding:
```swift
@State var notch: Notch = .min

var body: some View {
    Color.blue
        .dynamicOverlay(Text("\(notch)"))
        .dynamicOverlayBehavior(myOverlayBehavior())
}

func myOverlayBehavior() -> some DynamicOverlayBehavior {
    MagneticNotchOverlayBehavior<Notch> { ... }
    .notchChange($notch)
}
```

### Moving the overlay

You can move explicitly the overlay using a notch binding.

```swift
@State var notch: Notch = .min

var body: some View {
    ZStack {
        Color.green
        Button("Move to top") {
            notch = .max
        }
    }
    .dynamicOverlay(Color.red)
    .dynamicOverlayBehavior(myOverlayBehavior())
}

func myOverlayBehavior() -> some DynamicOverlayBehavior {
    MagneticNotchOverlayBehavior<Notch> { ... }
    .notchChange($notch)
}
```
Wrap the change in an animation block to animate the change.

```swift
Button("Move to top") {
    withAnimation {
        notch = .max
    }
}
```

### Disabling notches

When a notch is disabled, the overlay will ignore it. Here we block the overlay in its `min` position:

```swift
@State var notch: Notch = .max

func myOverlayBehavior() -> some DynamicOverlayBehavior {
    MagneticNotchOverlayBehavior<Notch> { ... }
    .notchChange($notch)
    .disable(.max, notch == .min)
}
```

## Under the hood

`DynamicOverlay` is built on top of [OverlayContainer](https://github.com/applidium/OverlayContainer). If you need more control, consider using it or open an issue.

## Installation

`DynamicOverlay` is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

### Cocoapods

```ruby
pod 'DynamicOverlay'
```

### Carthage

Add the following to your Cartfile:

```ruby
github "https://github.com/fabernovel/DynamicOverlay"
```

### Swift Package Manager

`DynamicOverlay` can be installed as a Swift Package with Xcode 11 or higher. To install it, add a package using Xcode or a dependency to your Package.swift file:

```swift
.package(url: "https://github.com/fabernovel/DynamicOverlay.git")
```

## Author

[@gaetanzanella](https://twitter.com/gaetanzanella), gaetan.zanella@fabernovel.com

## License

`DynamicOverlay` is available under the MIT license. See the LICENSE file for more info.
