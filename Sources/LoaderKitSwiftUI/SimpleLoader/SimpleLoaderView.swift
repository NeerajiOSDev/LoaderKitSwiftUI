import SwiftUI

#if os(iOS)

struct SimpleLoaderView: View {
    let type: LoaderType
    let message: String?
    let loaderColor: Color
    let messageColor: Color

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()

            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(loaderColor)

                if shouldShowMessage, let message, !message.isEmpty {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(messageColor)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(24)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var shouldShowMessage: Bool {
        type == .simpleLoaderWithMessage
    }

    private var accessibilityLabel: String {
        if shouldShowMessage, let message, !message.isEmpty {
            return message
        }

        return "Loading"
    }
}

#endif
