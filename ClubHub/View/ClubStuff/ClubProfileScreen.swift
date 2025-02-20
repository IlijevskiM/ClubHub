//
//  ClubProfileView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import AmplifyImage
import Amplify
import Combine

struct ClubProfileScreen: View {
    @State var current = "Events"
    @Namespace var animation
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userState: UserState
    @State var showMap = false
    @State var addEvent = false
    @State var showDeleteSignUp = false
    @State var confirmDeleteSignUp = false
    @State var showSubmissionPopUp = false
    @State var confirmSubmissionPopUp = false
    @State var showSignUpPopUp = false
    @State var confirmSignUp = false
    @State var showLeavePopUp = false
    @State var confirmLeave = false
    @State var inviteText = ""
    @State var expanded = false
    @State var selectedText = "Events"
    @Binding var clubIsTapped: Bool
    @State var showClubProfileSettings = false
    //MARK: AWS Data
    var club: Club
    @State var events: [Event] = []
    @State var nonSponsoredEvents: [Outside] = []
    @State var donationEvents: [Donation] = []
    @State var userClubMembers: [UserClub] = []
    @State var eventTokens: Set<AnyCancellable> = []
    @State var nonSponsoredTokens: Set<AnyCancellable> = []
    @State var donationTokens: Set<AnyCancellable> = []
    @State var memberTokens: Set<AnyCancellable> = []
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 0) {
                AmplifyImage(key: club.clubProfileKey)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 430,height: 200)
                        .blur(radius: 5)
                        //.opacity(0.75)
                        .overlay(alignment: .topTrailing) {
                            Button {
                                self.clubIsTapped.toggle()
                            } label: {
                                Image(systemName: "arrow.down")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(7)
                                    .background(Circle().fill(.black.opacity(0.5)))
                                    .padding(.horizontal,18)
                                    .padding(.top,50)
                            }
                        }
                
                VStack(spacing: 15) {
                    //top banner
                    HStack(spacing: 10) {
                        
                        AmplifyImage(key: club.clubProfileKey)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(spacing: 5) {
                                Text(club.clubName)
                                    .font(.custom("Roboto-Medium", size: 18))
                                    .foregroundColor(.black)
                                
                                //TODO: Implement verified clubs functionality
                                /*Image("verified")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)*/
                                
                                
                                Spacer()
                                
                                //TODO: Dont show the leave button on the club profile screen if the user is a leader of the club
                                Button {
                                    showLeavePopUp.toggle()
                                } label: {
                                    Text("Leave")
                                        .font(.custom("Roboto-Medium", size: 14))
                                        .foregroundColor(.white)
                                        .padding(.horizontal,15)
                                        .padding(.vertical,6)
                                        .background(Capsule().fill(Color("darkBlue")))
                                }
                                
                                NavigationLink {
                                    ClubOwnerSettingsView(club: club)
                                    /*if userState.userIsAddedToGroup == true {
                                        ClubOwnerSettingsView(club: club)
                                    } else {
                                        ClubSettingsView(club: club)
                                    }*/
                                } label: {
                                    Image("settings")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.gray)
                                        .padding(.leading,5)
                                }.navigationTitle("")
                            }
                            
                            HStack(spacing: 0) {
                                
                                //TODO: Query members profile images randomely
                                HStack(spacing: 6) {
                                    
                                    Image("p1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 22, height: 22)
                                        .background(Circle().fill(.white).frame(width:27, height:27))
                                    
                                    Image("p2")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 22, height: 22)
                                        .background(Circle().fill(.white).frame(width:27, height:27))
                                        .offset(x: -10)
                                    
                                    Image("p3")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 22, height: 22)
                                        .background(Circle().fill(.white).frame(width:27, height:27))
                                        .offset(x: -20)
                                    
                                    Image("p1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 22, height: 22)
                                        .background(Circle().fill(.white).frame(width:27, height:27))
                                        .offset(x: -30)
                                }
                                
                                //TODO: Fetch the number of members
                                Text("\(userClubMembers.count)")
                                    .font(.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(.gray)
                                    .padding(.leading, -20)
                            }
                        }
                    }.padding(.horizontal,10)
                    
                    VStack(spacing: 0) {
                        Divider()
                        HStack(spacing: 8) {
                            clubProfileTabBar(current: $current, title: "Events", animation: animation)
                            clubProfileTabBar(current: $current, title: "Non-Sponsored", animation: animation)
                            clubProfileTabBar(current: $current, title: "Donations", animation: animation)
                            clubProfileTabBar(current: $current, title: "Members", animation: animation)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.padding(.vertical,10).background(.white).padding(.top,-80)
                Divider()
                if current == "Events" {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 8){
                            if events.isEmpty {
                                Text("No events yet")
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.top,20)
                            } else {
                                ForEach(events) { event in
                                    ExampleEvent(showSignUpPopUp: $showSignUpPopUp, showDeleteSignUp: $showDeleteSignUp, confirmDeleteSignUp: $confirmDeleteSignUp, confirmSignUp: $confirmSignUp, event: event)
                                }
                            }
                        }.padding(.top,8).padding(.horizontal,10).padding(.bottom,65)
                    }.onAppear {
                        observeEvents()
                    }
                } else  if current == "Non-Sponsored"{
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            if nonSponsoredEvents.isEmpty{
                                Text("No outside hours opportunities yet")
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.top,20)
                            }else{
                                ForEach(nonSponsoredEvents) { nonsponsored in
                                    NonSponsoredEvent(showSignUpPopUp: $showSignUpPopUp, showDeleteSignUp: $showDeleteSignUp, confirmDeleteSignUp: $confirmDeleteSignUp, confirmSignUp: $confirmSignUp, outside: nonsponsored)
                                }
                            }
                        }.padding(.top,8).padding(.horizontal,10).padding(.bottom,65)
                    }.onAppear {
                        observeNonSponsored()
                    }
                } else if current == "Donations" {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            if donationEvents.isEmpty {
                                Text("No donation opportunities yet")
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.top,20)
                            } else{
                                ForEach(donationEvents) { donation in
                                    ExampleDonationEvent(showSignUpPopUp: $showSignUpPopUp, showDeleteSignUp: $showDeleteSignUp, confirmDeleteSignUp: $confirmDeleteSignUp, confirmSignUp: $confirmSignUp, donation: donation)
                                }
                            }
                        }.padding(.top,8).padding(.horizontal,10).padding(.bottom,65)
                    }.onAppear{
                        observeDonations()
                    }
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        //TODO: Just input the user data in the clubMembers and get the ones who joined the clubs
                        LazyVStack(spacing: 8) {
                            if userClubMembers.isEmpty{
                                Text("No members yet")
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.top,20)
                            }else{
                                ForEach(userClubMembers) { member in
                                    ClubMembers(userClub: member)
                                }
                            }
                        }.padding(.top,8).padding(.horizontal,10).padding(.bottom,65)
                    }.onAppear {
                        observeClubMembers()
                    }
                }
            }.background(Color("back")).edgesIgnoringSafeArea(.top)
        }
        .overlay (
            ZStack(alignment: .top, content: {
                
                if showSignUpPopUp{
                    Color.black.opacity(0.1)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showSignUpPopUp.toggle()
                            }
                        }
                        .ignoresSafeArea()
                    SignUpForEvent(showSignUpPopUp: $showSignUpPopUp, confirmSignUp: $confirmSignUp)
                } else if showDeleteSignUp{
                    Color.black.opacity(0.1)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showDeleteSignUp.toggle()
                            }
                        }
                        .ignoresSafeArea()
                    RemoveSignUpPopUp(showDeleteSignUp: $showDeleteSignUp, confirmDeleteSignUp: $confirmDeleteSignUp)
                    
                } else if showLeavePopUp{
                    Color.black.opacity(0.1)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showLeavePopUp.toggle()
                            }
                        }
                        .ignoresSafeArea()
                    Leaveclub(showLeavePopUp: $showLeavePopUp, confirmLeave: $confirmLeave)
                } else if showSubmissionPopUp{
                    Color.black.opacity(0.1)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showLeavePopUp.toggle()
                            }
                        }
                        .ignoresSafeArea()
                    //TODO: Maybe add a delete submission functionality?
                    SubmissionPopUp(showSubmissionPopUp: $showSubmissionPopUp, confirmSubmission: $confirmSubmissionPopUp)
                }
            })
        )
    }
    
    func observeEvents(){
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: Event.self)
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
              receiveValue: { meeting in
            self.events = meeting.sorted {
                //guard
                let date1 = $0.publishedTime//,
                let date2 = $1.publishedTime
                //else {return false}
                return date1 > date2
                 }
            }
        )
        .store(in: &eventTokens)
    }
    
    func observeNonSponsored(){
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: Outside.self)
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
              receiveValue: { nonSponsoredEvents in
            self.nonSponsoredEvents = nonSponsoredEvents.sorted {
                let date1 = $0.publishedTime
                let date2 = $1.publishedTime
                return date1 > date2
                }
            }
        )
        .store(in: &nonSponsoredTokens)
    }
    
    func observeDonations(){
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: Donation.self)
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
              receiveValue: { donation in
            self.donationEvents = donation.sorted {
                let date1 = $0.publishedTime
                let date2 = $1.publishedTime
                return date1 > date2
                }
            }
        )
        .store(in: &donationTokens)
    }
    
    func observeClubMembers(){
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: UserClub.self)
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { print($0) },
              //TODO: Sort by if they have a crown (those peeps will go to the top, but for now leave it)
              receiveValue: { member in
            self.userClubMembers = member
            }
        )
        .store(in: &memberTokens)
    }
}

