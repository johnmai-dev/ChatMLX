//
//  UltramanNavigationTitleKey.swift
//  ChatMLXUI
//
//  Created by John Mai on 2025/2/22.
//

import SwiftUI

extension AnyView: @unchecked @retroactive Sendable {}

struct UltramanToolbarItem: Identifiable, Equatable, Sendable {
    static func == (lhs: UltramanToolbarItem, rhs: UltramanToolbarItem) -> Bool {
        lhs.id == rhs.id && lhs.alignment == rhs.alignment
    }

    let id = UUID()
    let content: AnyView
    let alignment: ToolbarAlignment

    enum ToolbarAlignment {
        case leading, trailing
    }

    nonisolated init(alignment: ToolbarAlignment = .trailing, @ViewBuilder content: () -> some View) {
        self.content = AnyView(content())
        self.alignment = alignment
    }
}

@resultBuilder
struct UltramanToolbarBuilder {
    static func buildBlock(_ components: UltramanToolbarItem...) -> [UltramanToolbarItem] {
        components
    }
}

private struct UltramanNavigationTitleKey: EnvironmentKey {
    static let defaultValue: String = ""
}

struct UltramanNavigationToolbarKey: EnvironmentKey {
    static let defaultValue: [UltramanToolbarItem] = []
}

struct UltramanNavigationStateKey: EnvironmentKey {
    static let defaultValue: UltramanNavigationState = .init()
}

extension EnvironmentValues {
    var ultramanNavigationState: UltramanNavigationState {
        get { self[UltramanNavigationStateKey.self] }
        set { self[UltramanNavigationStateKey.self] = newValue }
    }
}

struct UltramanNavigationTitleViewModifier: ViewModifier {
    let title: String

    @Environment(\.ultramanNavigationState) var state

    func body(content: Content) -> some View {
        content
            .onAppear {
                state.title = title
            }
            .onChange(of: title) { oldValue, newValue in
                print("title changed from \(oldValue) to \(newValue)")
                state.title = newValue
            }
            .onDisappear {
                // 在视图消失时清除标题
                state.title = ""
            }
    }
}

struct UltramanNavigationToolbarViewModifier: ViewModifier {
    let items: [UltramanToolbarItem]

    @Environment(UltramanNavigationState.self) var state

    func body(content: Content) -> some View {
        content
            .onAppear {
                state.toolbarItems = items
            }
            .onChange(of: items) { oldValue, newValue in
                print("toolbar items changed")
                state.toolbarItems = newValue
            }
            .onDisappear {
                // 在视图消失时清除标题
                state.toolbarItems = []
            }
    }
}

@Observable
class UltramanNavigationState: @unchecked Sendable {
    var title: String = ""
    var toolbarItems: [UltramanToolbarItem] = []
}

extension View {
    func ultramanNavigationTitle(_ title: String) -> some View {
        modifier(UltramanNavigationTitleViewModifier(title: title))
    }

    func ultramanToolbar(
        alignment: UltramanToolbarItem.ToolbarAlignment = .trailing,
        @ViewBuilder content: () -> some View
    ) -> some View {
        modifier(
            UltramanNavigationToolbarViewModifier(items: [
                UltramanToolbarItem(alignment: alignment, content: { content() })
            ]))
    }

    //    func ultramanToolbar(
    //        @UltramanToolbarBuilder content: () -> [UltramanToolbarItem]
    //    ) -> some View {
    //        preference(
    //            key: UltramanNavigationToolbarKey.self,
    //            value: content()
    //        )
    //    }
}

struct UltramanNavigationSplitView<Sidebar: View, Detail: View>: View {
    @State var sidebarWidth: CGFloat = 250
    @State private var lastNonZeroWidth: CGFloat = 0
    let sidebar: () -> Sidebar
    let detail: () -> Detail

    @State private var isDragging = false
    @State private var isSidebarVisible = true

    let minSidebarWidth: CGFloat = 200
    let maxSidebarWidth: CGFloat = 400

    @State private var state = UltramanNavigationState()

    var body: some View {
        HStack(spacing: .zero) {
            if isSidebarVisible {
                sidebar()
                    .frame(width: sidebarWidth)
                    .transition(.move(edge: .leading))
                    .zIndex(10)
            }

            VStack(spacing: .zero) {
                Divider()
                detail()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
                header().frame(height: 52)
            }
        }
        .environment(state)
    }

    @ViewBuilder
    func header() -> some View {
        VStack(spacing: 0) {
            Spacer()

            HStack {
                if !isSidebarVisible {
                    Spacer()
                        .frame(width: 80)
                }

                Button {
                    toggleSidebar()
                } label: {
                    Image(systemName: "sidebar.leading")
                }
                .buttonStyle(.plain)

                ForEach(state.toolbarItems.filter { $0.alignment == .leading }) {
                    item in
                    item.content
                }

                Spacer()
                Text(LocalizedStringKey(state.title))
                    .font(.headline)

                Spacer()

                ForEach(state.toolbarItems.filter { $0.alignment == .trailing }) {
                    item in
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
                lastNonZeroWidth = sidebarWidth
                sidebarWidth = 0
            } else {
                sidebarWidth = lastNonZeroWidth
            }
            isSidebarVisible.toggle()
        }
    }
}
