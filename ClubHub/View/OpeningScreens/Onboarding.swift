//
//  Onboarding.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

/*import SwiftUI

struct Onboarding: View {
    var body: some View {
        
        NavigationStack {
                    
                VStack {

                    VStack {
                            
                            HStack(spacing: 0) {
                                Text("Club")
                                    .font(.custom("Roboto-Regular", size: 30))
                                    .foregroundColor(Color("darkBlue"))
                                    .opacity(0.9)
                                Text("Hub")
                                    .font(.custom("Roboto-Bold", size: 30))
                                    .foregroundColor(Color("darkBlue"))
                            }.padding(.top,15)
                            
                    TabView {
                        Pages(image: "landingpage1", title: "Make it easy.", bodyText: "Manage and track your school's events on the go.")
                        Pages(image: "landingpage2", title: "Meet new people.", bodyText: "Make new friends while participating \nin events.")
                        Pages(image: "landingpage3", title: "Have Fun.", bodyText: "Explore the multitude of clubs offered at your school.")
                        
                    }.tabViewStyle(.page(indexDisplayMode: .always)).indexViewStyle(.page(backgroundDisplayMode: .always)).padding(.bottom,20)
                }
                
                    HStack(spacing: 15) {
                    
                    Text("Leader")
                        .font(.custom("Roboto-Medium", size: 18))
                        .foregroundColor(Color("darkBlue"))
                        .padding(.horizontal,50)
                        .padding(.vertical,15)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color("darkBlue"), lineWidth: 2)
                        )
                   
                    NavigationLink {
                        //Register()
                    } label: {
                        Text("Member")
                            .font(.custom("Roboto-Medium", size: 18))
                            .foregroundColor(Color("darkBlue"))
                            .padding(.horizontal,44)
                            .padding(.vertical,15)
                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color("darkBlue"), lineWidth: 2)
                            )
                    }.navigationTitle("")
                    
                    }.padding(.bottom,25)
                
                
                HStack(spacing: 5) {
                    Text("Already have an account?")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.gray)
                    
                    NavigationLink {
                        //Login()
                    } label: {
                        Text("Log in")
                            .font(.custom("Roboto-Medium", size: 16))
                            .foregroundColor(.black)
                    }
                }
                    
            }.padding(.top,25).background(.white)
        }
    }
}

struct Pages: View {
    
    let image: String
    let title: String
    let bodyText: String
    
    var body: some View {
    
        VStack(spacing: 0) {
            Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 400, height: 400)
        
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.custom("Roboto-Bold", size: 32))
                    .foregroundColor(.black)
                Text(bodyText)
                    .font(.custom("Roboto-Regular", size: 18))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(5)
            }.frame(maxWidth: .infinity, alignment: .bottomLeading).padding(.leading,45)
        }.padding(.bottom,55)
    }
}*/
