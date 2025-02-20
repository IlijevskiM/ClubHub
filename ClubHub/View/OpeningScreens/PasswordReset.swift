//
//  PasswordReset.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/19/23.
//

import SwiftUI
import Amplify


struct PasswordReset: View {
    let showLogin: () -> Void
    
    @State var username: String = ""
    @State var oldPassword: String = ""
    @State var newPassword: String = ""
    //@Environment(\.dismiss) var dismiss
    @State var shouldShowConfirmPasswordReset: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            Group {
                Text("Forgot your password?")
                    .foregroundColor(.black)
                    .font(.custom("BeVietnamPro-Regular", size: 25))

                Text("No problem! We'll send reset instructions to the email registered with your account.")
                    .foregroundColor(.gray)
                    .font(.custom("BeVietnamPro-Regular", size: 15))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

            }.padding(.bottom,10)

            Group {
                
//                Text("Old Password")
//                    .font(.custom("BeVietnamPro-Regular", size: 14))
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading,30)
//                    .padding(.bottom,5)
//
//                SecureField("Enter old password", text: $oldPassword)
//                    .font(.custom("BeVietnamPro-Regular", size: 14))
//                    .padding(.leading)
//                    .padding(.vertical, 13)
//                    .background(Capsule().stroke(Color.gray))
//                    .padding(.horizontal)
//                    .padding(.bottom,10)
//                    .autocapitalization(.none)
//                    .autocorrectionDisabled(true)

                Text("Username")
                    .font(.custom("BeVietnamPro-Regular", size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,30)
                    .padding(.bottom,5)

                TextField("Enter username", text: $username)
                    .font(.custom("BeVietnamPro-Regular", size: 14))
                    .padding(.leading)
                    .padding(.vertical, 13)
                    .background(Capsule().stroke(Color.gray))
                    .padding(.horizontal)
                    .padding(.bottom,10)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                
                Text("New Password")
                    .font(.custom("BeVietnamPro-Regular", size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,30)
                    .padding(.bottom,5)

                SecureField("Enter new password", text: $newPassword)
                    .font(.custom("BeVietnamPro-Regular", size: 14))
                    .padding(.leading)
                    .padding(.vertical, 13)
                    .background(Capsule().stroke(Color.gray))
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)

            }


            Button(action: {
                // may need to move this OUT of action
                shouldShowConfirmPasswordReset = true
                Task { await resetPassword(username: username) }
            }) {
                // need to use isEmpty for checking empty strings
                Text("Reset")
                    .foregroundColor((username.isEmpty || newPassword.isEmpty) ? .gray : .white)
                    .font(.custom("BeVietnamPro-Regular", size: 14))
                    .frame(maxWidth: .infinity)

            }
            .disabled(username.isEmpty || newPassword.isEmpty)
            .padding(.vertical, 13)
            .background(Capsule().fill((username.isEmpty || newPassword.isEmpty) ? Color.gray.opacity(0.2) : Color("Sports")))
            .padding(.horizontal)
            .padding(.top)
            
            Button(action: showLogin) {
                HStack(spacing: 5){
                    Image(systemName: "arrow.left")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                    
                    Text("Return to login")
                        .foregroundColor(.black)
                        .font(.custom("BeVietnamPro-Regular", size: 14))
                    
                }.frame(maxWidth: .infinity)
                
            }
            .padding(.vertical, 13)
            .background(Capsule().stroke(Color.black))
            .padding(.horizontal)
            .padding(.top)

        }
        .navigationDestination(isPresented: .constant(shouldShowConfirmPasswordReset)) {
            ConfirmPasswordResetView(username: username, newPassword: newPassword)
        }//.accentColor(.black)
    }
}

