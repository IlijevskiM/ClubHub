//
//  BaseView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct MainView: View {
    
    @State var showMenu: Bool = false
    @State var searchPosts: String = ""
    @State var showCreatePostPage: Bool = false
    
    //Offset for both Drag gesture and showing Menu...
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    let black = Color("AccentColor")
    let white = Color("white")
    @State var currentTab: String = "home"
    @State var oldSelectedItem: String = "home"
    @Namespace var animation
    /*init() {
        UITabBar.appearance().backgroundColor = .clear
        }*/
    //@State var edge = UIApplication.shared.windows.first?.safeAreaInsets
    var body: some View {
        
        let sideBarWidth = getRect().width - 90
        //Entire view...
            HStack(spacing: 0) {
                
                //Side menu
                Sidemenu(showMenu: $showMenu)
                
                //Main Tab view...
                VStack(spacing: 0) {
                    
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                        
                            TabView(selection: $currentTab) {
                                Home(showMenu: $showMenu, searchPosts: $searchPosts)
                                    .navigationBarTitleDisplayMode(.inline)
                                    .navigationBarHidden(true)
                                    //.toolbar(.hidden, for: .tabBar)
                                    //.toolbarBackground(.hidden, for: .tabBar)
                                    .tag("home")
                                
                                /*CreatePost(
                                    //showCreatePostPage: $showCreatePostPage
                                )*/
                                //Home(showMenu: $showMenu, searchPosts: $searchPosts)
                                Home(showMenu: $showMenu, searchPosts: $searchPosts)
                                    .navigationBarTitleDisplayMode(.inline)
                                    .navigationBarHidden(true)
                                    //.toolbar(.hidden, for: .tabBar)
                                    //.toolbarBackground(.hidden, for: .tabBar)
                                    .tag("plus")
                                
                                NotificationView()
                                    .navigationBarTitleDisplayMode(.inline)
                                    .navigationBarHidden(true)
                                    //.toolbar(.hidden, for: .tabBar)
                                    //.toolbarBackground(.hidden, for: .tabBar)
                                    .tag("bell")
                                
                                ProfileView()
                                    .navigationBarTitleDisplayMode(.inline)
                                    .navigationBarHidden(true)
                                    //.toolbar(.hidden, for: .tabBar)
                                    //.toolbarBackground(.hidden, for: .tabBar)
                                    .tag("profile")
                                
                            }
                            .onChange(of: currentTab) {
                                if "plus" == currentTab {
                                self.showCreatePostPage = true
                                } else {
                                    self.oldSelectedItem = $0
                                }
                            }.fullScreenCover(isPresented: $showCreatePostPage, onDismiss : {
                                self.currentTab = self.oldSelectedItem
                            }) {
                                CreatePost(showCreatePostPage: $showCreatePostPage)
                            }.ignoresSafeArea(.all, edges: .bottom)
                        
                        VStack(spacing: 0) {
                            Divider()
                            HStack(spacing: 0) {
                                
                                ForEach(tabs, id: \.self) { image in
                                    
                                    mainTabButton(image: image, currentTab: $currentTab)
                                    
                                    // equal spacing
                                    if image != tabs.last{
                                        Spacer(minLength: 0)
                                    }
                                }
                            }.padding(.horizontal,45).background(.white)//.background(AnyShapeStyle(.ultraThinMaterial))
                        }
                        //.padding(.bottom,edge!.bottom == 0 ? 15 : edge!.bottom)
                        //.background(Color.white.opacity(0.25))
                        /*.padding(.horizontal,20)
                        .background(.white)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.1), radius: 3)
                        .padding(.horizontal, 50)
                        .padding(.bottom,edge!.bottom == 0 ? 20 : 0)*/
                        
                        // ignoring tab view elevation...
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                .frame(width: getRect().width)
                //BG when menu is showing
                .overlay(
                Rectangle()
                    .fill(
                        Color.black.opacity(Double((offset / sideBarWidth) / 5))
                    )
                    .ignoresSafeArea(.container, edges: .vertical)
                    .onTapGesture {
                        withAnimation{
                            showMenu.toggle()
                        }
                    }
                )
            }
            // max size...
            .frame(width: getRect().width + sideBarWidth)
            .offset(x: -sideBarWidth / 2)
            .offset(x: offset)
            
            //No nav bar title
            //Hiding nav bar
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .animation(.easeOut, value: offset == 0)
            .onChange(of: showMenu) { newValue in
            if showMenu && offset == 0 {
                offset = sideBarWidth
                lastStoredOffset = offset
            }
            if !showMenu && offset == sideBarWidth {
                offset = 0
                lastStoredOffset = 0
            }
        }
            .background(Color.white)
    }
}

// tabs
// image names
var tabs = ["home", "plus", "bell", "profile"]

struct mainTabButton: View {
    var image: String
    @Binding var currentTab: String
    var body: some View {
        Button(action: {currentTab = image}) {
            
            Image(image)
                .renderingMode(.template)
                .foregroundColor(currentTab == image ? .black : Color("darkGray"))
                .padding()
        }
    }
}
