//
//  IdeaNoteApp.swift
//  IdeaNote
//
//  Created by v_jinlilili on 24/12/2024.
//

import SwiftUI

@main
struct IdeaNoteApp: App {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
