//
//  ReusablePostsView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI
import Amplify
import Combine
import AmplifyImage
import LinkPresentation

struct ReusablePost: View {
    @EnvironmentObject var userState: UserState
    //MARK: View Properties
    @State var scrolled = false
    @State var searchPosts = ""
    @State var replyIsPressed = false
    @State var saved = false
    @State var liked = false
    @State var replyText = ""
    @State var viewAllComments = false
    @State var isShareSheetPresented = false
    @State var showSafari = false
    @State var replyComment = false
    @State var expandedDescription = false
    @State var writeAComment = ""
    //MARK: AWS Data
    var post: Post
    var posterAvatarKey: String {
        post.userID + ".jpg"
    }
    //@State var postPublisher: User
    @State var comments: [Comment] = []
    /*var publishedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: post.createdAt?.foundationDate ?? .now)
    }*/
    var publishedTime: String {
        let formatter = RelativeDateTimeFormatter()
        //let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
        formatter.dateTimeStyle = .named
        //return formatter.string(for: post.createdAt?.foundationDate ?? .now) ?? ""
        return formatter.string(for: post.publishedTime.foundationDate) ?? ""
    }
    @State var tokens: Set<AnyCancellable> = []
    //@Binding var commentPublisher: User
    var body: some View {
        
        VStack(spacing: 5) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(post.clubCategory)
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(Color("darkBlue"))
                    
                    HStack(spacing: 5) {
                        AmplifyImage(key: posterAvatarKey)
                            .kfImage
                            .placeholder {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray.opacity(0.9))
                                    .padding(10)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .background(
                                Circle()
                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            
                            HStack(spacing: 3) {
                                Text(post.firstName)
                                    .font(Font.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(.black)
                                Text(post.lastName)
                                    .font(Font.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(.black)
                                Text("@\(post.username)")
                                    .font(Font.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(Color("darkGray"))
                            
                                
                                Spacer()
                                
                                if userState.userId == post.userID{
                                Menu {
                                    // save data when post view pops up with "Edit Post" instead of "New Post"
                                    Button(action: {}) {
                                        Label("Edit", systemImage: "pencil")
                                            .foregroundColor(.red)
                                    }
                                    Button(action: {
                                        Task { await deletePost() }
                                        
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color("darkGray"))
                                    }
                                    
                                }
                            }
                            
                            HStack(spacing: 3) {
                                Text(publishedTime)
                                    .font(Font.custom("Roboto-Regular", size: 12))
                                    .foregroundColor(Color("darkGray"))
                                    /*.onReceive(timer) { (_) in
                                        self.publishedTime
                                    }*/
                            }.frame(alignment: .leading)
                            
                        }.padding(.leading,5)
                        
                        Spacer()
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text(post.title)
                            .font(Font.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                            .padding(.top,10)
                            .padding(.bottom,5)
                        
                        if post.bodyText != "" {
                            Text(post.bodyText ?? "")
                                .lineLimit(expandedDescription ? nil : 6)
                                .lineSpacing(5)
                                .font(Font.custom("Roboto-Regular", size: 14))
                                .foregroundColor(.black)
                                .padding(.bottom,5)
                                .fixedSize(horizontal: false, vertical: true)
                                .textSelection(.enabled)
                        }
                        
                        
                        if post.link != "" {
                            Button {
                                showSafari = true
                            } label: {
                                Text(post.link ?? "")
                                    .font(.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(.blue)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .lineLimit(1)
                                    .padding(.bottom,5)
                            }.popover(isPresented: $showSafari) {
                                SafariViewWrapper(url: URL(string: post.link ?? "")!)
                            }
                        }
                        
                        /*VStack(spacing: 5) {
                            HStack(spacing: 10) {
                                Image("figmaLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(3)
                                    .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white)
                                    )
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("DesignFile.figma")
                                        .font(Font.custom("Roboto-Regular", size: 14))
                                        .foregroundColor(.black)
                                    Text("5MB")
                                        .font(Font.custom("Roboto-Regular", size: 12))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                Image("downloadFile")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.gray)
                                    .padding(3)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                
                            }.padding(5).background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color("back")))
                        }
                            .padding(.bottom,5)*/
                        
                        //MARK: For Updates
                        /*if post.imageKey != ""{
                            AmplifyImage(key: post.imageKey ?? "")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .padding(.bottom,5)
                                .padding(.top,10)
                        } else {
                            AmplifyImage(key: post.imageKey ?? "")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .padding(.bottom,5)
                                .padding(.top,10)
                                .hidden()
                        }*/
                    }
                    
                    HStack(spacing: 20) {
                        
                        HStack(spacing: 5) {
                            
                            Button {
                                //withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                                    self.liked.toggle()
                                //}
                                Task { await likePost(liked: liked) }
                            }  label: {
                                Image(systemName: post.liked ? "suit.heart.fill" : "suit.heart")
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                        .foregroundColor(post.liked ? Color("red"): Color("darkGray"))
                            }/*.overlay {
                                LottieView(lottieFile: "like")
                                    .frame(width: 50, height: 50)
                            }*/
                                        
                            
                            Text("\(post.likes)")
                                .font(Font.custom("Roboto-Medium", size: 12))
                                .foregroundColor(post.liked ? .black : Color("darkGray"))
                            
                        }
                        
                        HStack(spacing: 5) {
                            
                            Button {
                                    self.replyIsPressed.toggle()
                            } label: {
                                Image("comments")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("darkGray"))
                            }.sheet(isPresented: $replyIsPressed) {
                                
                                VStack(spacing: 0) {
                                    VStack(spacing: 10) {
                                    Text("Comments")
                                        .font(.custom("Roboto-Bold", size: 18))
                                        .foregroundColor(.black)
                                    Divider()
                                }
                                    // Comments
                                    ScrollView(.vertical, showsIndicators: true) {
                                        
                                        LazyVStack(spacing: 20) {
                                            if comments.isEmpty {
                                                VStack(spacing: 5) {
                                                    Text("No comments")
                                                        .font(.custom("Roboto-Regular", size: 14))
                                                        .foregroundColor(Color("darkGray"))
                                                    
                                                    Text("Start a discussion.")
                                                        .font(.custom("Roboto-Medium", size: 14))
                                                        .foregroundColor(.black)
                                                        
                                                }.padding(.top,35)
                                            } else {
                                                ForEach(comments) { comment in
                                                    SampleComments(viewAllComments: $viewAllComments, comment: comment)
                                                }
                                            }
                                        }.padding(.horizontal,10).padding(.top,10)
                                    
                                    }
                                        HStack(spacing: 10) {
                                            
                                            Circle()
                                                .strokeBorder(.gray.opacity(0.5), lineWidth: 0.5)
                                                .frame(width: 25, height: 25)
                                                .background(
                                                    AmplifyImage(key: userState.userAvatarKey)
                                                    .resizable().aspectRatio(contentMode: .fill).clipShape(Circle()))
                                                .frame(width: 30, height: 30)
                                            
                                            HStack {
                                                TextField("What's happening?", text: $writeAComment)
                                                    .font(Font.custom("Roboto-Regular", size: 14))
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                Button {
                                                    Task { await createComment() }
                                                } label: {
                                                    Text("Send")
                                                        .font(Font.custom("Roboto-Regular", size: 14))
                                                        .foregroundColor(writeAComment.isEmpty ? .blue.opacity(0.5) : .blue)
                                                }.disabled(writeAComment.isEmpty)
                                            }
                                                .padding(.vertical,8).padding(.horizontal,10).background(
                                                    Capsule()
                                                        .stroke(Color("back"), lineWidth: 1)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                )
                                            
                                        }.frame(maxHeight: .infinity, alignment: .bottom).padding(.horizontal,10).padding(.bottom,10)
                                    
                                }.padding(.top,25).presentationDetents([.fraction(0.65)]).presentationDragIndicator(.visible).onAppear(perform: observeComments)
                            }
                            
                            //MARK: Be careful with the force wrap. change if any errors occur
                            Text("\(comments.count)")
                                .font(Font.custom("Roboto-Regular", size: 12))
                                .foregroundColor(Color("darkGray"))
                        }
                        
                        Spacer()
                        
                        Button {
                            self.isShareSheetPresented.toggle()
                        } label: {
                            Image("share")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("darkGray"))
                        }.sheet(isPresented: $isShareSheetPresented) {
                            ShareSheetView(activityItems: ["Check this post out!"])
                        }
                        
                        Button {
                            self.saved.toggle()
                            Task { await updateSavedStatus(saved: saved) }
                        } label: {
                            Image(post.saved ? "bookmarkFilled" : "bookmarkOutlined")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 18, height: 18)
                                .foregroundColor(post.saved ? .black : Color("darkGray"))
                        }
                    }
                }
            }
        }.frame(maxWidth: .infinity)
            .padding(15)
            .background(
                Rectangle()
                    .fill(.white)
            )
        
        //}.scrollDismissesKeyboard(.immediately).padding(.horizontal,10)
    }
    
