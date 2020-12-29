//
//  FirebaseSPM2App.swift
//  FirebaseSPM2
//
//  Created by 佐藤一成 on 2020/12/29.
//

import SwiftUI
import Firebase

@main
struct FirebaseSPM2App: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
