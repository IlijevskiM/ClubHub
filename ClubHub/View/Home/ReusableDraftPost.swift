//
//  DraftPosts.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import AmplifyImage
import Amplify

struct ReusableDraftPost: View {
    var draft: Draft
    var draftProfileKey: String{
        draft.userID + ".jpg"
    }
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text(draft.clubCategory)
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(Color("darkBlue"))
                    
                    HStack {
                        
                        AmplifyImage(key: draftProfileKey)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .background(
                                Circle()
                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading, spacing: 1) {
                            
                            HStack(spacing: 3) {
                                
                                Text("\(draft.firstName) \(draft.lastName)")
                                    .font(Font.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(.black)
                                
                                Text(draft.username)
                                    .font(Font.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("[Draft]")
                                    .foregroundColor(Color.red)
                                    .font(.system(size: 14))
                                    .padding(.trailing,-10)
                                
                                Menu {
                                    // save data when post view pops up with "Edit Post" instead of "New Post"
                                    Button(action: {}) {
                                        Label("Edit", systemImage: "pencil")
                                            .foregroundColor(.red)
                                    }
                                    Button(action: {
                                        Task { await deleteDraft() }
                                        
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color("darkGray"))
                                    }
                                .padding(.leading, 5)
                            }
                        }.padding(.leading,5)
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text(draft.title)
                            .font(Font.custom("Roboto-Medium", size: 14))
                            .foregroundColor(Color.black)
                            .padding(.top,10)
                        
                        
                        if draft.bodyText != "" {
                            Text(draft.bodyText ?? "")
                                .lineLimit(nil)
                                .lineSpacing(5)
                                .font(Font.custom("Roboto-Regular", size: 14))
                                .foregroundColor(Color.gray)
                                .padding(.vertical,5)
                        }
                        
                    }.fixedSize(horizontal: false, vertical: true)
                }
            }
        }.frame(maxWidth: .infinity)
            .padding(15)
            .background(
                Rectangle()
                    .fill(.white)
            )
    }
    
    func deleteDraft()async{
        do{
            try await Amplify.DataStore.delete(draft)
            print("Deleted post \(draft.id)")
        }catch{
            print(error)
        }
    }
}

