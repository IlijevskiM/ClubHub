//
//  ClubOwnerView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/18/23.
//

import SwiftUI
import Amplify
import AmplifyImage

struct ClubOwnerSettingsView: View {
    var club: Club
    var clubProfileKey: String {
        club.id + ".jpg"
    }
    @State var turnOnApprovalRequirement = false
    @State var createEventTapped = false
    @State var isImagePickerVisible: Bool = false
    @State var newClubProfImage: UIImage?
    var columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
    @State var addOwners: Bool = false
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
                        Button {
                            Task { await uploadNewClubProf() }
                        } label:{
                            Text("Change profile")
                                .font(.custom("Roboto-Medium", size: 14))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    /*VStack(spacing: 10) {
                        Image("soBanner")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 65, height: 65)
                            .clipShape(Circle())
                        Text("Change banner")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.blue)
                    }*/
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
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Require approval to join")
                                .font(.custom("Roboto-Regular", size: 16))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Toggle("", isOn: $turnOnApprovalRequirement)
                                .tint(.blue)
                            
                            
                        }
                        
                        Text("Only people who you approve will be able to \njoin this club")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Owners")
                                .font(.custom("Roboto-Regular", size: 16))
                                .foregroundColor(.black)
                            Spacer()
                            Button {
                                self.addOwners.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.blue)
                            }.sheet(isPresented: $addOwners) {
                                AddOwners()
                            }
                        }
                        
                        LazyVGrid(columns: columns, spacing: 10) {
                            Image("p0")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            Image("p1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            Image("p2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            Image("p3")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            Image("p0")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            Image("p1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            Image("p2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                        }
                    }
                    
                    
                    
                    VStack(spacing: 10) {
                        Button {
                            self.createEventTapped.toggle()
                        } label: {
                            Text("Create event")
                                .font(.custom("Roboto-Medium", size: 16))
                                .foregroundColor(.white)
                                .padding(.vertical,10)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(
                                Capsule()
                                    .fill(Color("darkBlue"))
                                )
                                .padding(.top,10)
                        }.fullScreenCover(isPresented: $createEventTapped) {
                            CreateNewEvent(createEventTapped: $createEventTapped)
                        }
                        
                        Button {
                            
                        } label: {
                            Text("Leave club")
                                .font(.custom("Roboto-Medium", size: 16))
                                .foregroundColor(.red)
                                .padding(.vertical,10)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(
                                Capsule()
                                    //.fill(.red)
                                    .stroke(.red, lineWidth: 1)
                                )
                                .padding(.top,10)
                        }
                    }
                }
                
                Spacer()
                
            }.padding(.horizontal,15).padding(.top,15)
            
                .sheet(isPresented: $isImagePickerVisible) {
                    ImagePickerView(image: $newClubProfImage)
                }
        }.navigationTitle(club.clubName)
    }
    
    func uploadNewClubProf()async{
        guard let clubData = newClubProfImage?.jpegData(compressionQuality: 1) else {return}
        do{
            let clubKey = try await Amplify.Storage.uploadData(key: clubProfileKey, data: clubData).value
            print("Finished uploading:", clubKey)
        }catch{
            print(error)
        }
    }
}

