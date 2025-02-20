//
//  NotificationsScreen.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct NotificationView: View {
    
    @State var currentButton = "All"
    @Namespace var animation
    //@State var currentSelection = "All"
    @Environment(\.dismiss) var dismissNoti
    @State var refresh = RefreshNotis(started: false, released: false)
    var body: some View {
        
        VStack(spacing: 0) {
                    HStack {
                        
                        Spacer()
                        
                        Text("Notifications")
                            .font(.custom("Roboto-Bold", size: 18))
                            .foregroundColor(.black)
                            .padding(.trailing,-35)
                        
                        Spacer()
                            
                            Button {
                            } label: {
                                Image(systemName: "gearshape")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                        
                    }.padding(.horizontal,15).padding(.top,10).padding(.bottom,10).background(Color.white)
            
            Divider()
            
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
                    
                    NotiInfo()
                    
                }.offset(y: refresh.released ? 40 : -8)
                
            }//.padding(.top,5).padding(.bottom,15)
                .background(Color("back"))
            
        }
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
}


struct NotiInfo: View {
    
    var body : some View {
        //MARK: Person leaving club is also one, but not shown here
                
        LazyVStack(spacing: 5) {
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Turn on push notifications")
                        .font(.custom("Roboto-Medium", size: 16))
                        .foregroundColor(.black)
                    
                    Text("Find out about the latest updates.")
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(Color("darkGray"))
                    
                }.padding(.vertical,5).padding(.horizontal,10)
                Spacer()
                
                Text("Get notifications")
                    .font(.custom("Roboto-Medium", size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal,15)
                    .padding(.vertical,10)
                    .background(Capsule().fill(.black))
                    .padding(.top,10)
                
            }.frame(maxWidth: .infinity)
                .padding(15)
            //.padding(.vertical,10)
                .background(
                    Rectangle()
                        .fill(.white)
                )
            
            // waitlist noti
            HStack {
                HStack(spacing: 10) {
                    Image("offWaitlist")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 25, height: 25, alignment: .topLeading)
                        .foregroundColor(.blue)
                    Group {
                        Text("You were taken off the waitlist for")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" Teacher Appreciation Letters")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" and are now on the roster.")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                }.padding(.horizontal,10).padding(.vertical,5)
                Spacer()
                Image(systemName: "xmark")
                    .font(.system(size: 15))
                    .foregroundColor(Color("darkGray"))
                    .frame(alignment: .topTrailing)
            }.frame(maxWidth: .infinity)
                .padding(15)
                .background(
                    Rectangle()
                        .fill(.white)
                )
            
            //new member noti
            HStack {
                HStack(spacing: 10) {
                    Image("p3")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .background(
                            Circle()
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                        )
                    Group {
                        Text("Markie Malik")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" joined")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" Culinary")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(Color("darkBlue"))
                        +
                        Text(".")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                }.padding(.horizontal,10).padding(.vertical, 5)
                Spacer()
                Image(systemName: "xmark")
                    .font(.system(size: 15))
                    .foregroundColor(Color("darkGray"))
                    .frame(alignment: .topTrailing)
            }.frame(maxWidth: .infinity)
                .padding(15)
                .background(
                    Rectangle()
                        .fill(.white)
                )
            
            // new event noti
            HStack {
                HStack(spacing: 10) {
                    Image("newEvent")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 25, height: 25, alignment: .topLeading)
                        .foregroundColor(.blue)
                    
                    Group {
                        Text("Care Packages")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" was added to")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" Care")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(Color("darkBlue"))
                        +
                        Text(".")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                    
                }.padding(.horizontal,10).padding(.vertical, 5)
                Spacer()
                Image(systemName: "xmark")
                    .font(.system(size: 15))
                    .foregroundColor(Color("darkGray"))
                    .frame(alignment: .topTrailing)
            }.frame(maxWidth: .infinity)
                .padding(15)
                .background(
                    Rectangle()
                        .fill(.white)
                )
            
            // almost full noti
            HStack {
                HStack(spacing: 10) {
                    Image("almostFull")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 25, height: 25, alignment: .topLeading)
                        .foregroundColor(.red)
                    
                    Group {
                        Text("Movie Night")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" is almost full.")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" Join before it's too late.")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                    
                }.padding(.horizontal,10).padding(.vertical, 5)
                Spacer()
                Image(systemName: "xmark")
                    .font(.system(size: 15))
                    .foregroundColor(Color("darkGray"))
                    .frame(alignment: .topTrailing)
            }.frame(maxWidth: .infinity)
                .padding(15)
                .background(
                    Rectangle()
                        .fill(.white)
                )
            
            // comment on your post noti
            HStack {
                HStack(spacing: 10) {
                    Image("p1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .background(
                            Circle()
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                        )
                    Group {
                        Text("Carol Ambers")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.black)
                        +
                        Text(" commented on your post.")
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                    }
                    
                }.padding(.horizontal,10).padding(.vertical, 5)
                Spacer()
                Image(systemName: "xmark")
                    .font(.system(size: 15))
                    .foregroundColor(Color("darkGray"))
                    .frame(alignment: .topTrailing)
            }.frame(maxWidth: .infinity)
                .padding(15)
                .background(
                    Rectangle()
                        .fill(.white)
                )
            
        }.padding(.bottom, 60)
    }
}

struct NotificationTopBar: View {
    @Binding var current : String
    var title : String
    var animation : Namespace.ID
    
    var body: some View {
        
    HStack {
        
        Button(action: {
            withAnimation{current = title}
        }) {
            
            HStack {
                
                VStack(spacing: 5) {
                
                Text(title)
                    .font(Font.custom("Roboto-Regular", size: 15))
                    .foregroundColor(current == title ? Color("darkBlue") : Color.gray)
                    .padding(.horizontal)
                    
                    

                    // matched geometry effect slide animation
                    
                    if current == title {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color("darkBlue"))
                            .frame(width: 70, height: 2)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                        
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.clear)
                            .frame(width: 70, height: 2)
                    }
                }
            }
        }
        
        }
    }
}

// Refresh model
struct RefreshNotis {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool
    var released: Bool
    var invalid: Bool = false
}
