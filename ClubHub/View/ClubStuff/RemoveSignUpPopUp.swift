//
//  DeleteSignUpPopUp.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct RemoveSignUpPopUp: View {
    @Binding var showDeleteSignUp: Bool
    @Binding var confirmDeleteSignUp: Bool
    var body: some View {
        
    VStack(alignment: .leading) {
        VStack(alignment: .leading, spacing: 15) {
            
            Text("Remove Sign Up")
                .font(.custom("Roboto-Bold", size: 20))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Are you sure you want to remove your \nsign up for this event?")
                    .font(Font.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(5)
                    .multilineTextAlignment(.leading)
                
                Text("The club administrators will be notified \nof your removal")
                    .font(Font.custom("Roboto-Medium", size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(5)
                    .multilineTextAlignment(.leading)
            }
        }
            
            HStack(spacing: 10) {
                Button {
                    showDeleteSignUp.toggle()
                } label: {
                    Text("Cancel")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.gray)
                        .padding(.vertical,8)
                        .padding(.horizontal,40)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(Color("back"))
                        )
                }
                Button {
                    showDeleteSignUp.toggle()
                    confirmDeleteSignUp.toggle()
                } label: {
                    Text("Confirm")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.white)
                        .padding(.vertical,8)
                        .padding(.horizontal,40)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(Color("darkBlue"))
                        )
                }
            }.padding(.top,10)
    }.padding(.horizontal,20).padding(.vertical,20).background(RoundedRectangle(cornerRadius: 12).fill(.white))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .transition(.move(edge: .bottom))
        .animation(.spring())
    }
}

