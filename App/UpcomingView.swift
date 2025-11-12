//
//  UpcomingView.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 12/11/2025.
//

import SwiftUI

struct UpcomingView: View {
    let viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                switch (viewModel.upcomingStatus) {
                case .notStarted:
                    EmptyView()
                case .fetching:
                    ProgressView()
                        .frame(width: geo.size.width, height: geo.size.height)
                case .success:
                    VerticalListView(titles: viewModel.upcomingMovies)
                case .failed(underlyingError: let error):
                    Text("Error: \(error.localizedDescription)")
                        .frame(width: geo.size.width, height: geo.size.height * 0.85)
                }
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
