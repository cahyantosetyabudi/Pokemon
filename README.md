## Pokemon
Simple ios application about Pokemon, where we can get list of pokemon card, search, get detail of pokemon card and also recommended another pokemon card.

## Specification
- Xcode 14.2
- Swift 5
- Minimum iOS 12.1
- Cocoapods

## Dependency
- Cocoapods: Dependency manager
- Moya: Create abstraction network layer to faster development process
- Kingfisher: Load images into UIKit from web with less effort
- RxSwift: Handle reactive paradigm between view controller and view model

## Architecture
- Using MVVM + RxSwift for presentation layer
- ViewController has responsibility handle logic UI and recevive input from user
- ViewModel has responsibility to communicate between ViewController and network service such as an API, also give data into ViewController using reactive paradigm
- Repository has responsibility to handle source of data that's needed for ViewController
- ViewModel, Repository using Protocol to abstraction layer so it's easier to maintain in case there are changes in future
- Using simple coordinator pattern to handle complex navigation in future

## How to run
- Clone project from repository
- Run command 'pod install' in root project directory
- Run command 'open Pokemons.xcworkspaces' in root project directory