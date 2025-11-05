import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Tab(Constants.homeString, systemImage: Constants.homeIconString){
                HomeView()
            }
            Tab(Constants.upcomingString, systemImage: Constants.upcomingIconString){
            }
            Tab(Constants.searchString, systemImage: Constants.searchIconString){
            }
            Tab(Constants.dowloadString, systemImage: Constants.downloadIconString){
            }
        }
    }
}

#Preview {
    ContentView()
}
