//
//  GetStarted.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct GetStarted: View {
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    @State var addClub = false
    @State var clubJoined = false
    @Binding var closeGetStartedPage: Bool
    var body: some View {
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    Text("Get Started")
                        .font(.custom("Roboto-Medium", size: 25))
                    Text("Select the clubs that you would \nlike to join")
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                
                        LazyVGrid(columns: columns, spacing: 20) {
                            
                            ForEach(clubGridInfo) { club in
                                
                                VStack(alignment: .center, spacing: 10) {
                                    Image(club.clubProfile)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 65, height: 65)
                                        .clipShape(Circle())
                                    
                                    Text(club.clubName)
                                        .font(.custom("Roboto-Regular", size: 16))
                                        .multilineTextAlignment(.center)
                                    
                                    Text(club.clubTag)
                                        .font(.custom("Roboto-Medium", size: 11))
                                        .foregroundColor(Color("darkBlue"))
                                        .padding(.horizontal,10)
                                        .padding(.vertical,5)
                                        .background(Capsule().foregroundColor(Color("darkBlue").opacity(0.1)))
                                    
                                    Button {
                                        self.addClub.toggle()
                                    } label: {
                                        if clubJoined == false {
                                            Image(systemName: "plus")
                                                .font(.system(size: 18))
                                                .foregroundColor(.gray.opacity(0.8))
                                                .padding(10)
                                                .background(Circle().stroke(Color("back"), lineWidth: 2))
                                                .padding(.top,10)
                                        } else {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 18))
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(Circle().fill(.black))
                                                .padding(.top,10)
                                        }
                                    }/*.sheet(isPresented: $addClub) {
                                        JoinClub(addClub: $addClub, clubJoined: $clubJoined)
                                    }*/
                                }
                            }.padding().padding(.vertical,5).background(RoundedRectangle(cornerRadius: 15).stroke(Color("back"), lineWidth: 1.5).frame(width: 175))
                        }.padding(.top,18).padding(.horizontal,25)
                    }
                    
                    Spacer()
            }.padding(.top,75).padding(.bottom, clubJoined ? 85 : 30).edgesIgnoringSafeArea([.top, .bottom])
            
            if clubJoined == true {
                ZStack {
                    Rectangle().foregroundColor(.white).frame(height: 80).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom).ignoresSafeArea(edges: .bottom).shadow(color: .gray.opacity(0.15),radius: 4)
                    
                    HStack(spacing: 12) {
                        Text("Joined")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.gray)
                        //MARK: change so that it updates the number of clubs actually joined
                        Text("1").font(.custom("Roboto-Medium", size: 16))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Circle().fill(Color("back")))
                        Text("club").font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring()) {
                                self.closeGetStartedPage.toggle()
                            }
                        } label: {
                            Text("Done").foregroundColor(Color("darkBlue")).font(.custom("Roboto-Medium", size: 16))
                        }
                    }.padding(.horizontal, 30).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
    }
}

// Club grid model data..
struct ClubGrid: Identifiable {
    var id: Int
    var clubProfile: String
    var clubName: String
    var clubTag: String
}

var clubGridInfo = [

ClubGrid(id: 0, clubProfile: "so", clubName: "Science Olympiad", clubTag: "STEM"),
ClubGrid(id: 1, clubProfile: "chess", clubName: "Chess", clubTag: "LOGIC"),
ClubGrid(id: 2, clubProfile: "kc", clubName: "Key Club", clubTag: "VOLUNTEERING"),
ClubGrid(id: 3, clubProfile: "care", clubName: "Care", clubTag: "VOLUNTEERING"),
ClubGrid(id: 4, clubProfile: "nhs", clubName: "National Honors Society", clubTag: "VOLUNTEERING"),
ClubGrid(id: 5, clubProfile: "mun", clubName: "Model UN", clubTag: "LOGIC"),
]

