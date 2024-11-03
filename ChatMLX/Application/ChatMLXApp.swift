//
//  ChatMLXApp.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/3.
//

import Defaults
import os
import SwiftUI

@main
struct ChatMLXApp: App {
    // MARK: - Properties

    private let currentVersion = getVersion()
    private let viewContext = PersistenceController.shared.container.viewContext
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ChatMLXApp")

    // MARK: - Environment

    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openSettings) private var openSettings
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow

    // MARK: - State

    @State private var conversationViewModel: ConversationViewModel = .init()
    @State private var settingsViewModel: SettingsViewModel = .init()
    @State private var runner: LLMRunner = .init()
    @State private var modelManagerViewModel: ModelManagerViewModel = .init()
    @State private var errorWrapper: ErrorWrapper?

    // MARK: - User Defaults

    @Default(.language) var language
    @Default(.lastLaunchedVersion) var lastLaunchedVersion

    init() {
        updateVersionIfNeeded()
    }

    var body: some Scene {
        Group {
            mainWindow()
            settingsWindow()
        }
        .environment(modelManagerViewModel)
        .environment(conversationViewModel)
        .environment(settingsViewModel)
        .environment(runner)
        .environment(\.managedObjectContext, viewContext)
        .environment(\.locale, .init(identifier: language.rawValue))
        .environment(\.appError) { error in
            Task { @MainActor in
                errorWrapper = ErrorWrapper(error: error, guidance: "")
            }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .background {
                saveContext()
            }
        }

        menu()
    }
}

// MARK: - Scenes

extension ChatMLXApp {
    // MARK: - Main Window

    private func mainWindow() -> some Scene {
        WindowGroup(id: Constants.mainWindowID) {
            ConversationView()
                .frame(minWidth: 900, minHeight: 580)
                .sheet(item: $errorWrapper) { errorWrapper in
                    ErrorView(errorWrapper: errorWrapper)
                }
        }
    }

    // MARK: - Settings Window

    private func settingsWindow() -> some Scene {
        Settings {
            SettingsView()
                .frame(width: 650, height: 480)
                .sheet(item: $errorWrapper) { errorWrapper in
                    ErrorView(errorWrapper: errorWrapper)
                }
        }
    }

    // MARK: - Menu

    private func menu() -> some Scene {
        MenuBarExtra {
            Button("Open \(Bundle.main.name)") {
                dismissWindow(id: Constants.mainWindowID)
                NSApp.activate(ignoringOtherApps: true)
                openWindow(id: Constants.mainWindowID)
            }
            Button("New Conversation") {}
            Button("Settings") {
                openSettings()
            }
            .keyboardShortcut(",")
            Button("Quit") {
                NSApp.terminate(nil)
            }
            .keyboardShortcut("q")
        } label: {
            Image("menubarIcon")
                .renderingMode(.template)
        }
    }
}

// MARK: - Private Methods

extension ChatMLXApp {
    private func updateVersionIfNeeded() {
        if currentVersion != lastLaunchedVersion {
            Defaults[.lastLaunchedVersion] = currentVersion
        }
    }

    private func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            logger.error("Failed to save context: \(error.localizedDescription)")
        }
    }
}
