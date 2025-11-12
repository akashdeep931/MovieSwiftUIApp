//
//  UpcomingView.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 12/11/2025.
//

import SwiftUI

struct UpcomingView: View {
    let viewModel = ViewModel()
    @State var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geo in
                switch (viewModel.upcomingStatus) {
                case .notStarted:
                    EmptyView()
                case .fetching:
                    ProgressView()
                        .frame(width: geo.size.width, height: geo.size.height)
                case .success:
                    VerticalListView(titles: viewModel.upcomingMovies, canDelete: false) { title in
                        navigationPath.append(title)
                    }
                case .failed(underlyingError: let error):
                    Text("Error: \(error.localizedDescription)")
                        .frame(width: geo.size.width, height: geo.size.height * 0.85)
                }
            }
            .navigationDestination(for: Title.self) { title in
                TitleDetailView(title: title)
            }
        }
        .task {
            await viewModel.getUpcomingMovies()
        }
    }
}

#Preview {
    UpcomingView()
}
