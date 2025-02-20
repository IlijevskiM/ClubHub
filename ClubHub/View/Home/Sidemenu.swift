//
//  SideMenu.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify
import AmplifyImage
import Combine
import AWSS3

struct Sidemenu: View {
    @EnvironmentObject var userState: UserState
    @Binding var showMenu: Bool
    let black = Color("AccentColor")
    let white = Color("white")
    @State var selectedTab = "homeUnfilled"
    @State var clubIsExpanded = false
    @State var eventIsExpanded = false
    @State var addIsPressed = false
    @State var chipSelected = false
    @State var firstPage = true
    @State var joinNewClub = false
    @State var clubOwnerAccessClicked = false
    @State var isExpanded = false
    @State private var isChecked = false
    let accentColor = Color("AccentColor")
    @State private var clubName: String = ""
    @State private var clubLeader: String = ""
    @State private var clubCode: String = ""
    @State private var clubObjectives: String = ""
    @State var createAClub = false
    
    @State var searchMessage = ""
    @Namespace var animation
    //@State var enterJoinCode = ""
    @FocusState var isEnterJoinCodeFocused: Bool
    @State var searchClubs = false
    @State var percent : CGFloat = 0
    @State var next = false
    @State var settingsPopUp: Bool = false
    @State var addClub = false
    @State var clubJoined = false
    @State var createAClubButtonIsHidden = true
    @State var clubOwnerAccessCodeButtonIsHidden = false
    
    @State var clubsOwned: [Club] = []
    //TODO: Does this have to be changed to type UserClub? - w/out getting an error that ClubCell doesnt take type UserClub
    @State var clubsJoined: [UserClub] = []
    @State var ownerAccessCodeSessionTimedOut: Bool = false
    @State var clubCreatedTokens: Set<AnyCancellable> = []
    @State var clubJoinedTokens: Set<AnyCancellable> = []
    var body: some View {
        //MARK: You have to call a function to observe a model towards the end of the struct so it can observe the entire screen or else it WILL give a Datastore error/not work
        VStack(alignment: .leading, spacing: 15) {
            
                Text("Clubs Owned")
                    .font(.custom("Roboto-Medium", size: 14))
                    .foregroundColor(.gray)
                
            //TODO: Clubs Owned isnt showing up ... FIX
                if !clubsOwned.isEmpty {
                    LazyVStack(alignment: .leading, spacing: 20) {
                            ForEach(clubsOwned) { club in
                                ClubCell(club: club)
                            }.onAppear {
                                observeClubsCreated()
                            }
                    }
                    .padding(.bottom,5)
                }
                
                Text("Clubs Joined")
                    .font(.custom("Roboto-Medium", size: 14))
                    .foregroundColor(.gray)
                
                if !clubsJoined.isEmpty {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(clubsJoined) { userClub in
                            //ClubCell(club: club)
                            JoinedClubCell(userClub: userClub)
                        }.onAppear {
                            observeClubsJoined()
                        }
                    }
                }
            
            
            Divider()
            
            Button {
                self.joinNewClub.toggle()
            } label: {
                HStack(spacing: 8) {
                    Image("joinClub")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                    Text("Join existing club")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                }.padding(.bottom,5)
            }.sheet(isPresented: $joinNewClub) {
                JoinClub(joinNewClub: $joinNewClub, showMenu: $showMenu)
            }
            
            //TODO: Don't have the userIsAddedToGroup be stored locally... figure out a way to do user.userIsAddedToGroup == true without creating a user object
            //if userState.userIsAddedToGroup == true {
                Button {
                    self.createAClub.toggle()
                } label: {
                    HStack(spacing: 8) {
                        Image("plus")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 18, height: 18)
                            .foregroundColor(.black)
                        Text("Create a club")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                    }.padding(.bottom,5)
                }.sheet(isPresented: $createAClub) {
                    CreateAClub(createAClub: $createAClub, showMenu: $showMenu)
                }
            //}
            //TODO: Don't have the userIsAddedToGroup be stored locally... figure out a way to do user.userIsAddedToGroup == false without creating a user object
            //if userState.userIsAddedToGroup == false {
                Button {
                    self.clubOwnerAccessClicked.toggle()
                } label: {
                    HStack(spacing: 8) {
                        Image("passcode")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 18, height: 18)
                            .foregroundColor(.black)
                        Text("Club owner access code")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                    }.padding(.bottom,3)
                }.sheet(isPresented: $clubOwnerAccessClicked) {
                    ClubOwnerAccessCodeView(ownerAccessCodeSessionTimedOut: $ownerAccessCodeSessionTimedOut, clubOwnerAccessClicked: $clubOwnerAccessClicked)
                }.disabled(ownerAccessCodeSessionTimedOut == true).opacity(ownerAccessCodeSessionTimedOut == true ? 0.6 : 1)
            //}
            Spacer()
        }
            
        
            .padding(.vertical,20).padding(.horizontal,15).ignoresSafeArea(.all, edges: .horizontal)
            .background(Color.white).padding(.top,35)
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
        //Max width...
            .frame(width: getRect().width - 90)
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(.all, edges: [.horizontal, .vertical])
    }
    
    //TODO: Figure out how to show/hide the create a club button & the club owner access code button
    /*func checkIfUserIsAddedToGroup()async{
        do{
            let queriedUser = try await Amplify.DataStore.query(User.self)
            for user in queriedUser {
                // OR if (user.groups.contains("ClubOwner") != nil))
                if user.userIsAddedToGroup == true {
                    // (show) create a club button, (hide) club owner access code button
                } else {
                    // (hide) create a club button, (show) club owner access code button
                }
            }
        }catch{
            print("DEBUG: Failed to complete task - \(error)")
        }
    }*/
    
    //TODO: Figure out how to query only the clubs the users owns
    func observeClubsCreated(){
        //TODO: Create a createdBy field and pass in the user's id, then do the "where: " and do userState.userId == Club.keys.createdBy || and then find a way to make a statement where the user is added as a leader
        //TODO: Query ClubUser table instead so you can easily add more owners that way
        
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: Club.self
                                                                //, where: Club.keys.creators.contains(userState.userId)
                                                               )
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
              receiveValue: { clubsOwned in
            self.clubsOwned = clubsOwned.sorted {
                //guard
                let date1 = $0.publishedTime//,
                let date2 = $1.publishedTime
                //else {return false}
                return date1 > date2
                 }
            }
        )
        .store(in: &clubCreatedTokens)
    }
    
    //TODO: Figure out how to query only the clubs the user joins
    func observeClubsJoined(){
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: UserClub.self
                                                                //, where: UserClub.keys.user.eq(userState.userId)
                                                               )
        )
        .map(\.items)
        .sink(
            receiveCompletion: { print($0) },
              receiveValue: { clubsJoined in
                  self.clubsJoined = clubsJoined/*.sorted {
                //guard
                let date1 = $0.publishedTime//,
                let date2 = $1.publishedTime// else {return false}
                return date1 > date2
                 }*/
            }
        )
        .store(in: &clubJoinedTokens)
    }
}

