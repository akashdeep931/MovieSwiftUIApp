import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Tab(Constants.homeString, systemImage: Constants.homeIconString){
                HomeView()
            }
            Tab(Constants.upcomingString, systemImage: Constants.upcomingIconString){
                UpcomingView()
            }
            Tab(Constants.searchString, systemImage: Constants.searchIconString){
                SearchView()
            }
            Tab(Constants.dowloadString, systemImage: Constants.downloadIconString){
            }
        }
    }
}

#Preview {
    ContentView()
}
