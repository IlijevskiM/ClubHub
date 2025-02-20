//
//  MessagesScreen.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct MessagesView: View {
    @State var newConvo = false
    @State var personLookUp = ""
    var body: some View {
        
        VStack {
            
            VStack(spacing: 20) {
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            
                            Text("Messages")
                                .font(.custom("Roboto-Medium", size: 20))
                                .foregroundColor(.black)
                            
                            Spacer()
                                
                                Button {
                                    self.newConvo.toggle()
                                } label: {
                                    Image("newConvo")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.black)
                                        .frame(width: 22, height: 22)
                                }.sheet(isPresented: $newConvo) {
                                    
                                    VStack(spacing: 10) {
                                        HStack(alignment: .center) {
                                            Text("New Message")
                                                .font(Font.custom("Roboto-Medium", size: 18))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Button {
                                                self.newConvo.toggle()
                                            } label: {
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 15))
                                            }
                                        }
                                        HStack(spacing: 10) {
                                            Text("To:")
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(.gray)
                                            TextField("", text: $personLookUp)
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            Image(systemName: "plus")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color("darkBlue"))
                                                .padding(3)
                                                .background(Circle().stroke(Color("darkBlue"), lineWidth: 1.5))
                                        }.padding(.top,15)
                                        Divider()
                                        
                                        Spacer()
                                    }.padding(.horizontal,15).padding(.top,20)
                                }
                            
                        }
                    }
                }.padding(.top,10)
                
                SearchBar()
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Pinned")
                        .font(.custom("Roboto-Medium", size: 16))
                        .foregroundColor(.black)
                    HStack(spacing: 15) {
                        Image("p1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        Image("p2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        Image("p3")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        Image("0")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                }.padding(.bottom,10).frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        
                        Message()
                        
                    }
                    
                }.padding(.bottom,10)
            }.padding(.horizontal,15)
            .background(.white)
        }
    }
}

struct SearchBar: View {
    
    @State var text = ""
    
    var body: some View {
            
            HStack {
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                
                TextField("Search people", text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    .font(.system(size: 14))
                
                Spacer()
                
                if self.text != "" {
                    
                    Button {
                        // cancel action
                        self.text = ""
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
                    //RoundedRectangle(cornerRadius: 10)
                    Capsule()
                        .fill(Color("back"))
                )
                .accentColor(.black)
        

    }
}

struct Message: View {
    @State var messageIsPressed = false
    var body: some View {
        
        HStack(alignment: .top, spacing: 15) {
            Image("ang")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45, alignment: .topLeading)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Angelina Ilijevski")
                    .font(Font.custom("Roboto-Medium", size: 16))
                    .foregroundColor(.black)
                
                HStack {
                    Text("Heyo you are awesome bubs!!!")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
            
            /*Text("4")
                .font(.custom("Roboto-Medium", size: 14))
                .foregroundColor(.white)
                .padding(5)
                .background(Circle().fill(Color("darkBlue")))
                .frame(alignment: .bottomTrailing)*/
            
            Text("4:55pm")
                .font(Font.custom("Roboto-Regular", size: 12))
                .foregroundColor(.gray)
                .frame(alignment: .topTrailing)
        }.padding(.bottom,8)
        
            ForEach(sampleData) { data in
                Button {
                    self.messageIsPressed.toggle()
                } label: {
                    VStack(spacing: 20) {
                        HStack(alignment: .top, spacing: 15) {
                            Image(data.profile)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 45, alignment: .topLeading)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(data.name)
                                    .font(Font.custom("Roboto-Medium", size: 16))
                                    .foregroundColor(.black)
                                
                                Text(data.message)
                                    .font(Font.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                
                            }
                            
                            Spacer()
                            
                            Text(data.time)
                                .font(Font.custom("Roboto-Regular", size: 12))
                                .foregroundColor(.gray)
                                .frame(alignment: .topTrailing)
                        }.padding(.vertical,5)
                    }.padding(.vertical,8)
                }.fullScreenCover(isPresented: $messageIsPressed) {
                    ChatScreen().padding(.bottom,10)
                }
            }
    }
}

struct ChatScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State var chatMembersPressed = false
    var body: some View {
        
        //ScrollView(.vertical, showsIndicators: false) {
            //ForEach(sampleData) { data in
                VStack {
                    
                        HStack(spacing: 15) {
                            
                            HStack(spacing: 20) {
                                Image("p3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30, alignment: .topLeading)
                                    .clipShape(Circle())
                                
                                    Text("Andy Jassy")
                                        .font(Font.custom("Roboto-Medium", size: 15))
                                        .foregroundColor(.black)
                                
                                Spacer()
                                
                                /*Image("ideas")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.gray)*/
                                
                                Button {
                                    self.chatMembersPressed.toggle()
                                } label: {
                                    Image("users")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.gray)
                                }.sheet(isPresented: $chatMembersPressed) {
                                    membersOfChat()
                                }
                                
                                Button(role: .destructive) {
                                    dismiss()
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.black)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))
                                }
                                
                            }
                            
                        }.padding(.top,10).padding(.horizontal,20).background(Color.white)
                        
