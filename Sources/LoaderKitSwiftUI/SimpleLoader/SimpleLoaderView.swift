import SwiftUI

#if os(iOS)

struct SimpleLoaderView: View {
    let type: LoaderType
    let message: String?
    let loaderColor: Color
    let messageColor: Color
    let size: LoaderSize
    let backgroundOpacity: Double

    var body: some View {
        ZStack {
            Color.black.opacity(backgroundOpacity)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(loaderColor)
                    .scaleEffect(loaderScale)

                if shouldShowMessage, let message, !message.isEmpty {
                    Text(message)
                        .font(messageFont)
                        .foregroundStyle(messageColor)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(contentPadding)
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

    private var loaderScale: CGFloat {
        switch size {
        case .small:
            return 0.85
        case .medium:
            return 1
        case .large:
            return 1.35
        }
    }

    private var messageFont: Font {
        switch size {
        case .small:
            return .caption
        case .medium:
            return .subheadline
        case .large:
            return .headline
        }
    }

    private var contentPadding: CGFloat {
        switch size {
        case .small:
            return 16
        case .medium:
            return 24
        case .large:
            return 32
        }
    }
}

#endif
