//
//  SubmissionPopUp.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 8/15/23.
//

import SwiftUI
import Amplify

//TODO: Have the Swift File importer show up first and then the popup
struct SubmissionPopUp: View {
    @EnvironmentObject var userState: UserState
    @Binding var showSubmissionPopUp: Bool
    @Binding var confirmSubmission: Bool
    var body: some View {
        
    VStack(alignment: .leading) {
        VStack(alignment: .leading, spacing: 15) {
            
            Text("Submit")
                .font(.custom("Roboto-Bold", size: 20))
                .foregroundColor(.black)
            
            Text("Are you sure you want to create a submission for \nthis event?")
                .font(Font.custom("Roboto-Regular", size: 14))
                .foregroundColor(.gray)
                .lineSpacing(5)
                .multilineTextAlignment(.leading)
        }
            
            HStack(spacing: 10) {
                Button {
                    showSubmissionPopUp.toggle()
                } label: {
                    Text("Cancel")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.gray)
                        .padding(.vertical,8)
                        .padding(.horizontal,35)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(Color("back"))
                        )
                }
                Button {
                    showSubmissionPopUp.toggle()
                    confirmSubmission.toggle()
                } label: {
                    Text("Confirm")
                        .font(.custom("Roboto-Medium", size: 14))
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
        
            /*.overlay (
                ZStack(alignment: .top, content: {
                    
                    if successfullySignedUp{
                        Color.black.opacity(0.1)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    successfullySignedUp.toggle()
                                }
                            }
                            .ignoresSafeArea()
                        SuccessfullySignedUpForEvent(successfullySignedUp: successfullySignedUp)
                            .padding(.horizontal,10)
                    }
                })
            )*/
        
    }
}