                        Divider()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        //MARK: Chat Section
                        
                        Sender().frame(maxWidth: .infinity, alignment: .leading)
                        
                        Receiver().frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Text("Today")
                            .font(Font.custom("Roboto-Regular", size: 14))
                            .foregroundColor(Color("darkGray"))
                            .padding(.vertical,5)
                        
                        /*HStack(spacing: 5) {
                            Rectangle().foregroundColor(Color("back")).frame(width: 150, height: 1)
                            
                            Text("Today")
                                .font(Font.custom("Roboto-Medium", size: 14))
                                .foregroundColor(Color("darkGray"))
                                .padding(8)
                                .padding(.horizontal,10)
                                .background(Capsule().stroke(Color("back"), lineWidth: 1))
                            
                            Rectangle().foregroundColor(Color("back")).frame(width: 150, height: 1)
                        }.padding(.vertical,20)*/
                        
                        Sender().frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        /*HStack(spacing: 15) {
                            TypingIndicator()
                            Text("Andy Jassy")
                                .font(Font.custom("Roboto-Medium", size: 14))
                                .foregroundColor(.gray)
                            +
                            Text(" is typing")
                                .font(Font.custom("Roboto-Medium", size: 14))
                                .foregroundColor(.gray)
                        }.frame(alignment: .bottomLeading)*/
                        
                    }.padding(.top,10).padding(.horizontal,20)
                    
                    Divider()
                    
                    TypingField().frame(alignment: .bottom).padding(.horizontal,15).padding(.bottom,-10)
                    
                }
            //}
        //}
    }
}

struct Sender: View {
    var body: some View {
        //ForEach(sampleData) { data in
        HStack(alignment: .top, spacing: 10) {
                Image("p3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack(spacing: 10) {
                        Text("Andy Jassy")
                            .font(Font.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                        
                        Text("4 hr ago")
                            .font(Font.custom("Roboto-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Text("Stay informed about the latest technological breakthroughs and the ethical and societal norms they challenge.")
                        .font(Font.custom("Roboto-Regular", size: 14))
                        .foregroundColor(Color("darkGray"))
                        .lineSpacing(6)
                        .padding(12)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("back"))
                        )
                    
                    //MARK: Message Reactions
                    /*HStack(spacing: 5) {
                        
                        /*Image("👍")
                            .font(.system(size: 20))
                            .padding(8)
                            .background(Capsule().fill(Color("chatColor")))*/
                        
                        Image("react")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 18, height: 18)
                            .foregroundColor(.gray)
                    }*/
                    
                }
            }
        //}
    }
}

struct Receiver: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            
            VStack(alignment: .trailing, spacing: 8) {
                
                HStack(alignment: .top, spacing: 10) {
                    
                    Text("4 min ago")
                        .font(Font.custom("Roboto-Regular", size: 12))
                        .foregroundColor(.gray)
                    
                    Text("Melanija Ilijevski")
                        .font(Font.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.black)
                }
                
                Text("Sounds great! Thank you.")
                    .font(Font.custom("Roboto-Medium", size: 14))
                    .foregroundColor(.white)
                    .lineSpacing(6)
                    .padding(12)
                    .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("chatColor"))
                    )
                
                //MARK: Message Reactions
                /*HStack(spacing: 5) {
                    
                    /*Image("😁")
                        .font(.system(size: 20))
                        .padding(8)
                        .background(Capsule().fill(Color("back")))*/
                    
                    Image("react")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                }*/
                
            }
            
            Image("p1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25)
                .clipShape(Circle())
        }//.padding(.top,15)
    }
}

