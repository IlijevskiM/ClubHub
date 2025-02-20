//
//  NotiPopUp.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct Notipopup: View {
    @Binding var showNotiPopUp: Bool
    @State var showNotifications = false
    //@Binding var currentSelection: String
    @Environment(\.dismiss) var dismissNotiPopUp
    var body: some View {
        
        VStack {
            VStack(alignment: .leading,spacing: 15) {
                
                Text("Notifications")
                    .font(.custom("Roboto-Bold", size: 20))
                    .foregroundColor(.black)
                
                Text("Would you like to enable notifications?")
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 10) {
                Button {
                        showNotiPopUp.toggle()
                } label: {
                    Text("No")
                        .font(.custom("Roboto-Medium", size: 13))
                        .foregroundColor(.gray)
                        .padding(.vertical,8)
                        .padding(.horizontal,40)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(Color("back"))
                        )
                }
                Button {
                    dismissNotiPopUp()
                    self.showNotifications.toggle()
                } label: {
                    Text("Yes")
                        .font(.custom("Roboto-Medium", size: 13))
                        .foregroundColor(.white)
                        .padding(.vertical,8)
                        .padding(.horizontal,40)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(Color("darkBlue"))
                        )
                }.fullScreenCover(isPresented: $showNotifications) {
                    NotificationView()
                }
            }.padding(.top,10)
        }.padding(10).padding(.horizontal,10).padding(.vertical,10).background(RoundedRectangle(cornerRadius: 12).fill(.white))
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.top,60).padding(.horizontal,16)
            .transition(.move(edge: .bottom))
            .animation(.spring())
        
    }
}

