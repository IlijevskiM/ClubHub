//
//  SavedPage.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/16/23.
//

import SwiftUI
import Amplify
import Combine

struct SavedPage: View {
    @State var currentTab = "All"
    var column = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    //@Binding var saved: Bool
    @State var posts: [Post] = []
    @State var tokens: Set<AnyCancellable> = []
    /*@State var addCollection = false
    @State var newCollectionName = ""*/
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack{
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            SavedFilter(currentTab: $currentTab, tabTitle: "All")
                            SavedFilter(currentTab: $currentTab, tabTitle: "Science Olympiad")
                            SavedFilter(currentTab: $currentTab, tabTitle: "Key Club")
                            SavedFilter(currentTab: $currentTab, tabTitle: "Chess")
                            SavedFilter(currentTab: $currentTab, tabTitle: "Care")
                            SavedFilter(currentTab: $currentTab, tabTitle: "Model United Nations")
                            SavedFilter(currentTab: $currentTab, tabTitle: "National Honors Society")
                            SavedFilter(currentTab: $currentTab, tabTitle: "Student Council")
                        }.padding(.horizontal,10)
                    }.padding(.vertical,5).padding(.bottom,3).background(.white)
                }
                Divider()
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 5){
                        if posts.isEmpty {
                            Text("No posts yet..")
                                .font(.custom("Roboto-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top, 15)
                        } else {
                            ForEach(posts) { post in
                                ReusablePost(post: post)
                            }
                        }
                    }.padding(.bottom,15).onAppear(perform: observeSavedPosts)
                }
            }.background(Color("back"))
            /*ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: column, spacing: 15) {
                    ForEach(savedclub) { save in
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Image(save.clubProfile)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 180)
                                .background(RoundedRectangle(cornerRadius: 5).fill(.white))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Text(save.clubName)
                                .font(.custom("Roboto-Medium", size: 14))
                                .foregroundColor(.black)
                        }
                    }
                }.padding(.horizontal,10)
            }.padding(.top,10).background(Color("back"))*/
                /*.toolbar {
                    Button {
                        self.addCollection.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }.fullScreenCover(isPresented: $addCollection) {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Button {
                                    self.addCollection.toggle()
                                } label: {
                                    Text("Cancel")
                                        .font(.custom("Roboto-Regular", size: 16))
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Text("New Collection")
                                    .font(.custom("Roboto-Medium", size: 18))
                                    .foregroundColor(.black)
                                    .padding(.leading,-3)
                                Spacer()
                                Button {
                                    self.addCollection.toggle()
                                } label: {
                                    Text("Done")
                                        .font(.custom("Roboto-Regular", size: 16))
                                        .foregroundColor(newCollectionName != "" ? Color("darkBlue") : .gray)
                                }
                            }.padding(.horizontal, 15)
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Name")
                                    .font(.custom("Roboto-Medium", size: 16))
                                    .foregroundColor(.black)
                                
                                TextField("Collection Name", text: $newCollectionName)
                                    .font(.custom("Roboto-Regular", size: 16))
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }.padding(.horizontal, 15)
                        }.padding(.top,10)
                    }
                }.background(.white)*/
        }.navigationTitle("Saved")
    }
    
    func observeSavedPosts() {
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: Post.self, where: Post.keys.saved == true))
            .map(\.items)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print($0) }
                  , receiveValue: { posts in
                print("Post count:", posts.count)
                self.posts = posts.sorted {
                    guard let date1 = $0.createdAt,
                          let date2 = $1.createdAt else {return false}
                    return date1 > date2
                }
            }
        )
        .store(in: &tokens)
    }
}

struct SavedFilter: View {
    @Binding var currentTab: String
    var tabTitle : String
    //var animation : Namespace.ID
    
    var body: some View {
        
    HStack {
        
        Button(action: {
            //withAnimation{currentTab = tabTitle}
            currentTab = tabTitle
        }) {
            
            Text(tabTitle)
                .font(.custom("Roboto-Medium", size: 14))
                .foregroundColor(currentTab == tabTitle ? Color("darkBlue") : Color("darkGray"))
                .padding(.horizontal).padding(.vertical,5)
                .background(Capsule().strokeBorder(currentTab == tabTitle ? Color("darkBlue") : Color("back"), lineWidth: 1.5))
            }
        }
    }
}
