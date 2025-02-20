//
//  ProfileScreen.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify
import Combine

struct ProfileView: View {
    //MARK: View Properties
    @State private var turnOnDarkMode = false
    @State private var textSize: Double = 14
    @State var editProfile = false
    @State var showDeleteSignUp = false
    @State var confirmDeleteSignUp = false
    @State var showPositionPickSignUp = false
    @State var statusClicked = false
    @State var step = 1.0
    
    //MARK: AWS Data
    @EnvironmentObject var userState: UserState
    @State var isImagePickerVisible: Bool = false
    @State var newAvatarImage: UIImage?
    var avatarState: AvatarState {
        newAvatarImage.flatMap({ AvatarState.local(image: $0) }) ?? .remote(avatarKey: userState.userAvatarKey)
    }
    //@Binding var postPublisher: User
    //@Binding var commentPublisher: User
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 35) {
                        // header
                        VStack(spacing: 5) {
                            
                            AvatarView(state: avatarState,
                                       fromMemoryCache: true
                            )
                            .frame(width: 80, height: 80)
                            .onChange(of: avatarState) { _ in
                                Task { await uploadNewAvatar() }
                            }
                            .background(
                            Circle()
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                            )
                            .clipShape(Circle())
                            .padding(.bottom,5)
                            .overlay(alignment: .bottomTrailing) {
                                Button {
                                    isImagePickerVisible = true
                                } label: {
                                    Image("editProfileImage")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Circle().fill(Color("darkBlue")).shadow(radius: 2))
                                }
                            }
                            
                            
                            HStack(spacing: 3) {
                                Text(userState.firstName)
                                    .font(.custom("Roboto-Medium", size: 20))
                                    .foregroundColor(.black)
                                Text(userState.lastName)
                                    .font(.custom("Roboto-Medium", size: 20))
                                    .foregroundColor(.black)
                            }
                            Text(verbatim: userState.email)
                                .font(.custom("Roboto-Regular", size: 16))
                                .foregroundColor(.gray)
                            
                            /*Button {
                                self.statusClicked.toggle()
                            } label: {
                                HStack(spacing: 10) {
                                    Text("Available")
                                        .font(.custom("Roboto-Regular", size: 14))
                                        .foregroundColor(.gray)
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.green)
                                }.padding(.horizontal,10).padding(.vertical,5).background(Capsule().strokeBorder(Color("back"), lineWidth: 1)).padding(.top,5)
                            }.sheet(isPresented: $statusClicked) {
                                VStack(alignment: .leading, spacing: 25) {
                                    HStack {
                                        Text("Available")
                                            .font(.custom("Roboto-Regular", size: 16))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.green)
                                    }
                                    
                                    HStack {
                                        Text("Busy")
                                            .font(.custom("Roboto-Regular", size: 16))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.red)
                                    }
                                    
                                    HStack {
                                        Text("Do not disturb")
                                            .font(.custom("Roboto-Regular", size: 16))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Image(systemName: "minus.circle.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.red)
                                    }
                                    
                                    HStack {
                                        Text("Be right back")
                                            .font(.custom("Roboto-Regular", size: 16))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Image(systemName: "clock.badge.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.yellow)
                                    }
                                    
                                    HStack {
                                        Text("Away")
                                            .font(.custom("Roboto-Regular", size: 16))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Image(systemName: "clock.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.yellow)
                                    }
                                    
                                    HStack {
                                        Text("Offline")
                                            .font(.custom("Roboto-Regular", size: 16))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Image(systemName: "multiply.circle")
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                    }
                                }.padding(.horizontal,15).presentationDetents([.fraction(0.35)])
                            }*/
                            
                    }.padding(.bottom,5)
                        
                        //account
                        VStack(alignment: .leading, spacing: 25) {
                            Header(title: "ACCOUNT")
                            NavigationLink {
                                UsernamePage()
                            } label: {
                                Tabs(image: "username", title: "Username")
                            }
                            NavigationLink {
                                EmailPage()
                            } label: {
                                Tabs(image: "email", title: "Email")
                            }
                            NavigationLink {
                                PasswordPage()
                            } label: {
                                Tabs(image: "password", title: "Password")
                            }
                            /*NavigationLink {
                                SchoolPage()
                            } label: {
                                Tabs(image: "school", title: "School")
                            }.disabled(true)*/
                            
                        }.padding(.horizontal,15)
                        
                        //content
                        VStack(alignment: .leading, spacing: 25) {
                            Header(title: "CONTENT")
                            NavigationLink {
                                HoursPage()
                            } label: {
                                Tabs(image: "hours", title: "Hours")
                            }
                            NavigationLink {
                                SavedPage()
                            } label: {
                                Tabs(image: "saved", title: "Saved")
                            }.navigationBarTitle("")
                            NavigationLink {
                                SignedUpEventsPage(showDeleteSignUp: $showDeleteSignUp, confirmDeleteSignUp: $confirmDeleteSignUp, showPositionPickSignUp: $showPositionPickSignUp, confirmPositionSignUp: $showPositionPickSignUp)
                            } label: {
                                Tabs(image: "signedup", title: "Signed Up Events")
                            }.navigationBarTitle("")
                            NavigationLink {
                                PostsCommentsPage()
                            } label: {
                                Tabs(image: "postsandcomments", title: "Posts and Comments")
                            }
                            
                        }.padding(.horizontal,15)
                        
                        //preferences
                        VStack(alignment: .leading, spacing: 25) {
                            Header(title: "PREFERENCES")
                            HStack(spacing: 10) {
                                Image("fontsize")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.black)
                                
                                Text("Text Size")
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                HStack(spacing: 5) {
                                    /*Text("\(textSize)")
                                     .font(.custom("Roboto-Regular", size: 14))
                                     .foregroundColor(.black)*/
                                    Slider(value: $textSize, in: 14...18, step: step)
                                        .frame(width: 100)
                                }
                            }
                            HStack(spacing: 10) {
                                Image("darkmode")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.black)
                                
                                Text("Dark Mode")
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                Toggle("", isOn: $turnOnDarkMode)
                                    .tint(.blue)
                            }
                            
                        }.padding(.horizontal,15)
                        
                        //about
                        VStack(alignment: .leading, spacing: 25) {
                            Header(title: "ABOUT")
                            Tabs(image: "contentpolicy", title: "Content Policy")
                            Tabs(image: "privacypolicy", title: "Privacy Policy")
                            Tabs(image: "useragreement", title: "User Agreement")
                            
                        }.padding(.horizontal,15)
                        //support
                        VStack(alignment: .leading, spacing: 25) {
                            Header(title: "SUPPORT")
                            Tabs(image: "helpcenter", title: "Help Center")
                            Tabs(image: "reportissue", title: "Report an issue")
                            Button {
                                Task { await signOut() }
                            } label: {
                                Tabs(image: "logout", title: "Log Out")
                            }
                            Button{
                                Task { await deleteAccount() }
                            } label:{
                                HStack(spacing: 10) {
                                    Image("trash")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.red)
                                    
                                    Text("Delete Account")
                                        .font(.custom("Roboto-Regular", size: 16))
                                        .foregroundColor(.red)
                                    
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                        }.padding(.horizontal,15)
                    }.padding(.top,25).padding(.bottom,55)
            }.padding(.bottom,10)
        }
        .sheet(isPresented: $isImagePickerVisible) {
            ImagePickerView(image: $newAvatarImage)
        }
    }
    
    func signOut()async{
        do{
            _ = await Amplify.Auth.signOut()
            print("Signed out")
            _ = try await Amplify.DataStore.clear()
        }catch{
            print(error)
        }
    }
    
    func deleteAccount()async{
        do{
            try await Amplify.Auth.deleteUser()
            print("Successfully deleted user")
        }catch let error as AuthError{
            print("Delete user failed with error: \(error)")
        } catch{
            print("Unexpected error: \(error)")
        }
    }
    
    func uploadNewAvatar()async{
        guard let avatarData = newAvatarImage?.jpegData(compressionQuality: 1) else {return}
        do{
            let avatarKey = try await Amplify.Storage.uploadData(key: userState.userAvatarKey, data: avatarData).value
            print("Finished uploading:", avatarKey)
        }catch{
            print(error)
        }
    }
}