struct ConfirmPasswordResetView : View {
    let username: String
    let newPassword: String
    @State var confirmationCode: String = ""
    @State var shouldShowLogin: Bool = false
    var body: some View {
        VStack(spacing: 15) {
            Text("Confirm your password reset.")
                .font(.custom("BeVietnamPro-Regular", size: 25))
            Text(verbatim: "We sent a 6-digit code to the email registered with this account. Please enter this code below.")
                .font(.custom("BeVietnamPro-Regular", size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            
            TextField("XXXXXX", text: $confirmationCode
                //.max(6)
            )
                .tracking(20) // adds spacing between digits
                .font(.custom("BeVietnamPro-Regular", size: 22))
                .autocorrectionDisabled(true)
                .padding(.leading)
                .padding(.vertical, 13)
                //.background(Capsule().stroke(Color.gray))
                .overlay(Rectangle().frame(height: 1).offset(y: 4)
                         , alignment: .bottom)
                .padding(.horizontal, 20)
                .padding(.bottom,10)
                .frame(width:265, alignment: .center)
            
            
            Button(action: {
                Task { await confirmResetPassword(username: username, newPassword: newPassword, confirmationCode: confirmationCode) }
                // TODO: set max attempts to 3 & flag for suspiciousness
            }) {
                Text("Verify")
                    .foregroundColor((confirmationCode.isEmpty || (!confirmationCode.isEmpty && confirmationCode.count < 6)) ? .gray : .white)
                    .font(.custom("BeVietnamPro-Regular", size: 14))
                    .frame(maxWidth: .infinity)
                
            }
            .disabled((confirmationCode.isEmpty || (!confirmationCode.isEmpty && confirmationCode.count < 6)))
            .padding(.vertical, 13)
            // TODO: change color when all fields are filled
            .background(Capsule().fill((confirmationCode.isEmpty || (!confirmationCode.isEmpty && confirmationCode.count < 6)) ? Color.gray.opacity(0.2) : Color("Sports")))
            .padding(.horizontal, 30)
            //.padding(.top)
            
            // TODO: add "Resend code" in indigo letters beneath the Verify button so that user can resend code if not received
            // TODO: or, add an option to return to the sign up screen
            HStack{
                Spacer()
                // TODO: fix "resend code" because it throws error: Resend code failed with error AuthError: There is no user signed in to retreive cognito tokens
                Button(action: {
                    Task { await resendCode() }
                }) {
                    Text("Resend Code")
                        .foregroundColor(Color("Sports"))
                        .font(.custom("BeVietnamPro-Regular", size: 14))
                }
                Spacer()
            }
            

        }
        // 2
        .navigationDestination(isPresented: .constant(shouldShowLogin)) {
            Login()
                .navigationBarBackButtonHidden(true)
                //.accentColor(.black)
        }
        //.accentColor(.black)
    }
    
    // TODO: fix Resend Code - it does not work bc the user is not actually logged in
    func resendCode() async {
        do {
            let deliveryDetails = try await Amplify.Auth.resendConfirmationCode(forUserAttributeKey: .email)
            print("Resend code send to - \(deliveryDetails)")
        } catch let error as AuthError {
            print("Resend code failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func confirmResetPassword(
        username: String,
        newPassword: String,
        confirmationCode: String
    ) async {
        do {
            try await Amplify.Auth.confirmResetPassword(
                for: username,
                with: newPassword,
                confirmationCode: confirmationCode
            )
            DispatchQueue.main.async {
                self.shouldShowLogin = true
            }
            print("Password reset confirmed")
        } catch let error as AuthError {
            print("Reset password failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}

func resetPassword(username: String) async {
    do {
        let resetResult = try await Amplify.Auth.resetPassword(for: username)
        switch resetResult.nextStep {
            case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
            case .done:
                print("Reset completed")
        }
    } catch let error as AuthError {
        print("Reset password failed with error \(error)")
    } catch {
        print("Unexpected error: \(error)")
    }
}

func changePassword(oldPassword: String, newPassword: String) async {
    do {
        try await Amplify.Auth.update(oldPassword: oldPassword, to: newPassword)
        print("Change password succeeded")
    } catch let error as AuthError {
        print("Change password failed with error \(error)")
    } catch {
        print("Unexpected error: \(error)")
    }
}