    /*func observePostPublisher()async{
        do {
            guard let queriedPostPublisher = try await Amplify.DataStore.query(User.self, byId: post.userID) else {return}
            self.postPublisher = queriedPostPublisher
        } catch let error as DataStoreError {
            print("Failed to query \(error)")
        } catch let error as CoreError {
            print("Failed to fetch \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }*/
    
    func likePost(liked: Bool)async{
        var post = post
        if liked{
            post.liked = true
            post.likes += 1
        }else{
            post.liked = false
            post.likes -= 1
        }
        do{
            let updatedPost = try await Amplify.DataStore.save(post)
            print("Updated post successfully: \(updatedPost)")
        }catch let error as DataStoreError{
            print("Failed to like/unlike post: \(error)")
        } catch{
            print("Unexpected error \(error)")
        }
    }
    
    func updateSavedStatus(saved: Bool)async{
        var post = post
        post.saved = saved
        do {
            let updatedPost = try await Amplify.DataStore.save(post)
            print("Updated post successfully: \(updatedPost)")
        }catch let error as DataStoreError{
            print("Failed to update post: \(error)")
        }catch{
            print("Unexpected error \(error)")
        }
    }
    
    func createComment()async{
        let commentId = UUID().uuidString
                do {
                    let newComment = Comment(id: commentId, text: writeAComment, likes: 0, postID: post.id, publishedTime: .now(), liked: false, userID: userState.userId, firstName: userState.firstName, lastName: userState.lastName, username: userState.username)
                    let savedComment = try await Amplify.DataStore.save(newComment)
                            print("Saved comment: \(savedComment)")
                    writeAComment = ""
                }catch{
                    print(error)
                }
    }
    
