//
//  ReusableComment.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/21/23.
//

import SwiftUI
import Amplify

struct MyReusableComment: View {
    let comment: Comment
    //let post: Post
    var shortTimeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        //return formatter.string(for: comment.createdAt?.foundationDate ?? .now) ?? ""
        return formatter.string(for: comment.publishedTime.foundationDate) ?? ""
    }
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                //TODO: if the owner of the post deleted it, it will say "[deleted by user]"
                Text("Macomb Regionals")
                    .font(.custom("Roboto-Medium", size: 14))
                    .foregroundColor(.black)
                Text(comment.text)
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(5)
                HStack(spacing: 5) {
                    //TODO: Change this to the club it was posted to
                    Text("CLUB")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(Color("darkBlue"))
                    Text(shortTimeAgo)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                        Image(systemName: "suit.heart")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            .fontWeight(.semibold)
                    
                    Text("\(comment.likes)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }.frame(maxWidth: .infinity).padding(15).background(
                Rectangle()
                    .fill(.white)
            )
    }
}
