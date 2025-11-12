//
//  VerticalListView.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 12/11/2025.
//

import SwiftUI
import SwiftData

struct VerticalListView: View {
    var titles: [Title]
    let canDelete: Bool
    @Environment(\.modelContext) var modelContext
    let onSelect: (Title) -> Void
    
    var body: some View {
        List(titles) { title in
            AsyncImage(url: URL(string: title.posterPath ?? "")) { phase in
                switch phase {
                case .empty:
                    GeometryReader { geo in
                        ProgressView()
                            .frame(width: geo.size.width)
                    }
                case .success(let image):
                    HStack {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(5)
                        
                        Text((title.name ?? title.title) ?? "")
                            .font(.system(size: 14))
                            .bold()
                    }
                case .failure:
                    FailedImagePhasePlaceholder()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 150)
            .onTapGesture {
                onSelect(title)
            }
            .swipeActions(edge: .trailing) {
                if canDelete {
                    Button {
                        modelContext.delete(title)
                        try? modelContext.save()
                    } label: {
                        Image(systemName: "trash")
                            .tint(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    VerticalListView(titles: Title.previewTitles, canDelete: false) { title in }
}
