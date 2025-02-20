//
//  LoadingView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/21/23.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    var body: some View {
        ZStack {
            if show {
                Group {
                    Rectangle()
                        .fill(.black.opacity(0.2))
                        .ignoresSafeArea()
                    
                    ProgressView()
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: show)
    }
}
