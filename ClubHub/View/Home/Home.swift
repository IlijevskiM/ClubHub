//
//  Home.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify
import Combine

struct Home: View {
    @EnvironmentObject var userState: UserState
    //MARK: View Properties
    @Binding var showMenu: Bool
    @State var current = "Activity"
    @Binding var searchPosts: String
    @Namespace var animation
    @State var commentText = ""
    @State var commented = false
    //@Binding var showCommentPage : Bool
    @State var startDiscuss = ""
    @State var offset: CGFloat = 0
    @State var postSearch = ""
    @State private var searchText: String = ""
    @State private var searchDraftText: String = ""
    @State var draftText = ""
    @State var showNotiPopUp = false
    @State var replyPressed = false
    @State var ex: Bool = false
    @State var addEvent = false
    @State var refresh = Refresh(started: false, released: false)
    //MARK: AWS Data
    @State var posts: [Post] = []
    @State var drafts: [Draft] = []
    //let comment: Comment
    @State var tokens: Set<AnyCancellable> = []
    @State var draftTokens: Set<AnyCancellable> = []
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                VStack {

                    HStack(spacing: 15) {
                        
                            HStack(spacing: 0) {
                                Text("Club")
                                    .font(.custom("Roboto-Bold", size: 18))
                                    .foregroundColor(.black)
                                    .opacity(0.9)
                                Text("Hub")
                                    .font(.custom("Roboto-Regular", size: 18))
                                    .foregroundColor(.black)
                            }
                        
                        if current == "Activity" {
                        
                            HStack {
                                
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color("darkGray"))
                                    .font(.system(size: 14))
                                
                                TextField("Search Posts", text: $searchText)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(false)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("darkGray"))
                                
                                Spacer()
                                
                                if self.searchText != "" {
                                    
                                    Button {
                                        // cancel action
                                        self.searchText = ""
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))
                                            .padding(.trailing,12)
                                    }
                                    
                                } else {
                                    
                                    Button {
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.clear)
                                            .font(.system(size: 12))
                                            .padding(.trailing,12)
                                    }.disabled(true)
                                }
                                
                                
                            }.padding(.vertical,8)
                                .padding(.leading,10).background(
                                    Capsule()
                                        //.stroke(Color("back"), lineWidth: 1)
                                        .fill(Color("back").opacity(0.8))
                                )
                                .accentColor(.black)
                        } else {
                            HStack {
                                
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color("darkGray"))
                                    .font(.system(size: 14))
                                
                                TextField("Search Drafts", text: $searchDraftText)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(false)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("darkGray"))
                                
                                Spacer()
                                
                                if self.searchDraftText != "" {
                                    
                                    Button {
                                        // cancel action
                                        self.searchDraftText = ""
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.black)
                                            .font(.system(size: 12))
                                            .padding(.trailing,12)
                                    }
                                    
                                } else {
                                    
                                    Button {
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.clear)
                                            .font(.system(size: 12))
                                            .padding(.trailing,12)
                                    }.disabled(true)
                                }
                                
                                
                            }.padding(.vertical,8)
                                .padding(.leading,10).background(
                                    Capsule()
                                        //.stroke(Color("back"), lineWidth: 1)
                                        .fill(Color("back").opacity(0.8))
                                )
                                .accentColor(.black)
                        }
                        
                        Button {
                            self.showMenu.toggle()
                        } label: {
                            Image("menu2")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 22, height: 22)
                        }
                        
                    }.padding(.horizontal,15).padding(.bottom,5)
                        
                    HStack(spacing: 60) {
                        TransitionBar(current: $current, title: "Activity", animation: animation)
                        TransitionBar(current: $current, title: "Drafts", animation: animation)
                        }
                    }
                }.padding(.top,5)
                .background(Color.white)
            
            Divider()
            
            if current == "Activity" {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    //Geometry reader for calculating position
                    GeometryReader { reader -> AnyView in
                        
                        DispatchQueue.main.async {
                            if refresh.startOffset == 0{
                                refresh.startOffset = reader.frame(in: .global).minY
                            }
                            
                            refresh.offset = reader.frame(in: .global).minY
                            
                            if refresh.offset - refresh.startOffset > 80 && !refresh.started {
                                refresh.started = true
                            }
                            
                            // checking if refresh is started and drag is released
                            if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                                withAnimation(Animation.linear) {refresh.released = true}
                                updateData()
                            }
                            
                            //checking if invalid becomes valid...
                            if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                                refresh.invalid = false
                                updateData()
                            }
                        }
                        return AnyView(Color.black.frame(width: 0, height: 0))
                    }.frame(width: 0, height: 0)
                    
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                        if refresh.started && refresh.released {
                            ProgressView()
                                .offset(y: -35)
                        }else{
                            //Arrow and indicator...
                            Image("downArrow")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("darkGray"))
                                .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                                .offset(y: -25)
                                .animation(.easeIn)
                        }
                        
                        LazyVStack(spacing: 5){
                            if posts.isEmpty {
                                    Text("No posts yet")
                                        .font(.custom("Roboto-Regular", size: 16))
                                        .foregroundColor(.gray)
                                        .padding(.top,35)
                            } else {
                                ForEach(posts) { post in
                                    ReusablePost(post: post)
                                }
                            }
                        }
                            .padding(.bottom, 95)
                    }.offset(y: refresh.released ? 40 : -8)
                    
                }.ignoresSafeArea(edges: .vertical).scrollDismissesKeyboard(.immediately)
                    .onAppear {
                        observePosts()
                        Task { await fetchPostsWithComments() }
                    }
                    /*.refreshable {
                        Task { await queryPosts() }
                    }*/
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 5){
                        if drafts.isEmpty {
                            Text("No drafts yet")
                                .font(.custom("Roboto-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top,35)
                        } else {
                            ForEach(drafts) { draft in
                                ReusableDraftPost(draft: draft)
                            }
                        }
                    }
                        .padding(.bottom, 95)
                }.scrollDismissesKeyboard(.immediately)
                    .onAppear{
                        observeDrafts()
                    }
            }
        }
        .background(Color("back"))
        /*.overlay (
            ZStack(alignment: .top, content: {
                
                if showNotiPopUp{
                    Color.black.opacity(0.1)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showNotiPopUp.toggle()
                    }
                }
                .ignoresSafeArea()
                    Notipopup(showNotiPopUp: $showNotiPopUp)
                }
            })
        )*/
    }
    
    func updateData() {
        print("updated Data...")
        //disabling invalid scroll when data is already loading
        
        // Delaying for smooth animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(Animation.linear) {
                if refresh.startOffset == refresh.offset{
                    //TODO: Append new data here...
                    
                    refresh.released = false
                    refresh.started = false
                }else{
                    refresh.invalid = true
                }
            }
        }
    }
    
    //TODO: Query only the posts that have the same club as the user joined
    func observePosts(){
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: Post.self
                                                                //, where: Post.keys.clubCategory ==
                                                               )
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
              receiveValue: { posts in
            self.posts = posts.sorted {
                //guard
                let date1 = $0.publishedTime//,
                let date2 = $1.publishedTime
                //else {return false}
                // > (orig)
                return date1 > date2
                 }
            }
        )
        .store(in: &tokens)
    }
    
    func observeDrafts(){
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: Draft.self, where: Draft.keys.userID == userState.userId)
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
              receiveValue: { drafts in
            self.drafts = drafts.sorted {
                //guard
                let date1 = $0.savedTime//,
                let date2 = $1.savedTime
                //else {return false}
                // > (orig)
                return date1 > date2
                 }
            }
        )
        .store(in: &draftTokens)
    }
    
    func fetchPostsWithComments()async{
        do {
            let queriedPosts = try await Amplify.DataStore.query(Post.self, paginate: .page(0, limit: 10))
            //print("paginating....")
            for post in queriedPosts {
                let comments = try await Amplify.DataStore.query(Comment.self, where: Comment.keys.postID == post.id)
                for comment in comments {
                    print("Fetched comment successfully: \(comment)")
                }
            }
        }catch let error as DataStoreError{
            print("Failed to fetch posts and comments - \(error)")
        } catch {
            print(error)
        }
    }
}

// Refresh model
struct Refresh {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool
    var released: Bool
    var invalid: Bool = false
}
