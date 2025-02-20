//
//  MediaTab.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct MediaView: View {
    var body: some View {
            VStack(alignment: .leading, spacing: 30) {
                Image("flight")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea([.top, .horizontal])
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top,5)
                
                Text("The flight team is a pro! #1 coming soon... #watchyourbackNASA #bestintheleague #letsgetthisbread")
                    .font(.custom("Roboto-Medium", size: 14))
                    .foregroundColor(.black)
                    .lineSpacing(5)
                    .multilineTextAlignment(.leading)
            }.padding(15).background(RoundedRectangle(cornerRadius: 10).fill(.white).shadow(color: .gray.opacity(0.07),radius: 3, y: 2.5))
    }
}
