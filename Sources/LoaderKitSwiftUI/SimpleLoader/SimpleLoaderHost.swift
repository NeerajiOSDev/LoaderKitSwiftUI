import SwiftUI

#if os(iOS)

public extension View {
    /// Installs the loader overlay host for this view hierarchy.
    ///
    /// Add this once near your app's root view, then call `loader.show()` and
    /// `loader.hide()` from the main actor.
    @available(iOS, introduced: 18.0, message: "LoaderKitSwiftUI requires iOS 18 or later. Increase your app's minimum deployment target to iOS 18.")
    func loaderHost() -> some View {
        modifier(SimpleLoaderHostModifier(loader: loader))
    }
}

struct SimpleLoaderHostModifier: ViewModifier {
    @ObservedObject var loader: Loader

    func body(content: Content) -> some View {
        ZStack {
            content

            if loader.isPresented {
                SimpleLoaderView(
                    type: loader.selectedType,
                    message: loader.message,
                    loaderColor: loader.loaderColor,
                    messageColor: loader.messageColor
                )
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

#endif
