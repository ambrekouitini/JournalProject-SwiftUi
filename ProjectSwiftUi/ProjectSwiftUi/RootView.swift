//
//  RootView.swift
//  ProjectSwiftUi
//
//  Created by KOUITINI Ambre on 16/10/2024.
//
import SwiftUI

struct RootView: View {
    @State private var selectedTab = 0

    let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.15)
    let accentColor = Color(red: 0.6, green: 0.8, blue: 0.8)
    let secondaryAccentColor = Color(red: 0.8, green: 0.5, blue: 0.7)

    var body: some View {
        TabView(selection: $selectedTab) {
            MainAppView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Accueil")
                }
                .tag(0)
            
            JournalEntryView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Journal")
                }
                .tag(1)
        }
        .accentColor(accentColor)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(backgroundColor)
            
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.gray)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.gray)]
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(accentColor)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(accentColor)]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
