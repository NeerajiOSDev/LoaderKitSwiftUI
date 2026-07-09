import SwiftUI

#if os(iOS)

import UIKit

@MainActor
final class UIKitLoaderPresenter {
    private weak var windowScene: UIWindowScene?
    private var window: UIWindow?

    init(windowScene: UIWindowScene) {
        self.windowScene = windowScene
    }

    func show(loader: Loader) {
        guard let windowScene else { return }

        if window == nil {
            let hostingController = UIHostingController(rootView: UIKitLoaderHostView(loader: loader))
            hostingController.view.backgroundColor = .clear

            let window = UIWindow(windowScene: windowScene)
            window.windowLevel = .alert + 1
            window.backgroundColor = .clear
            window.rootViewController = hostingController

            self.window = window
        }

        window?.isHidden = false
    }

    func hide() {
        window?.isHidden = true
        window = nil
    }
}

private struct UIKitLoaderHostView: View {
    @ObservedObject var loader: Loader

    var body: some View {
        Group {
            if loader.isPresented {
                SimpleLoaderView(
                    type: loader.selectedType,
                    message: loader.message,
                    loaderColor: loader.loaderColor,
                    messageColor: loader.messageColor
                )
            }
        }
    }
}

#endif
