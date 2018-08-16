# SideViewManager

[![CI Status](http://img.shields.io/travis/AndrewBoryk/SideViewManager.svg?style=flat)](https://travis-ci.org/AndrewBoryk/SideViewManager)
[![Version](https://img.shields.io/cocoapods/v/SideViewManager.svg?style=flat)](http://cocoapods.org/pods/SideViewManager)
[![License](https://img.shields.io/cocoapods/l/SideViewManager.svg?style=flat)](http://cocoapods.org/pods/SideViewManager)
[![Platform](https://img.shields.io/cocoapods/p/SideViewManager.svg?style=flat)](http://cocoapods.org/pods/SideViewManager)

## Description

`SideViewManager` enables developers the ability to add swipe in/out functionality to a view in 1 line using 1 dependency. `SideViewManager` allows the frames for on and off screen to be customizable, so that the position of "on" and "off" can defined by the developer. In addition, there are gestures for swiping the view on and off screen as well as tap away to dismiss the view.

## Table of Contents
* [Description](#description)
* [Example](#example)
* [Requirements](#requirements)
* [Features](#features)
* [Future Features](#future-features)
* [Installation](#installation)
* [Usage](#usage)
* [Delegate](#delegate)
* [Author](#author)
* [License](#license)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* Requires iOS 8.0 or later
* Requires Automatic Reference Counting (ARC)

## Features

* Swipe view on and off screen
* Custom on and off positions
* Tap to dismiss
* Manual presentation and dismissal
* Delegate to listen for movement of the `SideView`

## Future Features

- Open an issue to begin the discussion about features to add. I'd like this pod to be lightweight, but also versatile.

## Installation

SideViewManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SideViewManager'
```

You can add import SideViewManager to your classes with the following line:

```swift
import SideViewManager
```

## Usage

### Initialization

There are two ways to initialize a `SideViewManager`, either with a `UIViewController` (the manager will cooperate with the controller's `view`) or with a `UIView`. Then, the view must also be given an `endingFrame` and `startingFrame`. These frames basically specify the two positions that the screen transitions between.

```swift

let startingFrame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
let endingFrame = self.view.frame

// Initialize with controller
let sideController = UIViewController()
let manager = SideViewManager(controller: sideController, startingFrame: startingFrame, endingFrame: endingFrame)

// Initialize with view
let sideView = UIView()
let manager = SideViewManager(view: sideView, startingFrame: startingFrame, endingFrame: endingFrame)

```

There are gestures available for swiping the view on and off screen, as well as tapping away the view to dismiss it. These values should be set after your view has appeared, so preferrably in your `viewDidAppear(anaimated:)` function.

```swift

// Allows the view to be swipable between on and off frames
manager.setSwipeGesture(isEnabled: true)

// Allows the view to be tapped to dismiss
manager.setDismissGesture(isEnabled: true)

```

Then, the next step is you can set the `swipeDirection` on your `SideViewManager` instance in order to specify the direction that swiping the screen on and off screen can work. SideViewManager's swipe gesture is bi-directional, so the swipe direction is either `.horizontal` (left and right) or `.vertical` (up and down). By default the `swipeDirection` is horizontal.

```swift

manager.swipeDirection = .horizontal
manager.swipeDirection = .vertical

```

Lastly, in terms of usage, there are functions to manually present and dismiss the SideView, as well as manually set the offset of the SideView.

```swift

// Presents the sideView with an animation speed of 1 second. 
// By default, the animation speed is 0.25. 
// To remove animation set the animationDuration value to 0.
manager.present(animationDuration: 1.0)

// Dismisses the sideView with an animation speed of 0.5 seconds. 
// By default, the animation speed is 0.25.
// To remove animation set the animationDuration value to 0.
manager.dismiss(animationDuration: 0.5)

// Moves the sideView off screen (0 is off-screen, 1 is on-screeen, 0.5 is halfway, etc.)
// Set the duration of time it takes to move the sideView to this position.
manager.move(to: 0.0, duration: 1.0)

```

## Delegate

There are two delegate methods for listening to changes to the `SideViewManager`

```swift

// The SideViewManager did finish moving to a given offset, where 0 is off-screen, 1 is on-screen, and values can vary between 0 and 1.
func didFinishAnimating(to offset: CGFloat)

/// Listen for whether a gesture (dismiss or swipe) in the SideViewManager has been enabled/disabled
func didChange(gesture: UIGestureRecognizer, to isEnabled: Bool)

```

## Author

Andrew Boryk, andrewcboryk@gmail.com

Reach out to me on Twitter: [@TrepIsLife](https://twitter.com/TrepIsLife) [![alt text][1.2]][1]

[1.2]: http://i.imgur.com/wWzX9uB.png (twitter icon without padding)
[1]: http://www.twitter.com/TrepIsLife

## License

SideViewManager is available under the MIT license. See the LICENSE file for more info.
