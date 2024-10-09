//
//  ContentView.swift
//  ChatMirrorApplication
//
//  Created by Kishan on 09/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Message.timestamp, order: .forward) private var messages: [Message]
    
    @State private var inputText: String = ""
    @State private var shouldScrollToBottom: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ZStack {
                Text("Chat HelpDesk")
                    .font(.headline)
                    .padding()
                    .multilineTextAlignment(.center)
                
                HStack(alignment: .center) {
                    Spacer()
                
                    if !messages.isEmpty {
                        Button(action: clearMessagesHistory) {
                            Text("Clear")
                                .padding()
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            Divider()
                .padding(.horizontal, 16)
            if messages.isEmpty {
                Spacer()
                Text("Start Conversation Now")
                Spacer()
            } else {
                messageList
            }
            inputView
        }
        .padding(.horizontal)
        .onAppear() {
            shouldScrollToBottom = true
        }
    }
    
    private var messageList: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages) { message in
                        getMessageView(message: message)
                            .id(message.id)
                            .transition(.opacity)
                    }
                }
                .onChange(of: messages.count) { _, _ in
                    if shouldScrollToBottom {
                        withAnimation {
                            scrollViewProxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                withAnimation {
                    scrollViewProxy.scrollTo(messages.last?.id, anchor: .bottom)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                withAnimation {
                    scrollViewProxy.scrollTo(messages.last?.id, anchor: .bottom)
                }
            }
        }
    }

    private func getMessageView(message: Message) -> some View {
        Text(message.content)
            .padding()
            .background(message.isSentByUser ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: message.isSentByUser ? .trailing : .leading)
    }

    private var inputView: some View {
        HStack(alignment: .center, spacing: 8) {
            TextField("Message", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
            
            Button(action: sendMessage) {
                Text("Send")
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(height: 40)
            }
        }
    }
}

// Extension for Message operations
extension ContentView {

    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = Message(content: inputText, isSentByUser: true)
        modelContext.insert(userMessage)
        shouldScrollToBottom = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let responseMessage = Message(content: userMessage.content, isSentByUser: false)
            modelContext.insert(responseMessage)
            shouldScrollToBottom = true
        }
        
        inputText = ""
    }
        
    private func clearMessagesHistory() {
        for message in messages {
            modelContext.delete(message)
        }
    }
}