    func deletePost()async{
        do{
            //Deleting a post should delete all the comments associated with it?
            try await Amplify.DataStore.delete(post)
            print("Deleted post \(post.id)")
            
            //let postImageKey = post.id + ".jpg"
            //try await Amplify.Storage.remove(key: postImageKey)
            //print("Deleted image: \(postImageKey)")
        }catch{
            print(error)
        }
    }
    
    func observeComments(){
        Amplify.Publisher.create(Amplify.DataStore.observeQuery(for: Comment.self, where: Comment.keys.postID == post.id)
        )
        .map(\.items)
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { print($0) },
              receiveValue: { comments in
            self.comments = comments.sorted {
                //guard
                    let date1 = $0.publishedTime//,
                let date2 = $1.publishedTime
                //else {return false}
                return date1 > date2
                 }
            }
        )
        .store(in: &tokens)
    }
}

struct SampleComments: View {
    @State var replyHeartPressed = false
    @Binding var viewAllComments: Bool
    //MARK: AWS Data
    @EnvironmentObject var userState: UserState
    let comment: Comment
    var timeStamp: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.string(for: comment.publishedTime.foundationDate) ?? ""
    }
    //@State var commentPublisher: User
    var commenterProfileKey: String {
        comment.userID + ".jpg"
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top, spacing: 10) {
                /*AvatarView(state: .remote(avatarKey: commenterProfileKey))
                    .frame(width: 30, height: 30)*/
                Circle()
                    .strokeBorder(.gray.opacity(0.5), lineWidth: 0.5)
                    .frame(width: 25, height: 25)
                    .background(
                        AmplifyImage(key: commenterProfileKey)
                        .resizable().aspectRatio(contentMode: .fill).clipShape(Circle()))
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading, spacing: 5) {
                    Group {
                        Text(comment.firstName)
                            .font(Font.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" \(comment.lastName)")
                            .font(Font.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" @\(comment.username)")
                            .font(Font.custom("Roboto-Regular", size: 14))
                            .foregroundColor(Color("darkGray"))
                    }.font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                    Text(comment.text)
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 10) {
                        
                        HStack(spacing: 5) {
                            Button {
                                self.replyHeartPressed.toggle()
                                Task { await likeComment(liked: replyHeartPressed) }
                            } label: {
                                Image(systemName: comment.liked ? "suit.heart.fill" : "suit.heart")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundColor(comment.liked ? Color("red") : Color("darkGray"))
                            }
                            
                            Text("\(comment.likes)")
                                .font(Font.custom("Roboto-Medium", size: 12))
                                .foregroundColor(comment.liked ? .black : Color("darkGray"))
                        }
                        
                        /*Button {
                            //self.replyComment.toggle()
                        } label: {
                            Text("Reply")
                                .font(Font.custom("Roboto-Medium", size: 12))
                                .foregroundColor(Color("darkGray"))
                        }.sheet(isPresented: $replyComment) {
                            CommentForm(replyComment: $replyComment)
                        }*/
                    }
                }
                
                Spacer()
                
                Text(timeStamp)
                    .font(Font.custom("Roboto-Regular", size: 12))
                    .foregroundColor(Color("darkGray"))
            }
        }/*.onAppear{ Task {
            await observePublisher()
        }}*/
        
        /*if viewAllComments == true {
            //TODO: Query the rest of the posts here
            EmptyView()
        }*/
    }
    
    func likeComment(liked: Bool)async{
        var comment = comment
        if liked{
            comment.liked = true
            comment.likes += 1
        }else{
            comment.liked = false
            comment.likes -= 1
        }
        do{
            let updatedComment = try await Amplify.DataStore.save(comment)
            print("Updated comment successfully: \(updatedComment)")
        }catch let error as DataStoreError{
            print("Failed to like/unlike post: \(error)")
        } catch{
            print("Unexpected error \(error)")
        }
    }
    
    /*func observePublisher() async {
        do {
            guard let queriedPublisher = try await Amplify.DataStore.query(User.self, byId: comment.userId) else {
                return
            }
            self.commentPublisher = queriedPublisher
        } catch let error as DataStoreError {
            print("Failed to query \(error)")
        } catch let error as CoreError {
            print("Failed to fetch \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }*/
}

