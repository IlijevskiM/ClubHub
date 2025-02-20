//
//  ConfirmSignUpView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify

struct ConfirmSignUpView: View {
    let username: String
    let email: String
    @State var confirmationCode: String = ""
    @State var shouldShowLogin: Bool = false
    var maxAttempts = 3
    @State var userAttempts = 0
    @StateObject var otpModel: OTPViewModel = .init()
    //MARK: TextField FocusState
    @FocusState var activeField: OTPField?
    var body: some View {
        
            VStack(spacing: 20) {
                    Text("Verify your account")
                        .font(.custom("Roboto-Medium", size: 18))
                        .foregroundColor(.black)
                
                    Text("We sent a 6-digit code to \(email). Enter the code below.")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.gray)
                
                TextField("XXXXXX", text: $confirmationCode
                    //.max(6)
                )
                    .tracking(20)
                    .font(.custom("Roboto-Regular", size: 22))
                    .autocorrectionDisabled(true)
                    .padding(.leading)
                    .padding(.vertical, 10)
                    //.overlay(Rectangle().frame(height: 1).offset(y: 4), alignment: .bottom)
                    .padding(.horizontal,20)
                    //.padding(.bottom,10)
                    .frame(width: 260, alignment: .center)
                    .background(
                        Capsule().stroke(.black, lineWidth: 1)
                    )
                
                Button(action: {
                    if userAttempts >= maxAttempts {
                        //TODO: Warning popup --> you have reached the max # of attempts for this form, return to the sign up page
                        //TODO: emit log here and flag account
                    }
                    userAttempts += 1
                    Task { await confirmSignUp() }
                    //TODO: Set max attempts to 3 & flag for suspiciousness
                }) {
                    Text("Verify")
                        .font(.custom("Roboto-Medium", size: 16))
                        .foregroundColor((confirmationCode.isEmpty || (!confirmationCode.isEmpty && confirmationCode.count < 6)) ? .gray : .white)
                        .frame(maxWidth: .infinity)
                }.disabled((confirmationCode.isEmpty || (!confirmationCode.isEmpty && confirmationCode.count < 6)))
                    .padding(.horizontal)
                    .padding(.vertical,17)
                    .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill((confirmationCode.isEmpty || (!confirmationCode.isEmpty && confirmationCode.count < 6)) ? Color.gray.opacity(0.2) : Color("darkBlue"))
                    )
                
                Button(action: {
                    Task { await resendCode() }
                }) {
                    Text("Resend Code")
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.gray)
                }
                
            }.padding(.horizontal,15)
            .onChange(of: otpModel.otpFields) { newValue in
                OTPCondition(value: newValue)
            }
                .navigationDestination(isPresented: .constant(shouldShowLogin)){
                    Login()
                        .navigationBarBackButtonHidden(true)
                }
            }
    
    //MARK: Conditions for custom OTP Field & limiting only one text
    func OTPCondition(value: [String]){
        
        //Moving next field if current field type
        for index in 0..<5{
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField{
                activeField = activeStateForIndex(index: index + 1)
            }
        }
        
        //moving back if current is empty and previous is not empty
        for index in 1...5{
            if value[index].isEmpty && !value[index - 1].isEmpty{
                activeField = activeStateForIndex(index: index - 1)
            }
        }
        
        for index in 0..<6{
            if value[index].count > 1{
                otpModel.otpFields[index] = String(value[index].last!)
            }
        }
    }
    
    @ViewBuilder
    func OTPField()->some View {
        HStack(spacing: 14) {
            ForEach(0..<6, id: \.self) { index in
                VStack(spacing: 8) {
                    TextField("", text: $otpModel.otpFields[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField,equals: activeStateForIndex(index: index))
                    
                    Rectangle()
                        .fill(activeField == activeStateForIndex(index: index) ? .blue : .gray.opacity(0.3))
                        .frame(height: 4)
                }
                .frame(width: 40)
            }
        }
    }
    
    func confirmSignUp()async{
        do{
            let result = try await Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode)
            switch result.nextStep {
            case .done:
                DispatchQueue.main.async {
                    self.shouldShowLogin = true
                }
            default:
                print(result.nextStep)
            }
        }catch{
            print(error)
        }
    }
    
    func resendCode() async{
        do{
            let deliveryDetails = try await Amplify.Auth.resendConfirmationCode(forUserAttributeKey: .email)
            print("Resend code send to - \(deliveryDetails)")
        } catch let error as AuthError {
            print("Resend code failed with error \(error)")
        }catch{
            print("Unexpected error: \(error)")
        }
    }
    
    func activeStateForIndex(index: Int)->OTPField{
        switch index{
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        default: return .field6
        }
    }
}

//MARK: FocusState enum
enum OTPField{
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6
}

