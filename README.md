## Telebu Chat

![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/Language-Swift-orange.svg)

Telebu Chat is a chatting application created for demo purposes.

## Demo
<img src="https://media.giphy.com/media/kagevHs5ihfK6kwKal/giphy.gif" width="250" height="500" />

## Features

- [x] Chat bubbles
- [x] Reverse Pagination
- [x] Emoji reaction view
- [x] Emoji animation
- [x] Offline support
- [x] Unit Tests

### Cool Features

- [x] Tap on reaction button to see emoji view
- [x] Emojis animate when a pan gesture is applied on them
- [x] Haptic feedback as user pans through emojis

## Requirements

- iOS 14.0+
- Xcode 12+
- Swift 5+

## Design Pattern: Clean Architecture Repository Pattern
is a structural design pattern that priovides abstarction to concrete implementation:
- #### Models 
  - hold application data. They’re usually structs or simple classes.
- #### Scenes 
  - display visual elements and controls on the screen. They’re typically subclasses of UIView.
- #### View models
  - transform model information into values that can be displayed on a view. They’re usually classes, so they can be passed around as references.
- #### Repository
  - provides a layer of abstraction so the implemetation is hidden from implementor e.g viewModel uses a reposiotry protocl to fetch data without knowing the source of the data is coming from either an api or database.

## Dependencies

- None 😉

## Installation

- Just clone this repo and open the project folder's .xcodeProj file.

### Improvements

- The emoji container view can use a collectionView instead of a stackView to support more items and scrolling. However the concept and proof of knowledge due to time constraint has been demonstrated using a stackView with five emojis same as of facebook messenger.