func ChangeProfile(icon: String, type: String)->some View {
    HStack(spacing: 10) {
        Image(icon)
            .resizable()
            .renderingMode(.template)
            .frame(width: 20, height: 20)
            .foregroundColor(.black)
        
        Text(type)
            .font(.custom("Roboto-Regular", size: 16))
            .foregroundColor(.black)
        
        Spacer()
    }
}

func Header(title: String)-> some View {
    Text(title)
        .font(.custom("Roboto-Medium", size: 14))
        .foregroundColor(Color("darkGray"))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Rectangle().fill(.gray.opacity(0.1)).frame(width: 500, height: 35))
}

func Tabs(image: String, title: String)-> some View {
    HStack(spacing: 10) {
        Image(image)
            .resizable()
            .renderingMode(.template)
            .frame(width: 20, height: 20)
            .foregroundColor(.black)
        
        Text(title)
            .font(.custom("Roboto-Regular", size: 16))
            .foregroundColor(.black)
        
        Spacer()
        Image(systemName: "chevron.right")
            .font(.system(size: 15))
            .foregroundColor(.gray)
    }
}

func ClubOwnerTab(image: String, title: String)-> some View {
    HStack(spacing: 10) {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 20, height: 20)
            .clipShape(Circle())
        
        Text(title)
            .font(.custom("Roboto-Regular", size: 16))
            .foregroundColor(.black)
        
        Spacer()
        Image(systemName: "chevron.right")
            .font(.system(size: 15))
            .foregroundColor(.gray)
    }
}

