//
//  ContentView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView()
            .overlay(Splashscreen())
        
    }
}
