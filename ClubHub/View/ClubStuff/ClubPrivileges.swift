//
//  ClubPrivileges.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 7/4/23.
//

import SwiftUI

struct ClubPrivileges: View {
    var body: some View {
        HStack(spacing: 10) {
            //Individual
            VStack(alignment: .leading, spacing: 10){
                Image(systemName: "person.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.blue.opacity(0.1)))
                
                Text("Individual")
                    .font(.custom("Roboto-Medium", size: 16))
                    .foregroundColor(.black)
                Text("Features")
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.black)
                    .padding(.top,-5)
                privileges(image: "check", text: "Make posts")
                privileges(image: "check", text: "Join clubs")
                privileges(image: "check", text: "Participate in events")
                Spacer()
            }.frame(height: 302.5).padding(.top,5).padding(15).background(RoundedRectangle(cornerRadius: 10).stroke(.blue, lineWidth: 1.5))
            
            //team
            VStack(alignment: .leading, spacing: 10){
                Image("starFilled")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 21, height: 21)
                    .foregroundColor(Color("yellow."))
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("yellow.").opacity(0.1)))
                
                Text("Team")
                    .font(.custom("Roboto-Medium", size: 16))
                    .foregroundColor(.black)
                Text("Features")
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.black)
                    .padding(.top,-5)
                privileges(image: "check", text: "Make posts")
                privileges(image: "check", text: "Join clubs")
                privileges(image: "check", text: "Participate in events")
                privileges(image: "check", text: "Add/Remove members")
                privileges(image: "check", text: "Edit member hours")
                privileges(image: "check", text: "Manage clubs")
                privileges(image: "check", text: "Administer events")
            }.padding(.top,5).padding(15).background(RoundedRectangle(cornerRadius: 10).stroke(Color("yellow."), lineWidth: 1.5))
                .overlay {
                    Text("For Owners")
                        .font(.custom("Roboto-Medium", size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical,5)
                        .background(Capsule().fill(Color("yellow.")))
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top,-12)
                }
        }.padding(.horizontal,18).padding(.vertical,20).background(RoundedRectangle(cornerRadius: 10).fill(.white)
            //.background(RoundedRectangle(cornerRadius: 10).stroke(.gray.opacity(0.8), lineWidth: 0.5))
        )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .transition(.move(edge: .bottom))
            .animation(.spring())
    }
    
    func privileges(image: String, text: String)-> some View{
        HStack(spacing: 5) {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .frame(width: 15, height: 15)
                .foregroundColor(Color("darkGray"))
            Text(text)
                .font(.custom("Roboto-Regular", size: 14))
                .foregroundColor(Color("darkGray"))
        }
    }
}

struct ClubPrivileges_Previews: PreviewProvider {
    static var previews: some View {
        ClubPrivileges()
    }
}
