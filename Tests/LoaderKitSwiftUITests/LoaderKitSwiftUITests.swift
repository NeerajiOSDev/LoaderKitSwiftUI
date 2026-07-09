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
@Test func hideDismissesLoaderAndClearsMessage() {
    loader.show(message: "Please wait")

    loader.hide()

    #expect(!loader.isPresented)
    #expect(loader.selectedType == .simpleLoader)
    #expect(loader.message == nil)
}

#endif
