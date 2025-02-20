//
//  ClubProfileForMembers.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 8/17/23.
//

import SwiftUI
import AmplifyImage
import Amplify
import Combine

struct ClubProfileForMembers: View {
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
    //var userClub: UserClub
    var userClub: UserClub
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
                AmplifyImage(key: userClub.club.clubProfileKey)
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
                        
                        AmplifyImage(key: userClub.club.clubProfileKey)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(spacing: 5) {
                                Text(userClub.club.clubName)
                                    .font(.custom("Roboto-Medium", size: 18))
                                    .foregroundColor(.black)
                                
                                //TODO: Implement verified clubs functionality
                                Image("verified")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)
                                
                                
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
                                    /*if userState.userIsAddedToGroup == true {
                                        ClubOwnerSettingsView(club: club)
                                    } else {
                                        ClubSettingsView(club: club)
                                    }*/
                                    //ClubSettingsView(userClub: userClub)
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
                        }
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
                        }
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
                        }
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
