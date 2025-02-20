//
//  CreateNewPost.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify
import AmplifyImage
//import AVKit
//import AVFoundation
//import PhotosUI
import CoreTransferable
import LinkPresentation

//TODO: Change the club dropsown selector to pull in real club data, not mock
struct CreatePost: View {
    //MARK: View Properties
    @FocusState var isTitleTextFocused: Bool
    @State var height : CGFloat = 0
    @State var publishIsPressed = false
    @State var announcementChecked = false
    @State private var selection: String = "Care"
    @State var linked = false
    @State private var showingPopover = false
    @State var presentAlert = false
    @Environment(\.dismiss) private var dismiss
    @State var showDeletePostPopUp = false
    @State var confirmDeletePost = false
    @State var showPickClubPostPopUp = false
    @State var confirmPickClub = false
    @Binding var showCreatePostPage: Bool
    var column = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    @State var clubCategory: String = ""
    @State var isLoading = false
    //TODO: Change this to UserClub type to get the clubs that the user is actually part of
    @State var clubOptions: [UserClub] = []
    @State var selectedIndex = 0
    //MARK: For files
    @State private var showImporter = false
    @State private var textInFiles = [String]()
    
    //MARK: AWS Data
    @EnvironmentObject var userState: UserState
    //@State var image: UIImage?
    @State var postTitleText = ""
    @State var postLinkText = ""
    @State var postBodyText = ""
    //@State var selectedItems: [PhotosPickerItem] = []
    //@State var videoURL: URL?
    //@State var shouldShowImagePicker: Bool = false
    //@State var shouldShowImageVideoPicker: Bool = false
    var userProfileKey: String {
        userState.userId + ".jpg"
    }
    var body: some View {
                
                VStack {
                    
                    HStack {
                        
                        Button {
                            self.showDeletePostPopUp.toggle()
                            dismissKeyboard()
                        } label: {
                            Text("Cancel")
                                .font(.custom("Roboto-Regular", size: 16))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                            Button{
                                Task { await createPost() }
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.showCreatePostPage = false
                                }
                                dismissKeyboard()
                            } label:{
                                Text("Post")
                                    .font(Font.custom("Roboto-Bold", size: 14))
                                    .foregroundColor(.white)
                                    .padding(.vertical,8)
                                    .padding(.horizontal,20)
                                    .background(
                                        Capsule()
                                            //.fill(Color("darkBlue"))
                                            .fill(Color("darkBlue"))
                                        )
                                    .padding(.trailing,-5)
                            }.navigationTitle("").disabled(postTitleText.isEmpty)
                            .opacity(postTitleText.isEmpty ? 0.6 : 1)

                    }.padding(.bottom,10).padding(.horizontal,20)
                    
                ScrollView(.vertical, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 10) {
                        
                        //AvatarView(state: .remote(avatarKey: userState.userAvatarKey))
                        AmplifyImage(key: userState.userAvatarKey)
                            .kfImage
                            .placeholder {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray.opacity(0.9))
                                    .padding(20)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .background(
                                Circle()
                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Button {
                                self.showPickClubPostPopUp.toggle()
                            } label: {
                                HStack(spacing: 3) {
                                    Text(clubOptions[selectedIndex].club.clubName)
                                        .font(Font.custom("Roboto-Medium", size: 14))
                                        .foregroundColor(Color("darkBlue"))
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color("darkBlue"))
                                }.padding(.horizontal,10).padding(.vertical,5).background(Capsule().stroke(Color("darkBlue"), lineWidth: 1))
                            }.sheet(isPresented: $showPickClubPostPopUp) {
                                NavigationStack {
                                    VStack(spacing: 10) {
                                        Text("Choose club")
                                            .font(.custom("Roboto-Bold", size: 18))
                                            .foregroundColor(.black)
                                            .padding(.top,15)
                                        
                                        ScrollView(.vertical, showsIndicators: false) {
                                            
                                            LazyVStack(alignment: .leading, spacing: 30){
                                                if clubOptions.isEmpty {
                                                    Text("Join a club to start posting")
                                                        .font(.custom("Roboto-Regular", size: 16))
                                                        .foregroundColor(.gray)
                                                        .padding(.top,35)
                                                }else{
                                                    PostClubOptionsView(selectedItem: $selectedIndex, clubOptions: clubOptions, showPickClubPostPopUp: $showPickClubPostPopUp)
                                                    /*ForEach(clubOptions) { club in
                                                        PostClubOptionsView(userClub: club)
                                                            .onTapGesture {
                                                                //self.selectedIndex = club
                                                                //self.selectedItem = index
                                                                showPickClubPostPopUp = false
                                                            }
                                                    }*/
                                                }
                                            }.frame(maxWidth: .infinity, alignment: .leading).padding(.top,10).padding(.horizontal,25)
                                        }
                                    }.padding(.top,5)
                                }
                                    .presentationDetents([.fraction(0.65)]).presentationDragIndicator(.visible)
                            }
                                
                                TextField("Title", text: $postTitleText)
                                    .font(Font.custom("Roboto-Medium", size: 18))
                                    .focused($isTitleTextFocused)
                                    .accentColor(.black)
                                    .textSelection(.enabled)
                            
                                TextField("body text (optional)", text: $postBodyText, axis: .vertical)
                                    .font(Font.custom("Roboto-Regular", size: 16))
                                    .foregroundColor(.black)
                                    .lineSpacing(5)
                                    .lineLimit(30)
                                    .textSelection(.enabled)
                                    .textContentType(.URL)
                            
                            if linked == true {
                                //TODO: Do a max links that you can add (5)
                                VStack(alignment: .leading, spacing: 5) {
                                    // link 1
                                    HStack {
                                        TextField("link", text: $postLinkText)
                                            .font(Font.custom("Roboto-Regular", size: 16))
                                            .foregroundColor(.blue)
                                            .autocorrectionDisabled(true)
                                            .autocapitalization(.none)
                                            .lineSpacing(5)
                                            .textSelection(.enabled)
                                        Spacer()
                                        Button {
                                            self.linked = false
                                            postLinkText = ""
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 14))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    Button {
                                        self.linked.toggle()
                                    } label: {
                                        Text("Add another link")
                                            .font(Font.custom("Roboto-Regular", size: 14))
                                            .foregroundColor(Color("darkBlue"))
                                    }
                                }
                            }
                                        
                            //ScrollView(.horizontal, showsIndicators: false) {
                                //HStack(spacing: 5) {
                                    /*ForEach(arrayOfImages, id: \.cgImage) { image in
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 220)
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        // Delete button
                                            .overlay(alignment: .topTrailing) {
                                                Button{
                                                    //self.image = nil
                                                } label: {
                                                    Image(systemName: "xmark")
                                                        .font(.system(size: 12))
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.white)
                                                        .padding(5)
                                                        .background(Circle().fill(.black.opacity(0.6)))
                                                        .padding(10)
                                                }
                                            }
                                    }*/
                                    //TODO: Fix it so the image deletes when the 'x' is clicked on
                                    //TODO: Fix this else clause so that we can still make a post even tho the image isnt there
                                        /*if let image = self.image {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 220)
                                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            // Delete button
                                                .overlay(alignment: .topTrailing) {
                                                    Button{
                                                        self.image = nil
                                                    } label: {
                                                        Image(systemName: "xmark")
                                                            .font(.system(size: 12))
                                                            .fontWeight(.semibold)
                                                            .foregroundColor(.white)
                                                            .padding(5)
                                                            .background(Circle().fill(.black.opacity(0.6)))
                                                            .padding(10)
                                                    }
                                                }
                                        }*/ /*else if let image = self.image {
                                            Image(uiImage: image)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(height: 220)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                    .hidden()
                                        }*/
                                    
                                    /*if let videoURL = self.videoURL{
                                        var player = AVPlayer()
                                        
                                        VideoPlayer(player: player)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 220)
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        // Delete button
                                            .overlay(alignment: .topTrailing) {
                                                Button{
                                                    self.videoURL = nil
                                                } label: {
                                                    Image(systemName: "xmark")
                                                        .font(.system(size: 12))
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.white)
                                                        .padding(5)
                                                        .background(Circle().fill(.black.opacity(0.6)))
                                                        .padding(10)
                                                }
                                            }
                                        // change the size of the video and overlay a custom play button and pause button and use the built in modifiers in designcode.io
                                            .onAppear(){
                                                player = AVPlayer(url: videoURL)
                                                compressVideo(url: videoURL)
                                            }
                                        
                                        /*presentViewController(playerViewController, animated: true) {
                                            playerViewController.player!.play()
                                          }*/
                                    }*/
                                //}
                            //}
                        }
                    }.padding(.horizontal,20).padding(.top,10)
                        
                    }.scrollDismissesKeyboard(.immediately)
                    
                    Spacer()
                    
                    VStack {
                        Divider()
                        HStack (spacing: 30) {
                            
                            Button {
                                linked = true
                            } label: {
                                Image("link")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(Color("darkGray"))
                            }
                            /*Button {
                                shouldShowImagePicker = true
                            } label: {
                                Image("imagePicker")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(Color("darkGray").opacity(!postLinkText.isEmpty ? 0.6 : 1))
                            }.disabled(!postLinkText.isEmpty)*/
                            
                            Button {
                                self.showImporter.toggle()
                            } label: {
                                Image("attachment")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(Color("darkGray").opacity(!postLinkText.isEmpty ? 0.6 : 1))
                            }//.disabled(!postLinkText.isEmpty)
                                .fileImporter(isPresented: $showImporter,
                                           allowedContentTypes: [.plainText],
                                           allowsMultipleSelection: true) { result in

                                  switch result {
                                  case .failure(let error):
                                      print("Error selecting file: \(error.localizedDescription)")
                                  case .success(let urls):
                                     textInFiles = []
                                     for url in urls {
                                         do {
                                             if url.startAccessingSecurityScopedResource() {
                                                 textInFiles.append(try String(contentsOf: url))
                                                 url.stopAccessingSecurityScopedResource()
                                             }
                                         } catch let error {
                                             print("Error reading file \(error.localizedDescription)")
                                         }
                                     }
                                 }
                             }
                            
                            Spacer()
                        }.padding(.bottom,10).padding(.horizontal,20)
                    }
                }
            .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isTitleTextFocused = true
                    }
                }
            .overlay (
                ZStack(
                    //alignment: .top,
                       content: {
                    
                    if showDeletePostPopUp{
                        
                        Color.black.opacity(0.1)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    showDeletePostPopUp.toggle()
                                }
                            }
                            .ignoresSafeArea()
                        RemovePostPopUp(showDeletePostPopUp: $showDeletePostPopUp, confirmDeletePost: $confirmDeletePost, showCreatePostPage: $showCreatePostPage, postTitleText: $postTitleText, postBodyText: $postBodyText, postLinkText: $postLinkText, selectedIndex: $selectedIndex, clubOptions: $clubOptions)

                    }
                    if isLoading{
                        Color.white
                        .ignoresSafeArea()
                        LoadingScreenForNewPost(isLoading: $isLoading)
                    }
                })
            )//.photosPicker(isPresented: $shouldShowImagePicker, selection: $selectedItems)
            /*.sheet(isPresented: $shouldShowImagePicker) {
                ImagePickerView(image: $image)
            }*/
        }
    
    /*func compressVideo(url: URL) {
        let asset = AVAsset(url: url)
            let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let compressedVideoURL = documentsPath.appendingPathComponent("compressedVideo.mp4")
            
            if FileManager.default.fileExists(atPath: compressedVideoURL.path) {
                try? FileManager.default.removeItem(at: compressedVideoURL)
            }
            
            exportSession?.outputURL = compressedVideoURL
            exportSession?.outputFileType = AVFileType.mp4
            exportSession?.shouldOptimizeForNetworkUse = true
            exportSession?.exportAsynchronously {
                print("Completed Compression")
            }
        }*/
    
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
    
    func createPost() async{
        //guard let imageData = image.flatMap({ $0.jpegData(compressionQuality: 1)} )
        //else {return}
        let postId = UUID().uuidString
        //let postImageKey = postId + ".jpg"
        //let postVideoKey = postId + ".mp4"
        
        do{
            //let key = try await Amplify.Storage.uploadData(key: postImageKey, data: imageData).value
            //let videoKey = try await Amplify.Storage.uploadFile(key: postVideoKey, local: videoURL ?? URL(fileURLWithPath: "")).value
            let newPost = Post(id: postId, clubCategory: clubOptions[selectedIndex].club.clubName, title: postTitleText, bodyText: postBodyText, link: postLinkText, firstName: userState.firstName, lastName: userState.lastName, username: userState.username, likes: 0, saved: false, liked: false, publishedTime: .now(), userID: userState.userId)
            
            let savedPost = try await Amplify.DataStore.save(newPost)
            print("Saved post: \(savedPost)")
            
            //self.showCreatePostPage = false
            
            postTitleText = ""
            postBodyText = ""
            postLinkText = ""
            //self.image = nil
        }catch let error as DataStoreError{
            print("Failed with error \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }
}

struct PostClubOptionsView: View {
    //var clubItems: [SelectedClub]
    @Binding var selectedItem: Int
    var clubOptions: [UserClub]
    //var userClub: UserClub
    @Binding var showPickClubPostPopUp: Bool
    var body: some View {
        
        ForEach(clubOptions.indices, id: \.self) { index in
            HStack {
                HStack(spacing: 15){
                    //AmplifyImage(key: userClub.club.clubProfileKey)
                    AmplifyImage(key: clubOptions[index].club.clubProfileKey)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                        )
                    VStack(alignment: .leading, spacing: 3){
                        Text(clubOptions[index].club.clubName)
                        //Text(userClub.club.clubName)
                            .font(.custom("Roboto-Regular", size: 18))
                            .foregroundColor(.black)
                        
                        //MARK: Do i really need this?
                        /*HStack(spacing: 3) {
                            Text(self.clubItems[index].numberOfMembers)
                                .font(.custom("Roboto-Regular", size: 14))
                                .foregroundColor(.gray)
                            if self.clubItems[index].numberOfMembers == "1" {
                                Text("member")
                                    .font(.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(.gray)
                            } else {
                                Text("members")
                                    .font(.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(.gray)
                            }
                        }*/
                    }
                }
                    
                    Spacer()
                    
                NavigationLink {
                    //TODO: Figure out how to visit the club by passing in a userClub instance rather than a club instacne because ClubProfileScreen takes in a type club, not userClub
                    
                } label: {
                    Text("Visit")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.black)
                        .padding(.horizontal,15)
                        .padding(.vertical,5)
                        .background(
                        Capsule()
                            .stroke(Color("back"), lineWidth: 1.5)
                        )
                }.navigationBarBackButtonHidden(true).navigationTitle("")
            }
            .onTapGesture {
                selectedItem = index
                showPickClubPostPopUp = false
            }
        }
    }
}

struct Clubs: Identifiable{
    var id = UUID().uuidString
    var title: String
    var image: String
    var memberCount: String
}

var clubModel = [
    Clubs(title: "Science Olympiad", image: "so", memberCount: "25"),
    Clubs(title: "Key Club", image: "kc", memberCount: "103"),
    Clubs(title: "Chess", image: "chess", memberCount: "1"),
    Clubs(title: "Care", image: "care", memberCount: "86"),
    Clubs(title: "Model United Nations", image: "mun", memberCount: "34"),
    Clubs(title: "National Honors Society", image: "nhs", memberCount: "345"),
]

/*struct SelectedClub {
    let image: String
    let clubName: String
    let numberOfMembers: String
}*/

struct LoadingScreenForNewPost: View {
    @Binding var isLoading: Bool
    var body: some View {
            VStack(spacing: 15){
                ProgressView()
                    .tint(.blue)
                Text("Making post...")
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.black)
            }
    }
}