struct JoinClub: View {
    @EnvironmentObject var userState: UserState
    @State var enterJoinCode = ""
    @Binding var joinNewClub: Bool
    @Binding var showMenu: Bool
    @State var correctClubCodeEntered = false
    @State var buttonPressed = false
    @State var isLoading = false
    var body: some View {
        VStack {
            Text("Join existing club")
                .font(.custom("Roboto-Regular", size: 18))
                .padding(.top,20)
                .padding(.bottom,15)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            
                .frame(alignment: .top)
            
            VStack(spacing: 20) {
                
                Text("Enter your club code")
                    .font(.custom("Roboto-Regular", size: 16))
                    .padding(.vertical,10)
                    .foregroundColor(.gray)
                
                HStack(spacing: 0) {
                    
                    if enterJoinCode != "" {
                        Image(systemName: "at")
                            .font(.custom("Roboto-Regular", size: 12))
                    }
                    
                    TextField("@code", text: $enterJoinCode)
                        .font(.custom("Roboto-Regular", size: 16))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    //.padding(.horizontal,5)
                    
                }.padding(.horizontal,15).frame(height: 45).frame(maxWidth: .infinity, alignment: .leading).background(Color.white).background(Rectangle().stroke(Color.gray, lineWidth: 0.25))
                
                
                //TODO: Fix this issue so that this message doesnt show up before the user even enters a code
                if correctClubCodeEntered == false && buttonPressed == true{
                    VStack(spacing: 5) {
                        HStack(spacing: 3){
                            Image(systemName: "exclamationmark.circle")
                                .font(.system(size: 11))
                                .foregroundColor(.red)
                            Text("The code you entered does not exist. Try again.")
                                .font(.custom("Roboto-Regular", size: 11))
                                .foregroundColor(.red)
                        }
                    }.padding(.horizontal,35)
                }
                
            }.frame(maxHeight: .infinity, alignment: .top).padding(.top)
            
            Button {
                //buttonPressed = true
                //TODO: It wont let me join the club because it says that the code is incorrect even though its not, SOO.. find a way to do club.clubCode w/out it asking to call it in every screen
                //if enterJoinCode == Club.keys.clubCode.rawValue{
                    //**Add user to club here**
                    //Task { await joinClub() }
                    //correctClubCodeEntered = true
                    //enterJoinCode = ""
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    //    joinNewClub = false
                  //  }
                //} else {
                    // error message and stuff
                    //correctClubCodeEntered = false
                    //HapticsManager.instance.notification(type: .error)
                //}
                //showMenu = false
                Task { await checkIfJoinCodeIsCorrect() }
            } label: {
                Text("Join")
                    .font(.custom("Roboto-Medium", size: 18))
                    .foregroundColor(enterJoinCode == "" ? Color.clear : Color.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .frame(height: 60)
                    .padding(.bottom,10)
                    .background(
                        Rectangle()
                            .fill(enterJoinCode == "" ? Color.clear : Color("darkBlue"))
                    )
            }.frame(alignment: .bottom)
            
            
        }.background(Color("back")).ignoresSafeArea(.all, edges: .vertical)
        
            .overlay (
                ZStack(
                       content: {
                           
                    if isLoading{
                        Color.white
                            .ignoresSafeArea()
                        LoadingScreenForJoiningClub(isLoading: $isLoading)
                    }
                })
            )
    }
    
    /*func joinClub()async{
        let userClubId = UUID().uuidString
        do {
            //MARK: Mock user
            //TODO: Change the userAttemptsForClubOwnerCode to be the one that the user has...
            let user = User(id: userState.userId, username: userState.username, firstName: userState.firstName, lastName: userState.lastName, email: userState.email, userAttemptsForClubOwnerCode: userState.userAttemptsForClubOwnerCode, userIsAddedToGroup: userState.userIsAddedToGroup)
            //MARK: Mock club
            //TODO: Change the published time to be club.publishedTime
            let club = Club(id: Club.keys.id.rawValue, clubProfileKey: Club.keys.clubProfileKey.rawValue, clubName: Club.keys.clubName.rawValue, clubCode: Club.keys.clubCode.rawValue, publishedTime: try Temporal.DateTime(iso8601String: Club.keys.publishedTime.rawValue), createdBy: [Club.keys.createdBy.rawValue])
            // create a new userClub object to represent the many-to-many relationship
            let userClub = UserClub(id: userClubId, club: club, user: user)
            try await Amplify.DataStore.save(userClub)
            print("COMPLETE: Added user to club successfully!")
        }catch let error as DataStoreError{
            print("Failed with error: \(error)")
        }catch{
            print("Unexpected error: \(error)")
        }
    }*/
    
    //TODO: Make it where you can't join a club if you created it, it will give you an error saying, "A club with that code is already owned, try another code."
    func checkIfJoinCodeIsCorrect()async{
        let userClubId = UUID().uuidString
        let user = User(id: userState.userId, username: userState.username, firstName: userState.firstName, lastName: userState.lastName, email: userState.email, userAttemptsForClubOwnerCode: userState.userAttemptsForClubOwnerCode, userIsAddedToGroup: userState.userIsAddedToGroup)
        do{
            let queriedClubs = try await Amplify.DataStore.query(Club.self)
            for club in queriedClubs {
                let userClub = UserClub(id: userClubId, club: club, user: user)
                if enterJoinCode == club.clubCode{
                    buttonPressed = true
                    try await Amplify.DataStore.save(userClub)
                    isLoading = true
                    //Task { await joinClub() }
                    correctClubCodeEntered = true
                    enterJoinCode = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        joinNewClub = false
                    }
                } else {
                    // error message and stuff
                    correctClubCodeEntered = false
                    HapticsManager.instance.notification(type: .error)
                }
            }
            print("COMPLETE: Added user to club successfully!")
        }catch let error as DataStoreError{
            print("Failed with error: \(error)")
        } catch{
            print("Unexpected error: \(error)")
        }
    }
}

