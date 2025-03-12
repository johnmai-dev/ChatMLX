//
//  UltraNavigationSplitView.swift
//  UltraUI
//
//  Created by John Mai on 2025/2/22.
//

import SwiftUI

public enum UltraToolbarPlacement: CaseIterable {
    case leading, trailing, principal
}

public struct UltraToolbarItem: Identifiable, Equatable {
    public var id: String = ""
    let placement: UltraToolbarPlacement
    let content: AnyView

    public init<Content: View>(
        placement: UltraToolbarPlacement,
        @ViewBuilder content: () -> Content
    ) {
        self.placement = placement
        let view = content()
        self.content = AnyView(view)
    }

    private init(
        id: String,
        placement: UltraToolbarPlacement,
        content: AnyView
    ) {
        self.id = id
        self.placement = placement
        self.content = content
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func id(_ id: String) -> UltraToolbarItem {
        UltraToolbarItem(
            id: id,
            placement: placement,
            content: content
        )
    }
}

@resultBuilder
public enum UltraToolbarContentBuilder {
    public static func buildBlock(_ components: UltraToolbarItem...)
        -> [UltraToolbarItem]
    {
        components
    }

    public static func buildOptional(_ component: [UltraToolbarItem]?)
        -> [UltraToolbarItem]
    {
        component ?? []
    }

    public static func buildEither(first component: [UltraToolbarItem])
        -> [UltraToolbarItem]
    {
        component
    }

    public static func buildEither(second component: [UltraToolbarItem])
        -> [UltraToolbarItem]
    {
        component
    }

    public static func buildArray(_ components: [[UltraToolbarItem]])
        -> [UltraToolbarItem]
    {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: UltraToolbarItem)
        -> [UltraToolbarItem]
    {
        [expression]
    }

    public static func buildPartialBlock(first: [UltraToolbarItem])
        -> [UltraToolbarItem]
    {
        first
    }

    public static func buildPartialBlock(
        accumulated: [UltraToolbarItem], next: [UltraToolbarItem]
    ) -> [UltraToolbarItem] {
        accumulated + next
    }
}

struct UltraToolbarModifier: ViewModifier {
    let items: [UltraToolbarItem]

    @Environment(\.ultraNavigationState) var state

    func body(content: Content) -> some View {
        content
            .onAppear { state?.toolbarItems = items }
            .onChange(of: items) { state?.toolbarItems = $1 }
            .onDisappear {
                if state?.toolbarItems == items {
                    state?.toolbarItems = []
                }
            }
    }
}

struct UltraNavigationTitleViewModifier: ViewModifier {
    let title: String

    @Environment(\.ultraNavigationState) var state

    func body(content: Content) -> some View {
        content
            .onAppear { state?.title = title }
            .onChange(of: title) { state?.title = $1 }
            .onDisappear {
                if state?.title == title {
                    state?.title = ""
                }
            }
    }
}

extension View {
    public func ultraToolbar(
        @UltraToolbarContentBuilder content: () -> [UltraToolbarItem]
    ) -> some View {
        self.modifier(UltraToolbarModifier(items: content()))
    }

    public func ultraNavigationTitle(_ title: String) -> some View {
        modifier(UltraNavigationTitleViewModifier(title: title))
    }
}

struct UltraNavigationStateKey: EnvironmentKey {
    static let defaultValue: UltraNavigationState? = nil
}

extension EnvironmentValues {
    @Entry var ultraNavigationState: UltraNavigationState?
}

@MainActor
@Observable
final class UltraNavigationState {
    var title: String = ""
    var toolbarItems: [UltraToolbarItem] = []
}

public struct UltraNavigationSplitView<Sidebar: View, Detail: View>: View {
    @State private var initialSidebarWidth: CGFloat
    @State private var lastNonZeroWidth: CGFloat
    @State private var isSidebarVisible = true
    @State private var state = UltraNavigationState()
    @State private var isDragging = false
    @State private var isHovering = false

    let sidebar: () -> Sidebar
    let detail: () -> Detail

    let minSidebarWidth: CGFloat
    let maxSidebarWidth: CGFloat

    let showDivider: Bool

    public init(
        initialSidebarWidth: CGFloat = 250,
        minSidebarWidth: CGFloat = 200,
        maxSidebarWidth: CGFloat = 400,
        showDivider: Bool = true,
        @ViewBuilder sidebar: @escaping () -> Sidebar,
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        _initialSidebarWidth = State(initialValue: initialSidebarWidth)
        _lastNonZeroWidth = State(initialValue: initialSidebarWidth)
        self.minSidebarWidth = minSidebarWidth
        self.maxSidebarWidth = maxSidebarWidth
        self.sidebar = sidebar
        self.detail = detail
        self.showDivider = showDivider
    }

    public var body: some View {
        HStack(spacing: .zero) {
            if isSidebarVisible {
                ZStack(alignment: .trailing) {
                    sidebar()
                        .safeAreaInset(edge: .top, alignment: .trailing, spacing: 0) {
                            HStack {
                                leadingToolbarItems()
                            }
                            .frame(height: 52)
                            .padding(.horizontal)
                        }
                        .frame(width: initialSidebarWidth)
                        //                        .padding(.top, 32)
                        .background(UltraSidebarBackgroundView())

                    Rectangle()
                        .fill(Color.gray.opacity(isHovering || isDragging ? 0.3 : 0))
                        .frame(width: 4)
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    let newWidth = initialSidebarWidth + value.translation.width
                                    if newWidth >= minSidebarWidth && newWidth <= maxSidebarWidth {
                                        initialSidebarWidth = newWidth
                                        lastNonZeroWidth = newWidth
                                    }
                                }
                                .onEnded { _ in
                                    isDragging = false
                                }
                        )
                        .onHover { hovering in
                            isHovering = hovering
                            if hovering {
                                NSCursor.resizeLeftRight.push()
                            } else {
                                NSCursor.arrow.pop()
                            }
                        }
                        .animation(.spring, value: isHovering)
                        .animation(.spring, value: isDragging)
                }
                .transition(.move(edge: .leading))
            }

            VStack(spacing: .zero) {
                if showDivider {
                    Divider()
                        .foregroundStyle(.secondary.opacity(0.2))
                }
                detail()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            }
            .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
                header().frame(height: 52)
            }
        }
        .environment(\.ultraNavigationState, state)
    }

    @ViewBuilder
    func leadingToolbarItems() -> some View {
        ForEach(state.toolbarItems.filter { $0.placement == .leading }) { item in
            item.content
        }

        Button {
            toggleSidebar()
        } label: {
            Image(systemName: "sidebar.leading")
                .font(.title3)
        }
        .buttonStyle(.ultraIcon)
    }

    @ViewBuilder
    func header() -> some View {
        VStack(spacing: 0) {
            Spacer()

            HStack {
                if !isSidebarVisible {
                    Spacer()
                        .frame(width: 80)

                    leadingToolbarItems()
                }

                Spacer()
                Text(LocalizedStringKey(state.title))
                    .font(.headline)

                Spacer()

                ForEach(state.toolbarItems.filter { $0.placement == .trailing }) { item in
                    item.content
                }
            }
            .padding(.horizontal, 10)
            .padding(.trailing, 5)
            Spacer()
        }
        .frame(height: 50)
        .foregroundColor(.white)
    }

    func toggleSidebar() {
        withAnimation {
            if isSidebarVisible {
                lastNonZeroWidth = lastNonZeroWidth
                lastNonZeroWidth = 0
            } else {
                lastNonZeroWidth = lastNonZeroWidth
            }
            isSidebarVisible.toggle()
        }
    }
}
