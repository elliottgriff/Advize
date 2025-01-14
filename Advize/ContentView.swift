//
//  ContentView.swift
//  Advize
//
//  Created by Elliott Griffin on 1/7/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isLoggedIn = false

    var body: some View {
        Group {
            if isLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear(perform: checkAuthentication)
        .animation(.easeInOut, value: isLoggedIn)
    }
    
    func checkAuthentication() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        }
    }
}

#Preview {
    ContentView()
}
