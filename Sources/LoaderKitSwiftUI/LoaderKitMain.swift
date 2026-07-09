import SwiftUI

#if os(iOS)

import UIKit

/// Global entry point for controlling the selected loader overlay.
@available(iOS, introduced: 18.0, message: "LoaderKitSwiftUI requires iOS 18 or later. Increase your app's minimum deployment target to iOS 18.")
@MainActor public let loader = Loader.shared

/// Loader designs supported by LoaderKitSwiftUI.
@available(iOS, introduced: 18.0, message: "LoaderKitSwiftUI requires iOS 18 or later. Increase your app's minimum deployment target to iOS 18.")
public enum LoaderType: Sendable {
    case simpleLoader
    case simpleLoaderWithMessage
}

/// Size options supported by the default loader.
@available(iOS, introduced: 18.0, message: "LoaderKitSwiftUI requires iOS 18 or later. Increase your app's minimum deployment target to iOS 18.")
public enum LoaderSize: Sendable {
    case small
    case medium
    case large
}

/// Controls loader selection, presentation, and styling.
@available(iOS, introduced: 18.0, message: "LoaderKitSwiftUI requires iOS 18 or later. Increase your app's minimum deployment target to iOS 18.")
@MainActor
public final class Loader: ObservableObject {
    public static let shared = Loader()

    @Published public private(set) var isPresented = false
    @Published public private(set) var selectedType: LoaderType = .simpleLoader
    @Published public private(set) var message: String?
    @Published public private(set) var loaderColor: Color = .primary
    @Published public private(set) var messageColor: Color = .primary
    @Published public private(set) var size: LoaderSize = .medium
    @Published public private(set) var backgroundOpacity = 0.25
    @Published public private(set) var allowsInteraction = false

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

    /// Shows the selected loader overlay with optional text and colors.
    public func show(
        type: LoaderType = .simpleLoader,
        message: String? = nil,
        loaderColor: Color = .primary,
        messageColor: Color = .primary,
        size: LoaderSize = .medium,
        backgroundOpacity: Double = 0.25,
        allowsInteraction: Bool = false
    ) {
        let hasMessage = message?.isEmpty == false
        let resolvedType: LoaderType = hasMessage ? .simpleLoaderWithMessage : type

        withAnimation(.easeInOut(duration: 0.2)) {
            selectedType = resolvedType
            self.message = message
            self.loaderColor = loaderColor
            self.messageColor = messageColor
            self.size = size
            self.backgroundOpacity = Self.clampedOpacity(backgroundOpacity)
            self.allowsInteraction = allowsInteraction
            isPresented = true
        }

        if let uiKitPresenter {
            uiKitPresenter.show(loader: self)
        } else {
            warnIfNoHostIsConfigured()
        }
    }

    /// Shows the selected loader overlay with UIKit colors.
    public func show(
        type: LoaderType = .simpleLoader,
        message: String? = nil,
        loaderUIColor: UIColor,
        messageUIColor: UIColor,
        size: LoaderSize = .medium,
        backgroundOpacity: Double = 0.25,
        allowsInteraction: Bool = false
    ) {
        show(
            type: type,
            message: message,
            loaderColor: Color(loaderUIColor),
            messageColor: Color(messageUIColor),
            size: size,
            backgroundOpacity: backgroundOpacity,
            allowsInteraction: allowsInteraction
        )
    }

    /// Hides the loader overlay.
    public func hide() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isPresented = false
            selectedType = .simpleLoader
            message = nil
            loaderColor = .primary
            messageColor = .primary
            size = .medium
            backgroundOpacity = 0.25
            allowsInteraction = false
        }

        uiKitPresenter?.hide()
    }

    func registerSwiftUIHost() {
        swiftUIHostCount += 1
    }

    func unregisterSwiftUIHost() {
        swiftUIHostCount = max(0, swiftUIHostCount - 1)
    }

    private func warnIfNoHostIsConfigured() {
        guard swiftUIHostCount == 0 else { return }

        #if DEBUG
        print("LoaderKitSwiftUI: No loader host configured. For SwiftUI use .loaderHost(). For UIKit call loader.configure(windowScene:).")
        #endif
    }

    private static func clampedOpacity(_ opacity: Double) -> Double {
        min(max(opacity, 0), 1)
    }
}

#endif