struct TypingField: View {
    @State var typeMessage = ""
    @State var activateReferencing = false
    @State var referencingString = ""
    @State var referenceCompletion = false
    @State var sendMessage = false
    var body: some View {
        
        /*VStack(alignment: .leading) {
            if activateReferencing == true {
                //if referencingString != "" {
                    VStack(alignment: .leading, spacing: 3) {
                        UserReferencingPopUp()
                        HStack(spacing: 0) {
                            Text("@")
                                .font(Font.custom("Roboto-Medium", size: 14))
                                .foregroundColor(.black)
                            TextField("", text: $referencingString)
                                .font(Font.custom("Roboto-Medium", size: 14))
                                .foregroundColor(.black)
                        }.padding(3).background(RoundedRectangle(cornerRadius: 5).fill(Color("darkBlue")).opacity(0.1))
                    }
                //}
            } else {
                TextField("Write a message", text: $typeMessage, axis: .vertical)
                    .font(Font.custom("Roboto-Regular", size: 14))
                    .foregroundColor(.black)
                    //.padding(.vertical,15)
                    .lineSpacing(6)
                    .lineLimit(3)
            }
            
            HStack(spacing: 20) {
                
                Button {
                    self.activateReferencing.toggle()
                } label: {
                    Image("atSign")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
                
                Image("imagePicker")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                Image("emoji")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                /*Image("dots")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)*/
                
                Spacer()
                
                Button {
                    typeMessage = ""
                } label: {
                    Image("send")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 18)
                        .foregroundColor(typeMessage == "" ? Color.gray : Color("chatColor"))
                        
                }
            }
            
        }*/
        
        HStack(spacing: 10) {
            TextField("Write a message", text: $typeMessage, axis: .vertical)
                .font(.custom("Roboto-Regular", size: 14))
                .foregroundColor(.black)
                .padding(5).padding(.horizontal,10).padding(.vertical,5).background(RoundedRectangle(cornerRadius: 10).fill(Color("back")))
            
            Button {
                self.sendMessage.toggle()
            } label: {
                Image("send")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundColor(typeMessage != "" ? Color("darkBlue") : .gray)
            }
        }
    }
}

struct UserReferencingPopUp: View {
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10) {
                Image("p3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 0) {
                    Text("Bobby Right")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.black)
                    Text("Member")
                        .font(.custom("Roboto-Regular", size: 12))
                        .foregroundColor(.gray)
                }
            }
            HStack(alignment: .top, spacing: 10) {
                Image("p2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 0) {
                    Text("James Hunt")
                        .font(.custom("Roboto-Medium", size: 14))
                        .foregroundColor(.black)
                    Text("Member")
                        .font(.custom("Roboto-Regular", size: 12))
                        .foregroundColor(.gray)
                }
            }
        }.padding(10).padding(.horizontal,5).background(RoundedRectangle(cornerRadius: 10).stroke(Color("back"), lineWidth: 1.5))
        
    }
}

struct ReactionsSpringsWithParameters: View {
    // 1. Define initial animation state
    @State private var showReaction = false
    var body: some View {
        
            ZStack { // 1. Reactions background: .interpolatingSpring(stiffness: 170, damping: 15)
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 216, height: 40)
                    .foregroundColor(Color("back"))
                    .scaleEffect(CGFloat(showReaction ? 1 : 0), anchor: .topTrailing)
                    .animation(.interpolatingSpring(stiffness: 170, damping: 15).delay(0.05), value: showReaction)
                
                // 2. Heart icon: .interpolatingSpring(mass: Double = 1.0, stiffness: Double, damping: Double, initialVelocity: Double = 0.0)
                HStack(spacing: 20) {
                    Image("heart")
                        .offset(x: showReaction ? 0 : 2)
                        .scaleEffect(showReaction ? 1 : 0, anchor: .bottomLeading)
                        .animation(.interpolatingSpring(mass: 2, stiffness: 170, damping: 10, initialVelocity: 10).delay(0.1), value: showReaction)
                    
                    // 3. .spring(response: Double = 0.55, dampingFraction: Double = 0.825, blendDuration: Double = 0)
                    Image("thumbup")
                        .offset(x: showReaction ? 0 : -15)
                        .scaleEffect(showReaction ? 1 : 0, anchor: .bottom)
                        .rotationEffect(.degrees(showReaction ? 0 : -45))
                        .animation(.spring(response: 0.55, dampingFraction: 0.825/3, blendDuration: 0).delay(0.2), value: showReaction)
                    
                    // 4. .interactiveSpring(response: Double = 0.15, dampingFraction: Double = 0.86, blendDuration: Double = 0.25)
                    Image("thumbdown")
                        .scaleEffect(showReaction ? 1 : 0, anchor: .topTrailing)
                        .rotationEffect(.degrees(showReaction ? 0 : 45))
                        .animation(.interactiveSpring(response: 0.15*4, dampingFraction: 0.86/3, blendDuration: 0).delay(0.3), value: showReaction)
                    
                    Image("crying")
                        .scaleEffect(showReaction ? 1 : 0, anchor: .bottom)
                        .animation(.interpolatingSpring(stiffness: 170, damping: 8).delay(0.4), value: showReaction)
                    
                    Image("sad")
                        .offset(x: showReaction ? 0 : 15)
                        .scaleEffect(showReaction ? 1 : 0, anchor: .bottomTrailing)
                        .animation(.interpolatingSpring(stiffness: 170, damping: 8).delay(0.5), value: showReaction)
                    
                }
                
            } // All reaction views
            .onAppear{
                showReaction.toggle()
            }
    }
}