struct LoadingScreenForJoiningClub: View {
    @Binding var isLoading: Bool
    var body: some View {
            VStack(spacing: 15){
                ProgressView()
                    .tint(.blue)
                Text("Joining club...")
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.black)
            }
    }
}

struct ClubCell: View {
    @State var clubIsTapped = false
    var club: Club
    var body: some View {
        Button {
            self.clubIsTapped.toggle()
        } label: {
            HStack(spacing: 15) {
                AmplifyImage(key: club.clubProfileKey)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .background(
                        Circle()
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(club.clubName)
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                    Text("@")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.gray)
                    +
                    Text(club.clubCode)
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.gray)
                }
            }
        }.fullScreenCover(isPresented: $clubIsTapped) {
            ClubProfileScreen(clubIsTapped: $clubIsTapped, club: club)
        }
    }
}

struct JoinedClubCell: View {
    var userClub: UserClub
    @State var clubIsTapped = false
    var body: some View {
        HStack(spacing: 15) {
            AmplifyImage(key: userClub.club.clubProfileKey)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .background(
                    Circle()
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                )
            VStack(alignment: .leading, spacing: 0) {
                Text(userClub.club.clubName)
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.black)
                Text("@")
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.gray)
                +
                Text(userClub.club.clubCode)
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.gray)
            }
        }.fullScreenCover(isPresented: $clubIsTapped) {
            ClubProfileForMembers(clubIsTapped: $clubIsTapped, userClub: userClub)
        }
    }
}

struct formProgressView : View {
    
    @Binding var percent : CGFloat
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            ZStack(alignment: .trailing) {
                
                Capsule()
                    .fill(Color("back"))
                    .frame(height: 5)
                
            }
            
            Capsule()
                .fill(Color("barColor"))
                .frame(width: self.calPercent(), height: 5)
            
        }
    }
    
    func calPercent()->CGFloat{
        
        let width = UIScreen.main.bounds.width - 66
        
        return width * self.percent
    }
}

//Extending View to get screen rect...
extension View {
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
    
    //round specific corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorners(radius: radius, corners: corners))
    }
    
    // freq used text stucture
    func genericText(_ color: Color, weight: Font.Weight, size: CGFloat)-> some View {
        self.foregroundColor(color).fontWeight(weight).font(.system(size: size))
    }
}

//round specific corners...
struct RoundedCorners: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
