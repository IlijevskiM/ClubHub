//
//  Login.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify
import PhotosUI

struct Login: View {
    @State var createAccount: Bool = false
    //MARK: User Details
    @State var password: String = ""
    @State var username: String = ""
    @State var showPasswordReset: Bool = false
    // MARK: View Properties
    @Environment(\.dismiss) var dismiss
    
    //MARK: AWS Data
    @State var shouldShowSignUp: Bool = false
    var body: some View {
        
        NavigationStack {
            VStack {
                
                // Log In title
                HStack(spacing: 10) {
                    Text("Welcome back")
                        .font(.title)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding(.bottom,20)
                    Text("👋")
                        .font(.system(size: 25))
                        .padding(.top,-18)
                }.hAlign(.leading)
                
                // email and password fields
                VStack(spacing: 35) {
                    
                    VStack(spacing: 3) {
                            
                            TextField("Username", text: $username)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .textContentType(.emailAddress)
                                .font(.custom("Roboto-Regular", size: 16))
                                .padding(.vertical,3)
                        
                        Divider()
                            
                    }.hAlign(.leading)
                    
                    VStack(spacing: 3) {
                            
                            SecureField("Password", text: $password)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(.custom("Roboto-Regular", size: 16))
                                .padding(.vertical,3)
                        
                        Divider()
                            
                    }.hAlign(.leading)
                    
                    // For resetting password when signing in
                    Button(action: {
                        showPasswordReset = true
                    }) {
                        Text("Reset password?")
                            .font(.custom("Roboto-Regular", size: 14))
                            .padding(.bottom,14)
                            .tint(.gray)
                            .hAlign(.trailing)
                            .padding(.top,-15)
                    }
                    
                }.hAlign(.leading).padding(.vertical,5)
                
                VStack(spacing: 18) {
                    Button {
                        Task { await login() }
                    } label: {
                        Text("Log in")
                            .foregroundColor((username.isEmpty || password.isEmpty) ? .gray : .white)
                            .font(.custom("Roboto-Medium", size: 15))
                            .frame(maxWidth: .infinity)
                            
                    }.disabled(username.isEmpty || password.isEmpty)
                        .padding(.horizontal)
                        .padding(.vertical,17)
                        .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill((username.isEmpty || password.isEmpty) ? Color.gray.opacity(0.2) : Color("darkBlue"))
                        )
                    
                    /*HStack(spacing: 0) {
                        Image("google")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Log in with Google")
                            .foregroundColor(.black)
                            .font(.custom("Roboto-Regular", size: 15))
                            .padding(.horizontal)
                            .padding(.vertical,17)
                    }.background(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black, lineWidth: 1)
                            .frame(width: 325)
                            //.shadow(color: .gray.opacity(0.1), radius: 5, y: 3)
                        )*/
                    
                }.hAlign(.center).padding(.top,10)
                
                Spacer()
                
                Button(action: { shouldShowSignUp = true }) {
                    Group {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        +
                            Text(" Sign up")
                                .foregroundColor(.black)
                    }.font(.custom("Roboto-Regular", size: 16))
                }
                
            }
            //.hAlign(.leading)
            .padding(15)
            .padding(.top,25)
            .navigationDestination(isPresented: $shouldShowSignUp) {
                Signup(showLogin: { shouldShowSignUp = false })
                    .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $showPasswordReset) {
                PasswordReset(showLogin: { showPasswordReset = false })
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    func login()async{
        do{
            let result = try await Amplify.Auth.signIn(username: username, password: password)
            switch result.nextStep {
            case .done:
                print("login is done")
            default:
                print(result.nextStep)
            }
        }catch{
            print(error)
        }
    }
}

