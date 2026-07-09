import SwiftUI

#if os(iOS)

import UIKit

/// Global entry point for controlling the default SwiftUI loader overlay.
@available(iOS, introduced: 18.0, message: "LoaderKitSwiftUI requires iOS 18 or later. Increase your app's minimum deployment target to iOS 18.")
@MainActor public let loader = Loader.shared

/// Controls the presentation state for the package's loader overlay.
@available(iOS, introduced: 18.0, message: "LoaderKitSwiftUI requires iOS 18 or later. Increase your app's minimum deployment target to iOS 18.")
@MainActor
public final class Loader: ObservableObject {
    public static let shared = Loader()

    @Published public private(set) var isPresented = false
    @Published public private(set) var message: String?

    private var swiftUIHostCount = 0
    private var uiKitPresenter: UIKitLoaderPresenter?

    private init() {}

    /// Configures a UIKit app to present the loader above the given scene.
    ///
    /// SwiftUI apps should use `.loaderHost()` instead.
    public func configure(windowScene: UIWindowScene) {
        uiKitPresenter = UIKitLoaderPresenter(windowScene: windowScene)

        if isPresented {
            uiKitPresenter?.show(loader: self)
        }
    }

    /// Shows the loader overlay with an optional message.
    public func show(message: String? = nil) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.message = message
            isPresented = true
        }

        if let uiKitPresenter {
            uiKitPresenter.show(loader: self)
        } else {
            warnIfNoHostIsConfigured()
        }
    }

    /// Hides the loader overlay.
    public func hide() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isPresented = false
            message = nil
        }

        uiKitPresenter?.hide()
    }

    fileprivate func registerSwiftUIHost() {
        swiftUIHostCount += 1
    }

    fileprivate func unregisterSwiftUIHost() {
        swiftUIHostCount = max(0, swiftUIHostCount - 1)
    }

    private func warnIfNoHostIsConfigured() {
        guard swiftUIHostCount == 0 else { return }

        #if DEBUG
        print("LoaderKitSwiftUI: No loader host configured. For SwiftUI use .loaderHost(). For UIKit call loader.configure(windowScene:).")
        #endif
    }
}

public extension View {
    /// Installs the loader overlay host for this view hierarchy.
    ///
    /// Add this once near your app's root view, then call `loader.show()` and
    /// `loader.hide()` from the main actor.
    @available(iOS, introduced: 18.0, message: "LoaderKitSwiftUI requires iOS 18 or later. Increase your app's minimum deployment target to iOS 18.")
    func loaderHost() -> some View {
        modifier(LoaderHostModifier(loader: loader))
    }
}

private struct LoaderHostModifier: ViewModifier {
    @ObservedObject var loader: Loader

    func body(content: Content) -> some View {
        ZStack {
            content

            if loader.isPresented {
                DefaultLoaderView(message: loader.message)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            loader.registerSwiftUIHost()
        }
        .onDisappear {
            loader.unregisterSwiftUIHost()
        }
    }
}

private struct DefaultLoaderView: View {
    let message: String?

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(.circular)

                if let message, !message.isEmpty {
                    Text(message)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.sRGB, white: 1, opacity: 0.95))
            )
            .foregroundColor(.primary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message ?? "Loading")
    }
}

private final class UIKitLoaderPresenter {
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
                DefaultLoaderView(message: loader.message)
            }
        }
    }
}

#endif
