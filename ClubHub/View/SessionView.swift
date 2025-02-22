//
//  SessionView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify
import Combine

struct SessionView: View {
    
    @StateObject var userState: UserState = .init()
    @State var isSignedIn: Bool = false
    @State var tokens: Set<AnyCancellable> = []
    var body: some View {
        StartingView()
            .environmentObject(userState)
            .onAppear{
                Task { await getCurrentSession() }
                observeSession()
                //Task { await checkIfUserIsInGroup() }
            }
    }
    
    @ViewBuilder
    func StartingView() -> some View {
        if isSignedIn {
            MainView()
        } else {
            Login()
        }
    }
    
    func getCurrentSession()async{
        do{
            let session = try await Amplify.Auth.fetchAuthSession()
            DispatchQueue.main.async {
                self.isSignedIn = session.isSignedIn
            }
            guard session.isSignedIn else {return}
            
            
            let authUser = try await Amplify.Auth.getCurrentUser()
            let attributes = try await Amplify.Auth.fetchUserAttributes()
            let email = attributes.first(where: { $0.key == AuthUserAttributeKey.email })?.value
            let firstName = attributes.first(where: { $0.key == AuthUserAttributeKey.givenName })?.value
            let lastName = attributes.first(where: { $0.key == AuthUserAttributeKey.familyName })?.value
            //let userIsAddedToGroup = User.keys.userIsAddedToGroup.rawValue
            self.userState.userId = authUser.userId
            self.userState.username = authUser.username
            self.userState.email = email ?? ""
            self.userState.firstName = firstName ?? ""
            self.userState.lastName = lastName ?? ""
            //TODO: Xcode keeps returning this value as nil and it is always false even if the user is added to the group
            //self.userState.userIsAddedToGroup = Bool(userIsAddedToGroup) ?? false
    
            
            let user = try await Amplify.DataStore.query(User.self, byId: authUser.userId)
            
            if let existingUser = user {
                print("Existing user: \(existingUser)")
            }else{
                let newUser = User(id: authUser.userId, username: authUser.username, firstName: firstName, lastName: lastName, email: email, userAttemptsForClubOwnerCode: 0, groups: [], userIsAddedToGroup: false)
                let savedUser = try await Amplify.DataStore.save(newUser)
                print("Created user: \(savedUser)")
            }
        }catch{
            print(error)
        }
    }
    
    func observeSession(){
        Amplify.Hub.publisher(for: .auth)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { payload in
                switch payload.eventName{
                case HubPayload.EventName.Auth.signedIn:
                    self.isSignedIn = true
                    Task{ await getCurrentSession() }
                case HubPayload.EventName.Auth.signedOut, HubPayload.EventName.Auth.sessionExpired:
                    self.isSignedIn = false
                default:
                    break
                }
            }
        )
            .store(in: &tokens)
    }
    
    func checkIfUserIsInGroup()async{
        do {
            let queriedUsers = try await Amplify.DataStore.query(User.self)
            for queriedUser in queriedUsers {
                if queriedUser.userIsAddedToGroup == true {
                    userState.userIsAddedToGroup = true
                    print("User is in group")
                } else {
                    userState.userIsAddedToGroup = false
                    print("User is NOT in group")
                }
            }
        }catch let error as DataStoreError{
            print("Failed to check if user is in group: \(error)")
        }catch{
            print("Unexpected error occured: \(error)")
        }
    }
}
