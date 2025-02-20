//
//  CommentBar.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct Commentbar: View {
    
    @State var commentText = ""
    @State var show = false
    //@State var isHide = false
    
    var body: some View {
        
        ZStack {
            
            HStack(spacing: 0) {
                
                TextField("Comment", text: $commentText)
                
                Spacer()
                
                Image(systemName: "arrow.up")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding(5)
                    .background(
                    Circle()
                        .foregroundColor(commentText == "" ? Color.gray.opacity(0.5) : Color("blue")))
                    .padding(.trailing,-8)
            }
            .padding(.vertical,5)
            .padding(.horizontal)
            .background(.thinMaterial)
            .cornerRadius(30)
            .padding(.horizontal)
            .frame(width: 430)
            .padding(.top,10)
        }
        .padding(.bottom,-25)
        .background(Color("blue").opacity(0.95))
    }
}


