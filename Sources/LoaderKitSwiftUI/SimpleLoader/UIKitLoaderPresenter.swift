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

            let window = PassthroughWindow(windowScene: windowScene)
            window.windowLevel = .alert + 1
            window.backgroundColor = .clear
            window.rootViewController = hostingController

            self.window = window
        }

        if let window = window as? PassthroughWindow {
            window.allowsInteraction = loader.allowsInteraction
        }

        window?.isHidden = false
    }

    func hide() {
        window?.isHidden = true
        window = nil
    }
}

private final class PassthroughWindow: UIWindow {
    var allowsInteraction = false

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        allowsInteraction ? nil : super.hitTest(point, with: event)
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
                    messageColor: loader.messageColor,
                    size: loader.size,
                    backgroundOpacity: loader.backgroundOpacity
                )
            }
        }
    }
}

#endif
