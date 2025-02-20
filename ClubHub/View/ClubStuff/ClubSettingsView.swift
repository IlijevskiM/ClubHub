//
//  ClubSettingsView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 7/24/23.
//

import SwiftUI
import Amplify
import AmplifyImage

struct ClubSettingsView: View {
    //var userClub: UserClub
    /*var clubProfileKey: String {
        userClub.club.id + ".jpg"
    }*/
    var club: Club
    var clubProfileKey: String {
        club.id + ".jpg"
    }
    @State var turnOnApprovalRequirement = false
    @State var createEventTapped = false
    @State var isImagePickerVisible: Bool = false
    @State var newClubProfImage: UIImage?
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack(spacing: 35) {
                    
                    VStack(spacing: 10) {
                        AmplifyImage(key: club.clubProfileKey)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 65, height: 65)
                            .clipShape(Circle())
                    }
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Club Name")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                        
                        Text(club.clubName)
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.gray)
                            .padding(.vertical, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10).stroke(Color("back"), lineWidth: 2)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Club Code")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                        
                        Text("@\(club.clubCode)")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10).stroke(Color("back"), lineWidth: 2)
                            )
                    }
                    
                    Spacer()
                    
                }.padding(.horizontal,15).padding(.top,15)
            }.navigationTitle(club.clubName)
        }
    }
}
