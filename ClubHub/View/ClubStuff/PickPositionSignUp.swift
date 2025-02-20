//
//  PickEventPositionSignUp.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct PickPositionSignUp: View {
    @Binding var showPositionPickSignUp: Bool
    @Binding var confirmPositionSignUp: Bool
    @State var firstCheck = false
    @State var secondCheck = false
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 15) {
                
                Text("Sign Up")
                    .font(.custom("Roboto-Bold", size: 20))
                    .foregroundColor(.black)
                
                Text("This event has more than one position. \nSelect one:")
                    .font(Font.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(5)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 10) {
                    
                    Button {
                        self.firstCheck.toggle()
                    } label: {
                        Image(systemName: firstCheck ? "checkmark.square.fill" : "square")
                            .foregroundColor(firstCheck ? .blue : .gray)
                            .font(.system(size: 15))
                    }
                    
                    Text("Event Participant")
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                }
                
                HStack(spacing: 10) {
                    Button {
                        self.secondCheck.toggle()
                    } label: {
                        Image(systemName: secondCheck ? "checkmark.square.fill" : "square")
                            .foregroundColor(secondCheck ? .blue : .gray)
                            .font(.system(size: 15))
                    }
                    
                    Text("Event Leader")
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                }
            }
                
                HStack(spacing: 10) {
                    Button {
                        showPositionPickSignUp.toggle()
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
                        showPositionPickSignUp.toggle()
                        confirmPositionSignUp.toggle()
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
    }
}