struct ClubMembers: View {
    //TODO: Implement this later
    var userClub: UserClub
    var memberProfileKey: String {
        userClub.user.id + ".jpg"
    }
    var body: some View {
        
        VStack(spacing: 5) {
            
            HStack(spacing: 15) {
                AmplifyImage(key: memberProfileKey)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 35, height: 35)
                
                Group {
                    Text(userClub.user.firstName ?? "")
                    //Text(userClub.user.firstName ?? "")
                    +
                    Text(" \(userClub.user.lastName ?? "")")
                    //Text(" \(userClub.user.lastName ?? "")")
                        
                }.font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.black)
                
                Spacer()
                
                //TODO: Only show if the user is the club leader/board member
                /*Image("crown")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("yellow."))*/
                
            }.padding(.horizontal,15).padding(.vertical,10).background(RoundedRectangle(cornerRadius: 10).fill(.white)).padding(.horizontal,10)
            
        }.padding(.top,8)
    }
}

struct ExampleEvent: View {
    @EnvironmentObject var userState: UserState
    @Binding var showSignUpPopUp: Bool
    @Binding var showDeleteSignUp: Bool
    @Binding var confirmDeleteSignUp: Bool
    @Binding var confirmSignUp: Bool
    @State var bookmarkPressed = false
    @State var showUserList = false
    @State var showCreateEventTab = false
    @State var showEventInfo = false
    @State var expandedDescription = false
    //@Binding var showPositionPickSignUp: Bool
    //@Binding var confirmPositionSignUp: Bool
    @State var signedUp = false
    //TODO: Put actual data for this...
    @State var positionsFilled = 10
    //MARK: AWS Data
    var event: Event
    var firstMember: String{
        (event.signees?[0].id ?? "") + ".jpg"
    }
    var secondMember: String{
        (event.signees?[1].id ?? "") + ".jpg"
    }
    var thirdMember: String{
        (event.signees?[2].id ?? "") + ".jpg"
    }
    //TODO: do correct calacultation for percent
    @State var percent: CGFloat = 0.75 //CGFloat(event.signees?.count ?? 0/event.capacity)
    @State var eventAttendees: [EventUser] = []
    var publishedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(for: event.date.foundationDate) ?? ""
    }
    var publishedStartTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(for: event.start.foundationDate) ?? ""
    }
    var publishedEndTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(for: event.end.foundationDate) ?? ""
    }
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            HStack {
                
                Text(event.title)
                    .font(Font.custom("Roboto-Medium", size: 18))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Spacer()
                
                if event.type == "Meeting" {
                    Text(event.type)
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(Color("purple."))
                        .padding(.horizontal,10)
                        .padding(.vertical,3)
                        .background(Capsule().fill(Color("purple.").opacity(0.1)))
                }else if event.type == "Sponsored"{
                    Text(event.type)
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(Color("blue."))
                        .padding(.horizontal,10)
                        .padding(.vertical,3)
                        .background(Capsule().fill(Color("purple.").opacity(0.1)))
                }else if event.type == "Other"{
                    Text(event.type)
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(Color("yellow."))
                        .padding(.horizontal,10)
                        .padding(.vertical,3)
                        .background(Capsule().fill(Color("purple.").opacity(0.1)))
                }
                
                //MARK: Insert when event is completed
                /*Text("COMPLETED")
                 .font(Font.custom("Roboto-Medium", size: 14))
                 .foregroundColor(.gray)*/
                
                /*Button {
                 self.bookmarkPressed.toggle()
                 } label: {
                 Image(bookmarkPressed ? "bookmarkFill" : "bookmark")
                 .resizable()
                 .renderingMode(.template)
                 .frame(width: 15, height: 15)
                 .foregroundColor(bookmarkPressed ? .black : .gray)
                 }*/
                
            }
            
            Text(event.location)
                .font(.custom("Roboto-Medium", size: 14))
                .foregroundColor(.gray)
                .padding(.top,-10)
            
            //VStack(alignment: .leading, spacing: 5) {
            //Group {
            VStack(alignment: .leading, spacing: 0) {
                Text(event.description)
                    .font(Font.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(3)
                    .lineLimit(expandedDescription ? nil : 2)
                //+
                Button {
                    withAnimation(.easeInOut) {
                        expandedDescription.toggle()
                    }
                } label: {
                    Text(expandedDescription ?  "read less" : "read more")
                        .font(Font.custom("Roboto-Regular", size: 12))
                        .foregroundColor(.black)
                }
            }
            //}
            
            //}
            
            /*HStack(spacing: 10) {
             
             Button {
             
             } label: {
             //HStack(spacing: 5) {
             /*Image("link")
              .resizable()
              .renderingMode(.template)
              .frame(width: 12, height: 12)
              .foregroundColor(.blue)*/
             Text("www.myGuys.com")
             //.lineLimit(1)
             .font(.custom("Roboto-Regular", size: 14))
             .accentColor(.blue)
             .lineLimit(2)
             //}.padding(5).padding(.horizontal,5).background(Capsule().fill(.blue.opacity(0.05)))
             //MARK: Link text
             /*Link("SignUpGenius.cherrycreekfund", destination: URL(string: "nike.com")!)
              .font(Font.custom("Roboto-Medium", size: 12))
              .foregroundColor(.blue)*/
             }
             
             Button {
             
             } label: {
             //HStack(spacing: 5) {
             /*Image("folder")
              .resizable()
              .renderingMode(.template)
              .frame(width: 12, height: 12)
              .foregroundColor(.blue)*/
             Text("team_destinations.word")
             .font(.custom("Roboto-Regular", size: 14))
             .accentColor(.blue)
             .lineLimit(2)
             //}.padding(5).padding(.horizontal,5).background(Capsule().fill(.blue.opacity(0.05)))
             //MARK: Link text
             /*Link("SignUpGenius.cherrycreekfund", destination: URL(string: "nike.com")!)
              .font(Font.custom("Roboto-Medium", size: 12))
              .foregroundColor(.blue)*/
             }
             
             }.padding(.vertical,5)*/
            
            // middle row info
            //TODO: Fix this
            HStack(spacing: 25) {
                // team members info
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("Team Members")
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.gray)
                    
                    
                    Button {
                        self.showUserList.toggle()
                    } label: {
                        HStack(spacing: 6) {
                            
                            //Image("p1")
                            AmplifyImage(key: firstMember)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 25, height: 25)
                                .background(Circle().fill(.white).frame(width:32, height:32))
                            
                            AmplifyImage(key: secondMember)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 25, height: 25)
                                .background(Circle().fill(.white).frame(width:32, height:32))
                                .offset(x: -10)
                            
                            AmplifyImage(key: thirdMember)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 25, height: 25)
                                .background(Circle().fill(.white).frame(width:32, height:32))
                                .offset(x: -20)
                            
                            //MARK: This might not work
                            Text("+\((event.signees?.count ?? 0) - 3)")
                                .foregroundColor(.gray)
                                .font(.system(size: 9))
                                .fontWeight(.semibold)
                                .padding(9)
                                .background(
                                    Circle()
                                        .fill(.gray.opacity(0.1))
                                )
                                .offset(x: -25)
                        }
                    }.sheet(isPresented: $showUserList) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Event Attendees")
                                .font(.custom("Roboto-Medium", size: 20))
                                .foregroundColor(.black)
                                .padding(.horizontal,15)
                            
                            Divider()
                            
                            LazyVStack(alignment: .leading, spacing: 30) {
                                ForEach(eventAttendees) { attendee in
                                    EventAttendees(attendee: attendee)
                                }
                            }.padding(.horizontal,15)
                            
                        }.padding(.vertical,25)
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(publishedDate)
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.gray)
                    Text(publishedStartTime)
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                    +
                    Text(" - ")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                    +
                    Text(publishedEndTime)
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                }.padding(.top,-10)
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    CustomProgressView(percent: self.$percent)
                    Spacer()
                }
                
                Group {
                    //TODO: Use from database
                    Text("\(event.signees?.count ?? 0)")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.gray)
                    +
                    Text("/\(event.capacity)")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.gray)
                    +
                    Text(" positions filled")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical,5)
            /*.onAppear {
                
                withAnimation(.spring()) {
                    //TODO: Fix this based on actual ratio/percentage
                    self.percent = CGFloat(positionsFilled/(meetingEvent.capacity))
                }
            }*/
            //TODO: Fix the entire sign up configuration
            
            // MARK: Signing up will require a digital signature
            if confirmSignUp == true && confirmDeleteSignUp == false {
                Button {
                    Task { await signUpForEvent() }
                    withAnimation(.easeInOut(duration: 0.1)){
                        //TODO: Fix this so you can remove your sign up
                        showDeleteSignUp.toggle()
                    }
                } label: {
                    HStack(spacing: 5) {
                        //MARK: Make it "Signed Up" instead of "Pending" when club leader admits you
                        Image(systemName: "checkmark")
                         .font(.system(size: 10))
                         .foregroundColor(Color("darkBlue"))
                         .fontWeight(.semibold)
                        Text("Signed Up")
                            .font(Font.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                    }.padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
                        RoundedRectangle(cornerRadius: 10).fill(Color("darkBlue").opacity(0.1))
                    )
                }
            } else if confirmSignUp == false && confirmDeleteSignUp == true{
                Button {
                    withAnimation(.easeInOut(duration: 0.1)){
                        showSignUpPopUp.toggle()
                    }
                } label: {
                    Text("Sign Up")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
                            RoundedRectangle(cornerRadius: 10).fill(Color("back"))
                        )
                }
                
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.1)){
                        showSignUpPopUp.toggle()
                    }
                } label: {
                    Text("Sign Up")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
                            RoundedRectangle(cornerRadius: 10).fill(Color("back"))
                        )
                }
            } /*else if confirmSignUp == false && percent == 1{
               Button {
               } label: {
               Text("Sign Up")
               .font(Font.custom("Roboto-Regular", size: 14))
               .foregroundColor(.white)
               .padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
               RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.5))
               )
               }
               }*/
            
        }.padding(20).background(RoundedRectangle(cornerRadius: 10).fill(.white))
        
    }
    
    func signUpForEvent()async{
        let eventUserId = UUID().uuidString
        let user = User(id: userState.userId, username: userState.username, firstName: userState.firstName, lastName: userState.lastName, email: userState.email, userAttemptsForClubOwnerCode: userState.userAttemptsForClubOwnerCode, userIsAddedToGroup: userState.userIsAddedToGroup)
        do{
            let eventUser = EventUser(id: eventUserId, event: event, user: user)
            try await Amplify.DataStore.save(eventUser)
            print("Successfully added user to event: \(eventUser)")
        }catch{
            print("Error signing up user for event")
        }
    }
    //TODO: Figure out how to remove a persons sign up
    /*func removeSignUp()async{
        do{
            try await Amplify.DataStore.delete()
        }catch{
            print("Error removing user from event - \(error)")
        }
    }*/
}