struct PasswordPage: View {
    @EnvironmentObject var userState: UserState
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                    
                    HStack(spacing: 0) {
                        
                        Text("password goes here...(fix)")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.gray)
                        
                    }.padding(.horizontal,15).frame(height: 45).frame(maxWidth: .infinity, alignment: .leading).background(Color.white).background(Rectangle().stroke(Color.gray, lineWidth: 0.25))
                
                Text("Change password")
                    .font(.custom("Roboto-Medium", size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal,15)
                    .padding(.vertical,10)
                    .background(Capsule().fill(Color("darkBlue")))

            }.frame(maxHeight: .infinity, alignment: .top).padding(.top).background(Color("back"))
        }.navigationTitle("Password")
    }
}

struct EmailPage: View {
    @EnvironmentObject var userState: UserState
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                    
                    HStack(spacing: 0) {
                        
                        Text(verbatim: userState.email)
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.gray)
                        
                    }.padding(.horizontal,15).frame(height: 45).frame(maxWidth: .infinity, alignment: .leading).background(Color.white).background(Rectangle().stroke(Color.gray, lineWidth: 0.25))
                
                Text("Change email")
                    .font(.custom("Roboto-Medium", size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal,15)
                    .padding(.vertical,10)
                    .background(Capsule().fill(Color("darkBlue")))

            }.frame(maxHeight: .infinity, alignment: .top).padding(.top).background(Color("back"))
        }.navigationTitle("Email")
    }
}

struct UsernamePage: View {
    @EnvironmentObject var userState: UserState
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                    
                    HStack(spacing: 0) {
                        
                        Text("@\(userState.username)")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.gray)
                        
                    }.padding(.horizontal,15).frame(height: 45).frame(maxWidth: .infinity, alignment: .leading).background(Color.white).background(Rectangle().stroke(Color.gray, lineWidth: 0.25))
                
                Text("Change username")
                    .font(.custom("Roboto-Medium", size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal,15)
                    .padding(.vertical,10)
                    .background(Capsule().fill(Color("darkBlue")))

            }.frame(maxHeight: .infinity, alignment: .top).padding(.top).background(Color("back"))
        }.navigationTitle("Username")
    }
}

struct SignedUpEventsPage: View {
    @State var currentTab = "All"
    @Binding var showDeleteSignUp: Bool
    @Binding var confirmDeleteSignUp: Bool
    @Binding var showPositionPickSignUp: Bool
    @Binding var confirmPositionSignUp: Bool
    //@StateObject var allEventData = getEventSearchData()
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            SavedBar(currentTab: $currentTab, tabTitle: "All")
                            SavedBar(currentTab: $currentTab, tabTitle: "Past")
                            SavedBar(currentTab: $currentTab, tabTitle: "Science Olympiad")
                            SavedBar(currentTab: $currentTab, tabTitle: "Key Club")
                            SavedBar(currentTab: $currentTab, tabTitle: "Chess")
                            SavedBar(currentTab: $currentTab, tabTitle: "Care")
                            SavedBar(currentTab: $currentTab, tabTitle: "Model United Nations")
                            SavedBar(currentTab: $currentTab, tabTitle: "National Honors Society")
                            SavedBar(currentTab: $currentTab, tabTitle: "Student Council")
                        }.padding(.horizontal,10)
                    }.padding(.vertical,5).padding(.bottom,3)
                        .background(.white)
                }
                
                Divider()
                
                /*ExampleMeetingEvent(showDeleteSignUp: $showDeleteSignUp, confirmDeleteSignUp: $confirmDeleteSignUp, showPositionPickSignUp: $showPositionPickSignUp, confirmPositionSignUp: $confirmPositionSignUp)*/
                
            }.background(Color("back"))
        }.navigationTitle("Signed Up Events")
    }
}

struct PostsCommentsPage: View{
    @Namespace var animation
    @State var current = "Posts"
    let step: CGFloat = 1
    //MARK: AWS Data
    @EnvironmentObject var userState: UserState
    @State var posts: [Post] = []
    @State var comments: [Comment] = []
    @State var tokens: Set<AnyCancellable> = []
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                //VStack(spacing: 0) {
                    HStack(spacing: 60) {
                        PostsCommentsBar(current: $current, title: "Posts", animation: animation)
                        PostsCommentsBar(current: $current, title: "Comments", animation: animation)
                    }
                //}
                
