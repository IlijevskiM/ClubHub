//
//  Register.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify
import PhotosUI

struct Signup: View {
    //MARK: User Details
    @State var email: String = ""
    @State var password: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var username: String = ""
    // MARK: View Properties
    @State var userAgreed: Bool = false
    //MARK: AWS Data
    @State var shouldShowConfirmSignUp: Bool = false
    let showLogin: () -> Void
    var body: some View {
        
            VStack {
                
                // create account title
                Text("Create account")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.bottom,15)
                    .hAlign(.leading)
                
                    // name, email, password, school fields
                    VStack(spacing: 35) {
                        
                        //first name
                        VStack(spacing: 3) {
                                
                                TextField("First Name", text: $firstName)
                                .font(.custom("Roboto-Regular", size: 16))
                                    .autocorrectionDisabled(true)
                                    .padding(.vertical,3)
                            
                            Divider()
                                
                        }.hAlign(.leading)
                        
                        //last name
                        VStack(spacing: 3) {
                                
                                TextField("Last Name", text: $lastName)
                                .font(.custom("Roboto-Regular", size: 16))
                                    .autocorrectionDisabled(true)
                                    .padding(.vertical,3)
                            
                            Divider()
                                
                        }.hAlign(.leading)
                        //username
                        VStack(spacing: 3) {
                                
                                TextField("Username", text: $username)
                                .font(.custom("Roboto-Regular", size: 16))
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .padding(.vertical,3)
                            
                            Divider()
                                
                        }.hAlign(.leading)
                        
                        //email
                        VStack(spacing: 3) {
                                
                            TextField("Email", text: $email)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .textContentType(.emailAddress)
                                    .padding(.vertical,3)
                            
                            Divider()
                                
                        }.hAlign(.leading)
                        
                        //password
                        VStack(spacing: 3) {
                                
                                SecureField("min. 8 characters", text: $password)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .padding(.vertical,3)
                            
                            Divider()
                                
                        }.hAlign(.leading)
                        
                    }.hAlign(.leading).padding(.vertical,5)
                    
                    // terms of service and privacy policy prompt
                    HStack (spacing: 5) {
                        
                        Button {
                            self.userAgreed.toggle()
                        } label: {
                            Image(systemName: userAgreed ? "checkmark.square.fill" : "square")
                                .foregroundColor(userAgreed ? .black : .gray.opacity(0.5))
                                .font(.system(size: 20))
                        }
                        Text("I agree to the")
                            .foregroundColor(.black)
                            .font(.custom("Roboto-Regular", size: 14))
                        Text("Terms & Conditions")
                            .foregroundColor(.blue)
                            .font(.custom("Roboto-Regular", size: 14))
                        Text("and")
                            .foregroundColor(.black)
                            .font(.custom("Roboto-Regular", size: 14))
                        Text("Privacy Policy")
                            .foregroundColor(.blue)
                            .font(.custom("Roboto-Regular", size: 14))
                        
                    }.hAlign(.leading).padding(.vertical,15)
                    
                    // create account button & alternative sign up
                    VStack(spacing: 15) {
                        
                        //if firstName || lastName || username || email || password == "" && checked == false {
                            /*Button {
                                
                            } label: {
                                Text("Sign Up")
                                    .foregroundColor(.white)
                                    .font(.custom("Roboto-Medium", size: 15))
                                    .padding(.horizontal)
                                    .padding(.vertical,17)
                                    .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(.gray)
                                        .frame(width: 325)
                                    )
                            }.disabled(true)*/
                        //} else {
                        Button(action: {
                            Task { await signUp() }
                        }) {
                            Text("Sign Up")
                                .foregroundColor((firstName.isEmpty || lastName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || !userAgreed) ? .gray : .white)
                                .font(.custom("Roboto-Medium", size: 15))
                                .frame(maxWidth: .infinity)
                        }.disabled(firstName.isEmpty || lastName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || !userAgreed)
                            .padding(.horizontal)
                            .padding(.vertical,17)
                            .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill((firstName.isEmpty || lastName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || !userAgreed) ? Color.gray.opacity(0.2) : Color("darkBlue"))
                            )
                        //}
                        
                        /*HStack(spacing: 0) {
                            Image("google")
                                .resizable()
                                .frame(width: 25, height: 25)
                            
                            Text("Sign up with Google")
                                .foregroundColor(.black)
                                .font(.custom("Roboto-Regular", size: 15))
                                .padding(.horizontal)
                                .padding(.vertical,17)
                        }.background(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.black, lineWidth: 1)
                                .frame(width: 325)
                                //.shadow(color: .gray.opacity(0.2), radius: 5, y: 3)
                            )*/
                        
                        
                    }.hAlign(.center).padding(.top,10)
                
                Spacer()
                
                // Already have an account?
                Button(action: showLogin) {
                    Group {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        +
                            Text(" Log in")
                                .foregroundColor(.black)
                    }.font(.custom("Roboto-Regular", size: 16))
                }.padding(.bottom,10)
                
            }
            .padding(15)
            .padding(.top,25)
            .navigationDestination(isPresented: .constant(shouldShowConfirmSignUp)) {
                ConfirmSignUpView(username: username, email: email)
                    .navigationBarBackButtonHidden(true)
            }
    }
    
    func signUp()async{
        let options = AuthSignUpRequest.Options(userAttributes: [.init(.email, value: email), .init(.givenName, value: firstName), .init(.familyName, value: lastName)])
        do{
            let result = try await Amplify.Auth.signUp(username: username, password: password, options: options)
            
            switch result.nextStep {
            case .confirmUser:
                DispatchQueue.main.async{
                    self.shouldShowConfirmSignUp = true
                }
            default:
                print(result)
            }
        }catch{
           print(error)
        }
    }
}

// MARK: View Extensions for UI Building
extension View {
    // Closing all active Keyboards
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // MARK: Disabling with Opacity
    func disableWithOpacity(_ condition: Bool)-> some View {
        self.disabled(condition).opacity(condition ? 0.6 : 1)
    }
    
    func hAlign(_ alignment: Alignment)-> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    func vAlign(_ alignment: Alignment)-> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func customTextFieldBorder(_ color: Color)-> some View {
        self.padding(.horizontal).padding(.vertical,10).background {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(color)
        }
    }
}