struct NonSponsoredEvent: View {
    @EnvironmentObject var userState: UserState
    @Binding var showSignUpPopUp: Bool
    @Binding var showDeleteSignUp: Bool
    @Binding var confirmDeleteSignUp: Bool
    //TODO: Change 'confirmSignUp' to 'confirmSubmission' & create a new popup only meant for submissions
    @Binding var confirmSignUp: Bool
    @State var bookmarkPressed = false
    @State var showUserList = false
    @State var showCreateEventTab = false
    @State var showEventInfo = false
    @State var expandedDescription = false
    //@Binding var showPositionPickSignUp: Bool
    //@Binding var confirmPositionSignUp: Bool
    @State var percent: CGFloat = 0
    @State var signedUp = false
    @State var positionsFilled = 10
    //MARK: AWS Data
    var outside: Outside
    var dueDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(for: outside.due.foundationDate) ?? ""
    }
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            HStack {
                
                Text(outside.title)
                    .font(Font.custom("Roboto-Medium", size: 18))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Spacer()
                /*
                 purple. = meeting
                 red. = donation
                 blue. = sponsored
                 green. = outside
                 yellow. = other
                 
                 outside: post is unique
                 */
                Text("Outside")
                    .font(Font.custom("Roboto-Medium", size: 14))
                    .foregroundColor(Color("green."))
                    .padding(.horizontal,10)
                    .padding(.vertical,3)
                    .background(Capsule().fill(Color("green.").opacity(0.1)))
                
                //MARK: Insert when event is completed
                /*Text("COMPLETED")
                 .font(Font.custom("Roboto-Medium", size: 14))
                 .foregroundColor(.gray)*/
                
                /*Button {
                 self.bookmarkPressed.toggle()
                 } label: {
                 Image(bookmarkPressed ? "bookmarkFill" : "bookmark")
                 .resizable()
                 .renderingMode(.template)
                 .frame(width: 15, height: 15)
                 .foregroundColor(bookmarkPressed ? .black : .gray)
                 }*/
                
            }
            
            // middle row info
            HStack(spacing: 25) {
                // team members info
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("Due")
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.gray)
                    
                    //HStack(spacing: 6) {
                    
                    Text("Wednesday, 13 May at 11:59PM")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                    //}
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Limit")
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.gray)
                    Text("\(outside.hourLimit) hrs")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                }
            }
            
            // MARK: Signing up will require a digital signature
            if confirmSignUp == true && confirmDeleteSignUp == false {
                Button {
                    Task { await signUpForOutsideEvent() }
                    withAnimation(.easeInOut(duration: 0.1)){
                        // Change this so you can remove your sign up
                        showDeleteSignUp.toggle()
                    }
                } label: {
                    HStack(spacing: 5) {
                        //MARK: Make it "Signed Up" instead of "Pending" when club leader admits you
                        /*Image(systemName: "checkmark")
                         .font(.system(size: 10))
                         .foregroundColor(Color("darkBlue"))
                         .fontWeight(.semibold)*/
                        Text("Submitted")
                            .font(Font.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                    }.padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
                        RoundedRectangle(cornerRadius: 10).fill(Color("darkBlue").opacity(0.1))
                    )
                }
            } else if confirmSignUp == false && confirmDeleteSignUp == true{
                Button {
                    withAnimation(.easeInOut(duration: 0.1)){
                        showSignUpPopUp.toggle()
                    }
                } label: {
                    Text("Submit")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
                            RoundedRectangle(cornerRadius: 10).fill(Color("back"))
                        )
                }
                
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.1)){
                        showSignUpPopUp.toggle()
                    }
                } label: {
                    Text("Submit")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
                            RoundedRectangle(cornerRadius: 10).fill(Color("back"))
                        )
                }
            } /*else if confirmSignUp == false && percent == 1{
               Button {
               } label: {
               Text("Sign Up")
               .font(Font.custom("Roboto-Regular", size: 14))
               .foregroundColor(.white)
               .padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
               RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.5))
               )
               }
               }*/
            
        }.padding(20).background(RoundedRectangle(cornerRadius: 10).fill(.white))
    }
    
    func signUpForOutsideEvent()async{
        let outsideUserId = UUID().uuidString
        let user = User(id: userState.userId, username: userState.username, firstName: userState.firstName, lastName: userState.lastName, email: userState.email, userAttemptsForClubOwnerCode: userState.userAttemptsForClubOwnerCode, userIsAddedToGroup: userState.userIsAddedToGroup)
        do{
            let outsideUser = OutsideUser(id: outsideUserId, outside: outside, user: user)
            try await Amplify.DataStore.save(outsideUser)
            print("Successfully added user to outside event: \(outsideUser)")
        }catch{
            print("Error signing up user for event")
        }
    }
}