                Divider()
                
                if current == "Posts" {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 5){
                            if posts.isEmpty {
                                Text("No posts yet...")
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.top,35)
                            } else {
                                ForEach(posts) { post in
                                    ReusablePost(post: post)
                                }
                            }
                        }.padding(.bottom,20).onAppear(perform: observeCurrentUsersPosts)
                    }.background(Color("back"))//.scrollDismissesKeyboard(.immediately)
                } else if current == "Comments" {
                // example comments
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 5){
                        if comments.isEmpty {
                            Text("No comments yet...")
                                .font(.custom("Roboto-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top,35)
                        } else {
                            ForEach(comments) { comment in
                                MyReusableComment(comment: comment)
                                }
                            }
                        }.padding(.bottom,20)
                        .onAppear(perform: observeCurrentUsersComments)
                    }.background(Color("back"))
                }
            }
            //Spacer()
        }.navigationTitle("Posts and Comments")
    }
    
    func observeCurrentUsersPosts() {
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: Post.self, where: Post.keys.userID == userState.userId))
            .map(\.items)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print($0) }
                  , receiveValue: { posts in
                print("Post count:", posts.count)
                self.posts = posts.sorted {
                    //guard
                        let date1 = $0.publishedTime//,
                          let date2 = $1.publishedTime// else {return false}
                    return date1 > date2
                }
            }
        )
        .store(in: &tokens)
    }
    
    func observeCurrentUsersComments() {
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: Comment.self, where: Comment.keys.userID == userState.userId))
            .map(\.items)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print($0) }
                  , receiveValue: { comments in
                print("Comment count:", comments.count)
                self.comments = comments.sorted {
                   // guard
                        let date1 = $0.publishedTime//,
                          let date2 = $1.publishedTime// else {return false}
                    return date1 > date2
                }
            }
        )
        .store(in: &tokens)
    }
}

/*struct SchoolPage: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Eisenhower High School ")
                    .font(.custom("Roboto-Regular", size: 18))
                    .foregroundColor(.black)
                    .padding(.vertical,5)
                    .frame(alignment: .leading)
                    .background(Rectangle().fill(.white))
                
                Text("Change school")
                    .font(.custom("Roboto-Medium", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal,15)
                    .padding(.vertical,10)
                    .background(Capsule().fill(Color("darkBlue")))
            }.frame(maxHeight: .infinity, alignment: .top)
        }.navigationTitle("School").toolbarBackground(.visible, for: .navigationBar)
    }
}*/

struct PostsCommentsBar: View {
    @Binding var current : String
    var title : String
    var animation : Namespace.ID
    
    var body: some View {
        
        HStack {
            
            Button(action: {
                withAnimation{current = title}
            }) {
                
                HStack {
                    
                    VStack(spacing: 6) {
                    
                    Text(title)
                        .font(.custom("Roboto-Medium", size: 16))
                        .foregroundColor(current == title ? Color.black : Color("darkGray"))
                        .padding(.horizontal)
                        
                        

                        // matched geometry effect slide animation
                        
                        if current == title {
                            Capsule()
                                .fill(.blue)
                                .frame(width: title == "Comments" ? 77 : 42, height: 2.5)
                                .matchedGeometryEffect(id: "Tab", in: animation)
                            
                        } else {
                            Capsule()
                                .fill(.clear)
                                .frame(width: title == "Comments" ? 77 : 42, height: 2.5)
                        }
                    }
                }
            }
            
            }
    }
}

struct CourseListDG: Identifiable {
    var id = UUID()
    var title: String
    var nameofdescription: String
    var hoursRecieved: String
}

extension CourseListDG {
    static var sampleData: [CourseListDG] {
        [
            CourseListDG(title: "Meetings", nameofdescription: "05/02/23", hoursRecieved: ".5/.5"),
            CourseListDG(title: "Events", nameofdescription: "Elementary School Demonstration", hoursRecieved: "3/3"),
            CourseListDG(title: "Donations", nameofdescription: "Junior High Supplies", hoursRecieved: "2.5/5")
        ]
    }
}

// Club grid model data..
struct SavedClub: Identifiable {
    var id: Int
    var clubProfile: String
    var clubName: String
}

var savedclub = [

    SavedClub(id: 0, clubProfile: "so", clubName: "Science Olympiad"),
    SavedClub(id: 1, clubProfile: "chess", clubName: "Chess"),
    SavedClub(id: 2, clubProfile: "kc", clubName: "Key Club"),
    SavedClub(id: 3, clubProfile: "care", clubName: "Care"),
    SavedClub(id: 4, clubProfile: "nhs", clubName: "National Honors Society"),
    SavedClub(id: 5, clubProfile: "mun", clubName: "Model United Nations"),
]


