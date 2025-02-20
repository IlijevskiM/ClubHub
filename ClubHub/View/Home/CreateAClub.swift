//
//  CreateAClub.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 7/3/23.
//

import SwiftUI
import Amplify

struct CreateAClub: View {
    @EnvironmentObject var userState: UserState
    @State var clubName: String = ""
    @State var clubCode: String = ""
    @State var createClub: Bool = false
    @State var clubProfileImage: UIImage?
    @State var clubBannerImage: UIImage?
    @State var shouldShowImagePicker: Bool = false
    @Binding var createAClub: Bool
    @Binding var showMenu: Bool
    @State var isLoading = false
    @State var addOwners = false
    var body: some View {
        
        VStack(spacing: 0){
            Text("Create a club")
                .font(.custom("Roboto-Regular", size: 18))
                .padding(.top,20)
                .padding(.bottom,15)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .frame(alignment: .top)
            
            Divider()
            
            HStack(spacing: 35) {
                VStack(spacing: 8) {
                    if let profileImage = self.clubProfileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 78, height: 78)
                            .clipShape(Circle())
                            .background(
                                Circle().fill(.gray.opacity(0.1)).background(Circle().stroke(.gray, lineWidth: 0.5))
                            )
                            .padding(.top,20)
                    } else {
                        Image("camera")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                            .padding(25)
                            .background(
                                Circle().fill(.gray.opacity(0.1)).background(Circle().stroke(.gray, lineWidth: 0.5))
                            )
                            .padding(.top,20)
                    }
                    
                    Button {
                        self.shouldShowImagePicker.toggle()
                    } label: {
                        Text("Select profile")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.blue)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Club Name")
                        .font(.custom("Roboto-Regular", size: 16))
                        .padding(.vertical,10)
                        .foregroundColor(.black)
        
                        
                        TextField("Club name", text: $clubName)
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10).stroke(Color("back"), lineWidth: 2)
                                )
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Club Code")
                        .font(.custom("Roboto-Regular", size: 16))
                        .padding(.vertical,10)
                        .foregroundColor(.black)
        
                        
                        TextField("Club code", text: $clubCode)
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10).stroke(Color("back"), lineWidth: 2)
                                )
                }
                
                VStack(spacing: 5){
                    HStack {
                       Text("Add Owners")
                            .font(.custom("Roboto-Medium", size: 16))
                            .foregroundColor(Color("darkBlue"))
                        
                        Spacer()
                        
                        Button {
                            self.addOwners.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(5)
                                .background(
                                    Circle().stroke(Color("back"), lineWidth: 2)
                                )
                        }.sheet(isPresented: $addOwners) {
                            //TODO: Make the
                            AddOwners()
                        }
                    }
                }
                
                Button {
                    //showMenu = false
                    Task { await createClub() }
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.createAClub = false
                    }
                    dismissKeyboard()
                } label: {
                    Text("Create club")
                        .font(.custom("Roboto-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(
                        Capsule()
                            .fill(Color("darkBlue"))
                        )
                        .padding(.top,10)
                }.disabled(clubCode.isEmpty || clubName.isEmpty || clubProfileImage == nil).opacity(clubCode.isEmpty || clubName.isEmpty || clubProfileImage == nil ? 0.6 : 1)
                
            }.padding(.horizontal,15).frame(maxHeight: .infinity, alignment: .top).padding(.top)
            
            
        }.background(.white).ignoresSafeArea(.all, edges: .vertical)
            .sheet(isPresented: $shouldShowImagePicker) {
                ImagePickerView(image: $clubProfileImage)
            }
            .overlay (
                ZStack(
                       content: {
                           
                    if isLoading{
                        Color.white
                            .ignoresSafeArea()
                        LoadingScreenForNewClub(isLoading: $isLoading)
                    }
                })
            )
    }
    
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
    
    func createClub()async{
        guard let imageProfileData = clubProfileImage.flatMap({ $0.jpegData(compressionQuality: 1)} )
        else {return}
        let clubId = UUID().uuidString
        let clubProfKey = clubId + ".jpg"
        //let user = User(id: userState.userId, username: userState.username, firstName: userState.firstName, lastName: userState.lastName, email: userState.email, userAttemptsForClubOwnerCode: userState.userAttemptsForClubOwnerCode, userIsAddedToGroup: userState.userIsAddedToGroup)
        
        do {
            let profileKey = try await Amplify.Storage.uploadData(key: clubProfKey, data: imageProfileData).value
            let newClub = Club(id: clubId, clubProfileKey: profileKey, clubName: clubName, clubCode: clubCode, publishedTime: .now(), members: [], creators: [userState.userId])
            //let clubUser = ClubUser(club: newClub, user: user)
            
            let savedClub = try await Amplify.DataStore.save(newClub)
            //_ = try await Amplify.DataStore.save(clubUser)
            print("Saved club: \(savedClub)")
            //print("Saved club creator to ClubUser table: \(clubUser)")
            
        }catch let error as DataStoreError{
            print("Failed with error \(error)")
        }catch{
            print("Unexpected error \(error)")
        }
    }
}

struct AddOwners: View {
    @EnvironmentObject var userState: UserState
    var body: some View {
        VStack {
            HStack {
                //MARK: Mock data
                Text("5 selected")
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(Color("darkGray"))
                Spacer()
                Text("Add Owners")
                    .font(.custom("Roboto-Medium", size: 16))
                    .foregroundColor(.black)
                Spacer()
                Button {
                    
                } label: {
                    Text("Done")
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(Color("darkBlue"))
                }
            }
            Divider()
            
            AddOwnersSearchBar()
            
            //TODO: Have all the members queried here and a spacer with open circled checks so you can select who you want to add
            
        }.padding(.top,10)
    }
    
    /*func addUserAsOwner()async{
        do {
            var club = Club(id: Club.keys.id.rawValue, clubProfileKey: Club.keys.clubProfileKey.rawValue, clubName: Club.keys.clubName.rawValue, clubCode: Club.keys.clubCode.rawValue, publishedTime: try Temporal.DateTime(iso8601String: Club.keys.publishedTime.rawValue), userID: Club.keys.userID.rawValue)
            club.createdBy.append(userState.userId)
            let savedUser = try await Amplify.DataStore.save(club)
        }catch let error as DataStoreError{
            print("Error adding user as an owner: \(error)")
        } catch{
            print("Unexpected error: \(error)")
        }
    }*/
}

struct AddOwnersSearchBar: View {
    
    @State var text = ""
    
    var body: some View {
            
            HStack {
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                
                TextField("Search people", text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    .font(.system(size: 14))
                
                Spacer()
                
                if self.text != "" {
                    
                    Button {
                        // cancel action
                        self.text = ""
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                            .padding(.trailing,12)
                    }
                    
                } else {
                    
                    Button {
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.clear)
                            .font(.system(size: 12))
                            .padding(.trailing,12)
                    }.disabled(true)
                }
                
                
            }.padding(.vertical,8)
                .padding(.leading,10).background(
                    //RoundedRectangle(cornerRadius: 10)
                    Capsule()
                        .fill(Color("back"))
                )
                .accentColor(.black)
        

    }
}

struct LoadingScreenForNewClub: View {
    @Binding var isLoading: Bool
    var body: some View {
            VStack(spacing: 15){
                ProgressView()
                    .tint(.blue)
                Text("Setting up club...")
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.black)
            }
    }
}
