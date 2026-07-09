# LoaderKitSwiftUI

LoaderKitSwiftUI is a small package for showing and hiding a common loader overlay from anywhere in an iOS app. It supports SwiftUI apps and UIKit apps.

## Requirements

- iOS 18.0 or later
- SwiftUI or UIKit

This package is iOS-only for iPhone and iPad apps. If an app has a deployment target below iOS 18, Swift Package Manager will reject the package because `Package.swift` declares `.iOS(.v18)`.

Set your app's minimum deployment target to iOS 18 or later before adding this package.

## SwiftUI Usage

Install the loader host once near your app's root view:

```swift
import LoaderKitSwiftUI
import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .loaderHost()
        }
    }
}
```

## UIKit Usage

Configure the loader once with your app's active `UIWindowScene`:

```swift
import LoaderKitSwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        loader.configure(windowScene: windowScene)
    }
}
```

For SwiftUI app lifecycle projects that still use UIKit screens, configure it from the root SwiftUI scene with `.loaderHost()` instead, or pass the active `UIWindowScene` to `loader.configure(windowScene:)` from your UIKit setup.

## Showing And Hiding

Show and hide the loader from the main actor:

```swift
loader.show()
loader.hide()
```

You can also show a message:

```swift
loader.show(message: "Please wait")
```
