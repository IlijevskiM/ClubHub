//
//  EventConfirmation.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify

struct SignUpForEvent: View {
    @EnvironmentObject var userState: UserState
    @Binding var showSignUpPopUp: Bool
    @Binding var confirmSignUp: Bool
    @State var successfullySignedUp: Bool = false
    var body: some View {
        
    VStack(alignment: .leading) {
        VStack(alignment: .leading, spacing: 15) {
            
            Text("Sign Up")
                .font(.custom("Roboto-Bold", size: 20))
                .foregroundColor(.black)
            
            Text("Are you sure you want to sign up for \nthis event?")
                .font(Font.custom("Roboto-Regular", size: 14))
                .foregroundColor(.gray)
                .lineSpacing(5)
                .multilineTextAlignment(.leading)
        }
            
            HStack(spacing: 10) {
                Button {
                    showSignUpPopUp.toggle()
                } label: {
                    Text("Cancel")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.gray)
                        .padding(.vertical,8)
                        .padding(.horizontal,35)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(Color("back"))
                        )
                }
                Button {
                    Task { await signUpForEvent() }
                    //successfullySignedUp.toggle()
                    showSignUpPopUp.toggle()
                    confirmSignUp.toggle()
                } label: {
                    Text("Confirm")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.white)
                        .padding(.vertical,8)
                        .padding(.horizontal,35)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(Color("darkBlue"))
                        )
                }
            }.padding(.top,10)
        }.padding(.horizontal,20).padding(.vertical,20).background(RoundedRectangle(cornerRadius: 12).fill(.white))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .transition(.move(edge: .bottom))
            .animation(.spring())
        
            /*.overlay (
                ZStack(alignment: .top, content: {
                    
                    if successfullySignedUp{
                        Color.black.opacity(0.1)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    successfullySignedUp.toggle()
                                }
                            }
                            .ignoresSafeArea()
                        SuccessfullySignedUpForEvent(successfullySignedUp: successfullySignedUp)
                            .padding(.horizontal,10)
                    }
                })
            )*/
        
    }
    
    func signUpForEvent()async{
        let eventUserId = UUID().uuidString
        let user = User(id: userState.userId, username: userState.username, firstName: userState.firstName, lastName: userState.lastName, email: userState.email, userAttemptsForClubOwnerCode: userState.userAttemptsForClubOwnerCode, userIsAddedToGroup: userState.userIsAddedToGroup)
        do {
            let queriedEvents = try await Amplify.DataStore.query(Event.self)
            for event in queriedEvents {
                let events = Event(id: event.id, title: event.title, location: event.location, description: event.description, date: event.date, start: event.start, end: event.end, capacity: event.capacity, type: event.type, publishedTime: event.publishedTime)
                let eventUser = EventUser(id: eventUserId, event: events, user: user)
                try await Amplify.DataStore.save(eventUser)
            }
            print("COMPLETE: Added user to meeting successfully!")
        }catch{
            print("Failed with error: \(error)")
        }
    }
}