struct ExampleDonationEvent: View {
    @EnvironmentObject var userState: UserState
    @Binding var showSignUpPopUp: Bool
    @Binding var showDeleteSignUp: Bool
    @Binding var confirmDeleteSignUp: Bool
    //TODO: Change to 'confirmSubmission'
    @Binding var confirmSignUp: Bool
    @State var bookmarkPressed = false
    @State var showUserList = false
    @State var showCreateEventTab = false
    @State var showEventInfo = false
    @State var expandedDescription = false
    //@Binding var showPositionPickSignUp: Bool
    //@Binding var confirmPositionSignUp: Bool
    @State var percent: CGFloat = 0
    @State var signedUp = false
    @State var positionsFilled = 10
    //MARK: AWS Data
    var donation: Donation
    var dueDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(for: donation.due.foundationDate) ?? ""
    }
    var body: some View {
        //MARK: Donation example
        VStack(alignment: .leading, spacing: 15) {
            
            HStack {
                
                Text(donation.title)
                    .font(Font.custom("Roboto-Medium", size: 18))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Spacer()
                /*
                 purple. = meeting
                 red. = donation
                 blue. = sponsored
                 green. = outside
                 yellow. = other
                 
                 outside: post is unique
                 */
                Text("Donation")
                    .font(Font.custom("Roboto-Medium", size: 14))
                    .foregroundColor(Color("red."))
                    .padding(.horizontal,10)
                    .padding(.vertical,3)
                    .background(Capsule().fill(Color("red.").opacity(0.1)))
                
                //MARK: Insert when event is completed
                /*Text("COMPLETED")
                 .font(Font.custom("Roboto-Medium", size: 14))
                 .foregroundColor(.gray)*/
                
                /*Button {
                 self.bookmarkPressed.toggle()
                 } label: {
                 Image(bookmarkPressed ? "bookmarkFill" : "bookmark")
                 .resizable()
                 .renderingMode(.template)
                 .frame(width: 15, height: 15)
                 .foregroundColor(bookmarkPressed ? .black : .gray)
                 }*/
                
            }
            
            Text(donation.location)
                .font(.custom("Roboto-Medium", size: 14))
                .foregroundColor(.gray)
                .padding(.top,-8)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(donation.description)
                    .font(Font.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(3)
                    .lineLimit(expandedDescription ? nil : 2)
                
                Button {
                    withAnimation(.easeInOut) {
                        expandedDescription.toggle()
                    }
                } label: {
                    Text("read more")
                        .font(Font.custom("Roboto-Regular", size: 12))
                        .foregroundColor(.black)
                }
                
            }
            
            /*HStack(spacing: 10) {
             
             Button {
             
             } label: {
             //HStack(spacing: 5) {
             /*Image("link")
              .resizable()
              .renderingMode(.template)
              .frame(width: 12, height: 12)
              .foregroundColor(.blue)*/
             Text("www.myGuys.com")
             //.lineLimit(1)
             .font(.custom("Roboto-Regular", size: 14))
             .accentColor(.blue)
             .lineLimit(2)
             //}.padding(5).padding(.horizontal,5).background(Capsule().fill(.blue.opacity(0.05)))
             //MARK: Link text
             /*Link("SignUpGenius.cherrycreekfund", destination: URL(string: "nike.com")!)
              .font(Font.custom("Roboto-Medium", size: 12))
              .foregroundColor(.blue)*/
             }
             
             Button {
             
             } label: {
             //HStack(spacing: 5) {
             /*Image("folder")
              .resizable()
              .renderingMode(.template)
              .frame(width: 12, height: 12)
              .foregroundColor(.blue)*/
             Text("team_destinations.word")
             .font(.custom("Roboto-Regular", size: 14))
             .accentColor(.blue)
             .lineLimit(2)
             //}.padding(5).padding(.horizontal,5).background(Capsule().fill(.blue.opacity(0.05)))
             //MARK: Link text
             /*Link("SignUpGenius.cherrycreekfund", destination: URL(string: "nike.com")!)
              .font(Font.custom("Roboto-Medium", size: 12))
              .foregroundColor(.blue)*/
             }
             
             }.padding(.vertical,5)*/
            
            // middle row info
            HStack {
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Due")
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.gray)
                    Text(dueDate)
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                    Spacer()
                }.padding(.top,-10)
            }
            
            // MARK: Signing up will require a digital signature
            if confirmSignUp == true && confirmDeleteSignUp == false {
                Button {
                    Task { await signUpForDonationEvent() }
                    withAnimation(.easeInOut(duration: 0.1)){
                        // Change this so you can remove your sign up
                        showDeleteSignUp.toggle()
                    }
                } label: {
                    HStack(spacing: 5) {
                        //MARK: Make it "Signed Up" instead of "Pending" when club leader admits you
                        /*Image(systemName: "checkmark")
                         .font(.system(size: 10))
                         .foregroundColor(Color("darkBlue"))
                         .fontWeight(.semibold)*/
                        Text("Submitted")
                            .font(Font.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                    }.padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
                        RoundedRectangle(cornerRadius: 10).fill(Color("darkBlue").opacity(0.1))
                    )
                }
            } else if confirmSignUp == false && confirmDeleteSignUp == true{
                Button {
                    withAnimation(.easeInOut(duration: 0.1)){
                        showSignUpPopUp.toggle()
                    }
                } label: {
                    Text("Submit")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
                            RoundedRectangle(cornerRadius: 10).fill(Color("back"))
                        )
                }
                
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.1)){
                        showSignUpPopUp.toggle()
                    }
                } label: {
                    Text("Submit")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
                            RoundedRectangle(cornerRadius: 10).fill(Color("back"))
                        )
                }
            } /*else if confirmSignUp == false && percent == 1{
               Button {
               } label: {
               Text("Sign Up")
               .font(Font.custom("Roboto-Regular", size: 14))
               .foregroundColor(.white)
               .padding(.vertical,10).frame(maxWidth: .infinity, alignment: .center).background(
               RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.5))
               )
               }
               }*/
            
        }.padding(20).background(RoundedRectangle(cornerRadius: 10).fill(.white))
    }
    
    func signUpForDonationEvent()async{
        let donationUserId = UUID().uuidString
        let user = User(id: userState.userId, username: userState.username, firstName: userState.firstName, lastName: userState.lastName, email: userState.email, userAttemptsForClubOwnerCode: userState.userAttemptsForClubOwnerCode, userIsAddedToGroup: userState.userIsAddedToGroup)
        do{
            let donationUser = DonationUser(id: donationUserId, donation: donation, user: user)
            try await Amplify.DataStore.save(donationUser)
            print("Successfully added user to event: \(donationUser)")
        }catch{
            print("Error signing up user for event")
        }
    }
}

