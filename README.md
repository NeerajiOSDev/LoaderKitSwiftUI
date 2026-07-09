# LoaderKitSwiftUI

LoaderKitSwiftUI is a lightweight iOS loader package for SwiftUI and UIKit apps. Add one setup point, then show or hide a transparent loader overlay from anywhere in your app.

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

## Loader Methods

Show the default simple loader:

```swift
loader.show()
```

Show the simple loader with a message:

```swift
loader.show(
    type: .simpleLoaderWithMessage,
    message: "Please wait"
)
```

For convenience, passing a message also chooses `.simpleLoaderWithMessage`:

```swift
loader.show(message: "Please wait")
```

Hide the loader:

```swift
loader.hide()
```

Customize the simple loader color in SwiftUI:

```swift
loader.show(
    type: .simpleLoader,
    loaderColor: .blue
)
```

Customize the loader color and message color when showing a message:

```swift
loader.show(
    type: .simpleLoaderWithMessage,
    message: "Loading data...",
    loaderColor: .blue,
    messageColor: .gray
)
```

UIKit projects can use `UIColor`:

```swift
loader.show(
    type: .simpleLoaderWithMessage,
    message: "Loading data...",
    loaderUIColor: .systemBlue,
    messageUIColor: .darkGray
)
```

Available loader types:

```swift
.simpleLoader
.simpleLoaderWithMessage
```

The default overlay background is transparent, so the loader appears above the current screen without dimming or covering the UI with a card background.

## Xcode Previews

`loader.show()` depends on runtime hosting:

- SwiftUI apps need `.loaderHost()` installed in the active view hierarchy.
- UIKit apps need an active `UIWindowScene` passed to `loader.configure(windowScene:)`.

Because Xcode Previews do not always run with the same app scene/window lifecycle as the simulator or a real device, the global loader may not appear reliably in Preview. Test loader behavior on the iOS Simulator or a real iPhone/iPad for accurate results.
