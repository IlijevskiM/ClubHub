//
//  LeaderAccessCodeView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/18/23.
//

import SwiftUI
import Amplify
import AWSCognitoIdentityProvider

struct ClubOwnerAccessCodeView: View {
    @State var becameAClubOwner = false
    @State var showPrivileges: Bool = false
    @State var accessCode: String = ""
    @State var correctCodeEntered: Bool = false
    @State var buttonPressed = false
    @Binding var ownerAccessCodeSessionTimedOut: Bool
    @Binding var clubOwnerAccessClicked: Bool
    @State var enableButton = false
    //MARK: Code for club owner access
    let clubOwnerAccessCode: String = "ow3vvnzsgtwma34"
    @EnvironmentObject var userState: UserState
    var body: some View {
        VStack {
            Text("Club Owner Access Code")
                .font(.custom("Roboto-Regular", size: 18))
                .padding(.top,20)
                .padding(.bottom,15)
                .frame(maxWidth: .infinity)
                .background(Color.white)
        
            .frame(alignment: .top)
        
        VStack(spacing: 20) {
            
            VStack(alignment: .leading, spacing: 0) {
                Text("To receive club owner privileges, visit your school's main office to obtain the code. However, they must first verify that you are a board member/leader of the club(s).")
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.gray)
              
                Button {
                    self.showPrivileges.toggle()
                    dismissKeyboard()
                } label:{
                    Text("View privileges")
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.blue)
                }
            }.padding(.vertical,10).padding(.horizontal,10)
            
            HStack(spacing: 0) {
                
                TextField("access code", text: $accessCode)
                    .font(.custom("Roboto-Regular", size: 16))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                
            }.padding(.horizontal,15).frame(height: 45).frame(maxWidth: .infinity, alignment: .leading).background(Color.white).background(Rectangle().stroke(.gray, lineWidth: 0.25))

            if correctCodeEntered == false && buttonPressed == true{
                VStack(spacing: 5) {
                        HStack(spacing: 3){
                            Image(systemName: "exclamationmark.circle")
                                .font(.system(size: 11))
                                .foregroundColor(.red)
                            Text("The code you entered is incorrect.")
                                .font(.custom("Roboto-Regular", size: 11))
                                .foregroundColor(.red)
                        }
                    if userState.userAttemptsForClubOwnerCode == 3{
                            Text("You made too many attempts. Try again later.")
                                .font(.custom("Roboto-Medium", size: 11))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.leading)
                        }
                }.padding(.horizontal,35)
            }
            
        }.frame(maxHeight: .infinity, alignment: .top).padding(.top)
        
            //TODO: Use if statement to see if user exists in the group... implementation: access to anything related to club owners only. For example.. for the Create Club option in the Side Menu
            //--- i could even use a function called "checkIfUserIsInClubOwnersGroup()" and use that in the if statement to avoid redundancy
            //TODO: Add these variables to User model so the data can be saved and not reset upon moving sheet down
        Button {
            buttonPressed = true
            // Increase user attempts by 1
            //Task { await increaseUserAttempts() }
            userState.userAttemptsForClubOwnerCode += 1
            if accessCode == clubOwnerAccessCode {
                //Task { await addUserToGroup() }
                Task { await addUserToGroup() }
                correctCodeEntered = true
                accessCode = ""
                becameAClubOwner = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    clubOwnerAccessClicked = false
                }
            }else{
                // error message vibration
                correctCodeEntered = false
                HapticsManager.instance.notification(type: .error)
            }
            if userState.userAttemptsForClubOwnerCode == 3{
                enableButton = false
                //MARK: 900 = 15 mins
                Timer.scheduledTimer(withTimeInterval: 900, repeats: false, block: { _ in
                    enableButton = true
                    ownerAccessCodeSessionTimedOut = true
                    userState.userAttemptsForClubOwnerCode = 0
                    //Task { await setUserAttemptsToZero() }
                })
            }
        } label: {
            Text("Confirm")
                .font(.custom("Roboto-Medium", size: 18))
                .foregroundColor(accessCode == "" ? Color.clear : Color.white)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .top)
                .frame(height: 60)
                .padding(.bottom,10)
                .background(
                    Rectangle()
                        .fill(accessCode == "" ? Color.clear : Color("darkBlue"))
                )
        }.frame(alignment: .bottom).disabled(userState.userAttemptsForClubOwnerCode == 3 && enableButton == false).opacity(userState.userAttemptsForClubOwnerCode == 3 && enableButton == false ? 0.6 : 1)

        
        }.background(Color("back")).ignoresSafeArea(.all, edges: .vertical)
        
            .overlay (
                ZStack(alignment: .top, content: {
                    
                    if showPrivileges{
                        Color.black.opacity(0.1)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    showPrivileges.toggle()
                                }
                            }
                            .ignoresSafeArea()
                        ClubPrivileges()
                            .padding(.horizontal,10)
                    }
                    
                        if becameAClubOwner{
                                Color.black.opacity(0.1)
                                    .ignoresSafeArea()
                                BecameAClubOwner(showClubOwnerStatus: $becameAClubOwner)
                                    .padding(.horizontal,10)
                        }
                })
            )
    }
    
    // Increases the user attempts by 1
    /*func increaseUserAttempts()async{
        var user = user
        user.userAttemptsForClubOwnerCode += 1
        do{
            let updatedUser = try await Amplify.DataStore.save(user)
            print("Updated user successfully: \(updatedUser)")
        }catch let error as DataStoreError{
            print("Failed to increase user attempts: \(error)")
        } catch{
            print("Unexpected error \(error)")
        }
    }
    
     //set user attempts to zero
    func setUserAttemptsToZero()async{
        var user = user
        user.userAttemptsForClubOwnerCode = 0
        do{
            let updatedUser = try await Amplify.DataStore.save(user)
            print("Updated user successfully: \(updatedUser)")
        }catch let error as DataStoreError{
            print("Failed to set user attempts to zero: \(error)")
        } catch{
            print("Unexpected error \(error)")
        }
    }*/
    
    // dismisses keyboard upon button press
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
        }
    
    //MARK: Adds user to user pool group "ClubOwners"
    func addUserToGroup()async{
        do {
            var user = User(id: userState.userId, username: userState.username, firstName: userState.firstName, lastName: userState.lastName, email: userState.email, userAttemptsForClubOwnerCode: userState.userAttemptsForClubOwnerCode, groups: ["ClubOwner"], userIsAddedToGroup: true)
            //user.groups?.append("ClubOwner")
            //userState.userIsAddedToGroup = true
            let savedUser = try await Amplify.DataStore.save(user)
            print("Successfully added user to group: \(savedUser)")
        }catch let error as DataStoreError{
            print("Error adding user to ClubOwners group: \(error)")
        }catch{
            print("Unexpected error occured: \(error)")
        }
    }
}