/*struct CommentForm: View {
    @State var commentText = ""
    @Binding var replyComment: Bool
    @Binding var replyIsPressed: Bool
    //MARK: AWSData
    @EnvironmentObject var userState: UserState
    let post: Post
    var body: some View {
        
        VStack {
            VStack(alignment: .leading//, spacing: 8
            ) {
                /*Text("Commenting to")
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.gray)*/
                
                /*HStack(spacing: 15) {
                    Image("p2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 0) {
                        Text("JJ Duncan")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                        Text("Member")
                            .font(.custom("Roboto-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }.padding(.horizontal,15).padding(.vertical,10).background(RoundedRectangle(cornerRadius: 10).fill(Color("back"))).padding(.bottom,10)*/
                
                TextField("Write a comment", text: $commentText, axis: .vertical)
                    .font(.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.black)
                    .foregroundColor(.black)
                    .lineLimit(4)
                    .lineSpacing(5)
                    .padding(.top,10)
                    .scrollDismissesKeyboard(.immediately)
            }
            
            Spacer()
            
            VStack(spacing: 10) {
                
                if commentText == "" {
                        Text("Add comment")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.white)
                            .padding(.vertical,10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Capsule().fill(.black))
                            .padding(.bottom,5)
                            .opacity(0.6)
                } else {
                    Button {
                        Task { await createComment() }
                    } label: {
                        Text("Add comment")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.white)
                            .padding(.vertical,10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Capsule().fill(.black))
                            .padding(.bottom,5)
                    }
                }
                
                /*Button {
                 self.replyComment.toggle()
                 } label: {
                 Text("Cancel")
                 .font(.custom("Roboto-Medium", size: 14))
                 .foregroundColor(.gray)
                 .padding(.vertical,10)
                 .frame(maxWidth: .infinity, alignment: .center)
                 .background(Capsule().stroke(Color("back"), lineWidth: 1.5))
                 }*/
                
            }.padding(.bottom,-15)
            
        }.padding(15).background(RoundedRectangle(cornerRadius: 20).fill(.white)).presentationDetents([.height(250)]).presentationDragIndicator(.hidden)
    }
    

    
}*/

struct ShareSheetView: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
