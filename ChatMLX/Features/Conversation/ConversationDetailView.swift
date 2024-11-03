//
//  ConversationDetailView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/4.
//

import AlertToast
import Defaults
import Luminare
import MLX
import MLXLLM
import SwiftUI

struct ConversationDetailView: View {
    @ObservedObject var conversation: Conversation
    
    @Environment(LLMRunner.self) var runner
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(ConversationViewModel.self) private var conversationViewModel
    @Environment(ModelManagerViewModel.self) private var modelManagerViewModel
    
    @State private var newMessage = ""
    @State private var showRightSidebar = false
    @State private var showInfoPopover = false
    @State private var displayStyle: DisplayStyle = .markdown
    @State private var isEditorFullScreen = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastType: AlertToast.AlertType = .regular
    @State private var scrollViewProxy: ScrollViewProxy?
    
    @FocusState private var isInputFocused: Bool
    
    @Default(.enableAppleIntelligenceEffect) var enableAppleIntelligenceEffect
    @Default(.appleIntelligenceEffectDisplay) var appleIntelligenceEffectDisplay
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ModelInfo.name, ascending: true)],
        animation: .default
    ) var models: FetchedResults<ModelInfo>
    
    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 0) {
                if !isEditorFullScreen {
                    MessageBox()
                    Divider()
                }
                Editor()
            }
            
            if showRightSidebar {
                Color.black.opacity(0.00001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showRightSidebar = false
                        }
                    }
                
                RightSidebarView(conversation: conversation)
            }
        }
        .toast(isPresenting: $showToast, duration: 1.5, offsetY: 30) {
            AlertToast(
                displayMode: .hud, type: toastType, title: toastMessage
            )
        }
        .ultramanNavigationTitle(
            conversation.title
        )
        .ultramanToolbar(alignment: .trailing) {
            Button(action: {
                withAnimation {
                    showRightSidebar.toggle()
                }
                
            }) {
                Image(systemName: "slider.horizontal.3")
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private func MessageBox() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(conversation.messages) { message in
                        MessageBubbleView(
                            message: message,
                            displayStyle: $displayStyle
                        )
                    }
                }
                .padding()
            }
            .onChange(
                of: conversation.messages.last,
                { _, _ in
                    scrollToBottom()
                }
            )
            .onAppear {
                scrollViewProxy = proxy
                scrollToBottom()
            }
        }
    }
    
    private func scrollToBottom() {
        guard let lastMessageId = conversation.messages.last?.id, let scrollViewProxy else {
            return
        }
        
        withAnimation {
            scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
        }
    }
    
    @ViewBuilder
    private func EditorToolbar() -> some View {
        HStack {
            Button {
                withAnimation {
                    displayStyle = (displayStyle == .markdown) ? .plain : .markdown
                }
            } label: {
                Image(displayStyle == .markdown ? "plaintext" : "markdown")
            }
            
            Button(action: {
                conversation.messages = []
            }) {
                Image("clear")
            }
            
            Button {
                withAnimation {
                    isEditorFullScreen.toggle()
                }
            } label: {
                Image(
                    systemName: isEditorFullScreen
                        ? "arrow.down.right.and.arrow.up.left"
                        : "arrow.up.left.and.arrow.down.right")
            }
            .help(isEditorFullScreen ? "Exit Full Screen" : "Enter Full Screen")
            
            Spacer()
            
            Button {
                showInfoPopover.toggle()
            } label: {
                if runner.gpuActiveMemory > 0 {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("\(runner.gpuActiveMemory)M")
                    }
                    .padding(4)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(20)
                } else {
                    Image(systemName: "info.circle")
                        .padding(4)
                }
            }
            .font(.subheadline)
            .popover(isPresented: $showInfoPopover) {
                VStack(alignment: .leading) {
                    LabeledContent {
                        Text(conversation.promptTime.formatted())
                    } label: {
                        Text("Prompt Time")
                            .fontWeight(.bold)
                    }
                    
                    LabeledContent {
                        Text("\(Int(conversation.promptTokensPerSecond))")
                    } label: {
                        Text("Prompt Tokens/second")
                            .fontWeight(.bold)
                    }
                    
                    LabeledContent {
                        Text(conversation.generateTime.formatted())
                    } label: {
                        Text("Generate Time")
                            .fontWeight(.bold)
                    }
                    
                    LabeledContent {
                        Text("\(Int(conversation.tokensPerSecond))")
                    } label: {
                        Text("Generate Tokens/second")
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .background(.clear)
            }
            
            ModelPicker(selection: $conversation.model)
        }
        .buttonStyle(.borderless)
        .foregroundStyle(.white)
        .tint(.white)
        .frame(height: 35)
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    private func Editor() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            EditorToolbar()
            
            ZStack(alignment: .bottom) {
                UltramanTextEditor(
                    text: $newMessage,
                    placeholder: "Type your message…",
                    onSubmit: sendMessage
                )
                .padding(.horizontal, 5)
                
                HStack(spacing: 16) {
                    Spacer()
                    Button("Clear") {
                        newMessage = ""
                    }
                    .buttonStyle(.borderless)
                    .disabled(newMessage.isEmpty)
                    
                    Button {
                        sendMessage()
                    } label: {
                        if runner.running {
                            Label {
                                Text("Send")
                            } icon: {
                                ProgressView()
                                    .controlSize(.small)
                                    .padding(.trailing, 2)
                                    .colorInvert()
                                    .brightness(1)
                            }
                        } else {
                            Label("Send", systemImage: "paperplane")
                        }
                    }
                    .buttonStyle(LuminareCompactButtonStyle())
                    .fixedSize()
                    .disabled(
                        newMessage.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty || runner.running)
                }
                .padding()
            }
            .frame(maxHeight: isEditorFullScreen ? .infinity : 150)
        }
    }
    
    private func sendMessage() {
        guard !conversation.inferring else {
            return
        }
        
        let trimmedMessage = newMessage.trimmingCharacters(
            in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }
        
        guard let model = conversation.model else {
            showToastMessage("Please select a model", type: .error(.red))
            return
        }
        
        newMessage = ""
        isInputFocused = false
        
        Message(context: viewContext).user(content: trimmedMessage, conversation: conversation)
        
        if enableAppleIntelligenceEffect, appleIntelligenceEffectDisplay == .global {
            AppleIntelligenceEffectManager.shared.setupEffect()
        }
        
        conversation.inferring = true
        
        let factory = ProviderFactory.shared
        
        let assistantMessage = conversation.getLastAssistantMessage(context: viewContext)
        assistantMessage.inferring = true
        let messages = conversation.prepareMessages()
        
#if DEBUG
        print(messages)
#endif
        
        Task {
            let provider = await factory.provider(.openAI)
            await provider.chat(
                messages: messages,
                config: .init(
                    model: .init(
                        name: "model.name",
                        path: model.path
                    )
                )
            ) { result in
                switch result {
                case .success(let response):
                    Task { @MainActor in
                        assistantMessage.content = response.content
                    }
                case .failure(let error):
                    Task { @MainActor in
                        assistantMessage.error = error.localizedDescription
                    }
                }
            }
            
            await MainActor.run {
                conversation.inferring = false
                assistantMessage.inferring = false
            }
            
            if enableAppleIntelligenceEffect, appleIntelligenceEffectDisplay == .global {
                AppleIntelligenceEffectManager.shared.closeEffect()
            }
            
            if viewContext.hasChanges {
                try? viewContext.save()
            }
        }
    }

    private func showToastMessage(_ message: String, type: AlertToast.AlertType) {
        toastMessage = message
        toastType = type
        showToast = true
    }
}
