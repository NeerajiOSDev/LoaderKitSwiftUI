import Testing
@testable import LoaderKitSwiftUI

#if os(iOS)

@MainActor
@Test func showPresentsLoaderWithoutMessage() {
    loader.hide()

    loader.show()

    #expect(loader.isPresented)
    #expect(loader.selectedType == .simpleLoader)
    #expect(loader.message == nil)
}

@MainActor
@Test func showPresentsLoaderWithMessage() {
    loader.hide()

    loader.show(message: "Please wait")

    #expect(loader.isPresented)
    #expect(loader.selectedType == .simpleLoaderWithMessage)
    #expect(loader.message == "Please wait")
}

@MainActor
@Test func showPresentsSelectedLoaderType() {
    loader.hide()

    loader.show(type: .simpleLoaderWithMessage)

    #expect(loader.isPresented)
    #expect(loader.selectedType == .simpleLoaderWithMessage)
}

@MainActor
@Test func showAppliesCustomizationOptions() {
    loader.hide()

    loader.show(
        type: .simpleLoaderWithMessage,
        message: "Please wait",
        size: .large,
        backgroundOpacity: 0.6,
        allowsInteraction: true
    )

    #expect(loader.size == .large)
    #expect(loader.backgroundOpacity == 0.6)
    #expect(loader.allowsInteraction)
}

@MainActor
@Test func showClampsBackgroundOpacity() {
    loader.hide()

    loader.show(backgroundOpacity: 2)

    #expect(loader.backgroundOpacity == 1)
}

@MainActor
@Test func hideDismissesLoaderAndClearsMessage() {
    loader.show(message: "Please wait")

    loader.hide()

    #expect(!loader.isPresented)
    #expect(loader.selectedType == .simpleLoader)
    #expect(loader.message == nil)
    #expect(loader.size == .medium)
    #expect(loader.backgroundOpacity == 0.25)
    #expect(!loader.allowsInteraction)
}

#endif