struct clubProfileTabBar: View {
    @Binding var current : String
    var title : String
    var animation : Namespace.ID
    
    var body: some View {
        
        //HStack {
        
        Button(action: {
            withAnimation{current = title}
            current = title
        }) {
            
            //HStack(spacing: 20) {
            
            VStack(spacing: 10) {
                
                // matched geometry effect slide animation
                
                if current == title {
                    Capsule()
                        .fill(.blue)
                        .frame(width: 75, height: 2.5)
                        //.frame(width: title == "Events" ? 42 : 59, height: 2.5)
                        .matchedGeometryEffect(id: "Tab", in: animation)
                    
                } else {
                    Capsule()
                        .fill(.clear)
                        .frame(width: 75, height: 2.5)
                        //.frame(width: title == "Events" ? 42 : 59, height: 2.5)
                }
                
                Text(title)
                    .font(Font.custom("Roboto-Medium", size: 14))
                    .foregroundColor(current == title ? .black : Color.gray)
                    .padding(.horizontal)
            }
            //}
        }
        
        //}
    }
}

struct EventAttendees: View {
    var attendee: EventUser
    var attendeeProfileKey: String {
        attendee.user.id + ".jpg"
    }
    var body: some View {
        
        HStack(spacing: 15) {
            AmplifyImage(key: attendeeProfileKey)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 35, height: 35)
            
            Text("\(attendee.user.firstName ?? "") \(attendee.user.lastName ?? "")")
                .font(.custom("Roboto-Regular", size: 14))
                .foregroundColor(.black)
            
            Spacer()
        }
    }
}
    
