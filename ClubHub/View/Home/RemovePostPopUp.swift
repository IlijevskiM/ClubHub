//
//  DeletePostPopUp.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify

struct RemovePostPopUp: View {
    @EnvironmentObject var userState: UserState
    @Binding var showDeletePostPopUp: Bool
    @Binding var confirmDeletePost: Bool
    @Binding var showCreatePostPage: Bool
    @State var isLoading = false
    //Referenced Data
    @Binding var postTitleText: String
    @Binding var postBodyText: String
    @Binding var postLinkText: String
    @Binding var selectedIndex: Int
    @Binding var clubOptions: [UserClub]
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 15) {
                
                Text("Save Draft")
                    .font(.custom("Roboto-Bold", size: 20))
                    .foregroundColor(.black)
                
                Text("Do you want to save this draft?")
                    .font(Font.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(5)
                    .multilineTextAlignment(.leading)
            }
            
            HStack(spacing: 10) {
                Button {
                    showDeletePostPopUp.toggle()
                    showCreatePostPage.toggle()
                } label: {
                    Text("Discard")
                        .font(.custom("Roboto-Medium", size: 13))
                        .foregroundColor(.gray)
                        .padding(.vertical,8)
                        .padding(.horizontal,35)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("back"))
                        )
                }
                //TODO: Save this to drafts - only my account can see
                Button {
//                    showDeletePostPopUp.toggle()
//                    showCreatePostPage.toggle()
                    Task { await saveDraft() }
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.showCreatePostPage = false
                        self.showDeletePostPopUp = false
                    }
                } label: {
                    Text("Save")
                        .font(.custom("Roboto-Medium", size: 13))
                        .foregroundColor(.white)
                        .padding(.vertical,8)
                        .padding(.horizontal,35)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(Color("darkBlue"))
                        )
                }
            }.padding(.top,10)
        }.padding(.horizontal,20).padding(.vertical,20).background(RoundedRectangle(cornerRadius: 12).fill(.white))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .transition(.move(edge: .bottom))
            .animation(.spring())
        
            .overlay (
                ZStack(
                    content: {
                        if isLoading{
                            Color.white
                                .ignoresSafeArea()
                            LoadingScreenForSavingDraft(isLoading: $isLoading)
                        }
                    })
            )
    }
    
    func saveDraft()async{
        let draftId = UUID().uuidString
        do{
            let newDraft = Draft(id: draftId, clubCategory: self.clubOptions[selectedIndex].club.clubName, title: postTitleText, bodyText: postBodyText, link: postLinkText, firstName: userState.firstName, lastName: userState.lastName, username: userState.username, userID: userState.userId, savedTime: .now())
            let savedDraft = try await Amplify.DataStore.save(newDraft)
            print("Successfully saved draft!: \(newDraft)")
        }catch{
            print("Error saving draft: \(error)")
        }
    }
}

struct LoadingScreenForSavingDraft: View {
    @Binding var isLoading: Bool
    var body: some View {
            VStack(spacing: 15){
                ProgressView()
                    .tint(.blue)
                Text("Saving draft...")
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.black)
            }
    }
}

