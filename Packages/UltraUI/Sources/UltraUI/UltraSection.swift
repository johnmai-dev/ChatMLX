//
//  UltraSection.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/28.
//

import SwiftUI

public struct UltraSection<Header, Content, Footer> {
    private var header: Header
    private var content: Content
    private var footer: Footer

    private var backgroundColor: Color = .clear
    private var cornerRadius: CGFloat = 0
    private var borderColor: Color = .clear
    private var borderWidth: CGFloat = 0
    private var padding: EdgeInsets = EdgeInsets()
    private var isCollapsible: Bool = false
    private var _isExpanded: Binding<Bool>?

    @Environment(\.utlraViewBackground) var utlraViewBackground

    private init(header: Header, content: Content, footer: Footer) {
        self.header = header
        self.content = content
        self.footer = footer
    }
}

extension UltraSection: View where Header: View, Content: View, Footer: View {
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header.padding(.vertical, 12)
            if _isExpanded?.wrappedValue ?? true {
                VStack {
                    Divided {
                        content
                    }
                }
                .padding()
                .background(utlraViewBackground)
                .cornerRadius(10)

            }

            footer
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
    }

    public func backgroundColor(_ color: Color) -> UltraSection {
        var copy = self
        copy.backgroundColor = color
        return copy
    }

    public func cornerRadius(_ radius: CGFloat) -> UltraSection {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }

    public func border(color: Color, width: CGFloat) -> UltraSection {
        var copy = self
        copy.borderColor = color
        copy.borderWidth = width
        return copy
    }

    public func padding(_ insets: EdgeInsets) -> UltraSection {
        var copy = self
        copy.padding = insets
        return copy
    }

    public func padding(_ amount: CGFloat) -> UltraSection {
        let insets = EdgeInsets(top: amount, leading: amount, bottom: amount, trailing: amount)
        return padding(insets)
    }

    public func collapsible(_ collapsible: Bool) -> UltraSection {
        var copy = self
        copy.isCollapsible = collapsible
        return copy
    }
}

extension UltraSection where Header: View, Content: View, Footer: View {
    public init(
        @ViewBuilder content: () -> Content, @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(header: header(), content: content(), footer: footer())
    }
}

extension UltraSection where Header == EmptyView, Content: View, Footer: View {
    public init(@ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
        self.init(header: EmptyView(), content: content(), footer: footer())
    }
}

extension UltraSection where Header: View, Content: View, Footer == EmptyView {
    public init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Header) {
        self.init(header: header(), content: content(), footer: EmptyView())
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension UltraSection where Header == EmptyView, Content: View, Footer == EmptyView {
    public init(@ViewBuilder content: () -> Content) {
        self.init(header: EmptyView(), content: content(), footer: EmptyView())
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension UltraSection where Header == Text, Content: View, Footer == EmptyView {
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.init(header: Text(titleKey), content: content(), footer: EmptyView())
    }

    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S: StringProtocol {
        self.init(header: Text(title), content: content(), footer: EmptyView())
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
extension UltraSection where Header: View, Content: View, Footer == EmptyView {
    /// 创建一个带有展开状态控制的section
    public init(
        isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header
    ) {
        self.init(header: header(), content: content(), footer: EmptyView())
        self._isExpanded = isExpanded
    }
}

extension UltraSection where Header == Text, Content: View, Footer == EmptyView {
    public init(
        _ titleKey: LocalizedStringKey, isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self.init(header: Text(titleKey), content: content(), footer: EmptyView())
        self._isExpanded = isExpanded
    }

    public init<S>(_ title: S, isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content)
    where S: StringProtocol {
        self.init(header: Text(title), content: content(), footer: EmptyView())
        self._isExpanded = isExpanded
    }
}