struct CustomProgressView : View {
    
    @Binding var percent : CGFloat
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            ZStack(alignment: .trailing) {
                Capsule()
                    .fill(Color("back"))
                    .frame(height: 5)
                    //.frame(width: 200, height: 5)
                
                
            }
            
            Capsule()
                .fill(Color("darkBlue"))
                .frame(width: self.calPercent(), height: 5)
            
        }
    }
    
    func calPercent()->CGFloat{
        
        let width = UIScreen.main.bounds.width - 66
        
        return width * self.percent
    }
}

struct AnimatedBar: View {
    
    @Binding var current : String
    var title : String
    var animation : Namespace.ID
    
    var body: some View {
        
        HStack {
            
            Button(action: {
                withAnimation{current = title}
            }) {
                
                HStack {
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.clear)
                            .frame(width: 100, height: 30)

                        // matched geometry effect slide animation
                        
                        if current == title {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .frame(width: 100, height: 30)
                                .matchedGeometryEffect(id: "Tab", in: animation)
                            
                        }
                        
                        Text(title)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            //.fontWeight(current == title ? .semibold : .regular)
                            //.foregroundColor(current == title ? Color.white : Color.gray)
                            .padding(.horizontal)
                        
                    }
                }.padding(10).padding(.horizontal,10).background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color("back"))
                    
                    )
            }
            
        }
    }
}

