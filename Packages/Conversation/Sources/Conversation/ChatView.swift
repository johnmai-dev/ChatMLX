//
//  Message.swift
//  Conversation
//
//  Created by John Mai on 2025/2/23.
//

import SwiftUI

// 消息模型
struct Message2: Identifiable {
    let id = UUID()
    let content: String
    let isFromMe: Bool
    let timestamp: Date
}

struct BubbleShape: Shape {
    let isFromMe: Bool
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        if isFromMe {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

            path.addArc(
                center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false)

            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))

            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 270),
                endAngle: Angle(degrees: 0),
                clockwise: false)

            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
            path.addArc(
                center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false)

        } else {
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
            path.addArc(
                center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false)

            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))

            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 270),
                endAngle: Angle(degrees: 0),
                clockwise: false)

            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))

            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false)

            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }

        path.closeSubpath()
        return path
    }
}

struct MessageBubble: View {
    @Environment(\.utlraViewBackground) var utlraViewBackground
    @Environment(\.utlraSecondaryViewBackground) var utlraSecondaryViewBackground

    let message: Message2

    var body: some View {
        HStack {
            if message.isFromMe {
                Spacer()
            }

            Text(message.content)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    BubbleShape(isFromMe: message.isFromMe, cornerRadius: 10)
                        .fill(
                            message.isFromMe
                                ? utlraViewBackground : utlraSecondaryViewBackground)
                )
                .foregroundColor(message.isFromMe ? .white.opacity(0.8) : .white)

            if !message.isFromMe {
                Spacer()
            }
        }
        .frame(maxWidth: 765)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

struct ChatView: View {
    @State private var messages: [Message2] = [
        Message2(content: "Hello!", isFromMe: false, timestamp: Date()),
        Message2(content: "What have you been up to lately?", isFromMe: true, timestamp: Date()),
        Message2(
            content: "I'm learning SwiftUI and implementing a chat interface.", isFromMe: false,
            timestamp: Date()),
        Message2(content: "Looks good!", isFromMe: true, timestamp: Date()),
        Message2(
            content: "Which one do you think is better, SwiftUI or UIKit?", isFromMe: false,
            timestamp: Date()),
        Message2(
            content: "I think SwiftUI is more concise and easier to use, but UIKit is more mature.",
            isFromMe: true, timestamp: Date()),
        Message2(content: "Indeed!", isFromMe: false, timestamp: Date()),
        Message2(
            content: "Are you using SwiftUI for any projects?", isFromMe: true, timestamp: Date()),
        Message2(
            content: "Not right now, but I'm considering making a personal blog.", isFromMe: false,
            timestamp: Date()),
        Message2(content: "Sounds good!", isFromMe: true, timestamp: Date()),
        Message2(
            content: "What framework are you planning to use?", isFromMe: false, timestamp: Date()),
        Message2(content: "I'm considering using Vapor.", isFromMe: true, timestamp: Date()),
        Message2(content: "Vapor is pretty good!", isFromMe: false, timestamp: Date()),
    ]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(messages) { message in
                    MessageBubble(message: message)
                }
            }
        }
        .padding(.horizontal)
    }
}

// 预览
#Preview {
    ChatView()
}