struct SampleMessageData: Identifiable {
    var id = UUID().uuidString
    var profile: String
    var name: String
    var message: String
    var time: String
    var timePassed: String
}

var sampleData = [
    SampleMessageData(profile: "p1", name: "Andy Jassy", message: "I think that would be best", time: "2:34pm", timePassed: "5 hr ago"),
    SampleMessageData(profile: "p2", name: "Jackie Chan", message: "Yeah, just let me know", time: "1:22pm", timePassed: "25 min ago"),
    SampleMessageData(profile: "p3", name: "Ava Myer", message: "Youre so funny hahaha", time: "11:45am", timePassed: "42 days ago"),
    SampleMessageData(profile: "p1", name: "Art Division", message: "You know I really think that we should plan on getting a sponsor for this because I think it would really impress the board heads if we coordinated this. Does anyone disagree?", time: "10:13am", timePassed: "1 hr ago"),
    SampleMessageData(profile: "p2", name: "Ken Reign", message: "Yep. Done!", time: "5:37pm", timePassed: "5 min ago"),
    SampleMessageData(profile: "p3", name: "Coordinating Division", message: "If all else fails we can resort to plan B.", time: "6:56pm", timePassed: "2 min ago"),
    SampleMessageData(profile: "p1", name: "Technical Division", message: "We did it! Great job team!", time: "4:23pm", timePassed: "7 hr ago"),
    SampleMessageData(profile: "p2", name: "Randy Yan", message: "Sounds good.", time: "1:56pm", timePassed: "12 min ago"),
    SampleMessageData(profile: "p3", name: "Kelvin Joiner", message: "Laughing so hard rn", time: "12:10pm", timePassed: "6 min ago"),
]

struct chatMembers: Identifiable {
    var id = UUID().uuidString
    var profile: String
    var name: String
    var email: String
}

var chatMember = [
chatMembers(profile: "p2", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p3", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p1", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p2", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p3", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p1", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p2", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p3", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p1", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p2", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p3", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p1", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
chatMembers(profile: "p2", name: "Melanija Ilijevski", email: "melanijaI@umich.edu"),
]

struct membersOfChat: View {
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Chat Members")
                    .font(.custom("Roboto-Medium", size: 20))
                    .foregroundColor(.black)
                    .padding(.horizontal,15)
                
                Divider()
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(chatMember) { member in
                        HStack(spacing: 15) {
                            Image(member.profile)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 35, height: 35)
                                .overlay {
                                    Image(systemName: "clock.badge.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.yellow)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(member.name)
                                    .font(.custom("Roboto-Medium", size: 14))
                                    .foregroundColor(.black)
                                Text(member.email)
                                    .font(.custom("Roboto-Regular", size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image("chat")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 18, height: 18)
                                .foregroundColor(.black)
                        }
                    }
                }.padding(.horizontal,15)
                
            }.padding(.vertical,25)
        }
    }
}

struct TypingIndicator: View {
    @State private var numberOfTheAnimationgBall = 3
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ForEach(0..<3) { i in
                Capsule()
                    .foregroundColor(.gray.opacity(0.6))
                    .frame(width: self.ballSize, height: (self.numberOfTheAnimationgBall == i) ? self.ballSize/3 : self.ballSize)
            }
        }
        //.animation(Animation.spring(response: 0.9, dampingFraction: 0.2, blendDuration: 0.7).speed(1))
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: self.speed, repeats: true) { _ in
                var randomNumb: Int
                repeat {
                    randomNumb = Int.random(in: 0...2)
                } while randomNumb == self.numberOfTheAnimationgBall
                self.numberOfTheAnimationgBall = randomNumb
            }
        }
    }
    
    // MAKR: - Drawing Constants
    let ballSize: CGFloat = 5
    let speed: Double = 0.1
}