/*struct Files: View {
    var body: some View {
        VStack(spacing: 5) {
            NavigationLink {
                 ExampleFile()
            } label: {
                HStack(spacing: 15) {
                    Image("tf")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 35, height: 35)
                    
                    Text("Transportation Form")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }.padding(15).background(RoundedRectangle(cornerRadius: 10).fill(.white)).padding(.horizontal,10)//.padding(.vertical,3)
            }.navigationBarTitle("")
            
            NavigationLink {
                ExampleCollection()
            } label: {
                //collection
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("COLLECTION")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.gray)
                            Text("Rules")
                                .font(.custom("Roboto-Medium", size: 14))
                                .foregroundColor(.black)
                    }
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }.padding(15).background(RoundedRectangle(cornerRadius: 10).fill(.white)).padding(.horizontal,10)
            // TODO: change this title to whatever the collection is called
            }.navigationBarTitle("")
        }
        
    }
}*/

/*struct ExampleFile: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Transportation Form")
                        .font(.custom("Roboto-Bold", size: 20))
                        .foregroundColor(.black)
                    Text("2023")
                        .font(.custom("Roboto-Medium", size: 18))
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("Open File")
                    .font(.custom("Roboto-Medium", size: 16))
                    .foregroundColor(Color("darkBlue"))
            }
            
            Image("tf")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350, height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }.padding(.horizontal,10)
    }
}*/

/*struct ExampleCollection: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack(spacing: 10) {
                    Image("exrule")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                    Text("Chemistry Lab")
                        .font(.custom("Roboto-Medium", size: 18))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }.padding(.horizontal,10)
                Divider()
                
                HStack(spacing: 10) {
                    Image("exrule")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                    Text("Dynamic Planet")
                        .font(.custom("Roboto-Medium", size: 18))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }.padding(.horizontal,10)
                Divider()
                
                HStack(spacing: 10) {
                    Image("exrule")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                    Text("Astronomy")
                        .font(.custom("Roboto-Medium", size: 18))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }.padding(.horizontal,10)
                Divider()
                
                Spacer()
            }.padding(.top,5)
        }
    }
}*/
