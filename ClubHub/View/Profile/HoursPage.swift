//
//  HoursPage.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/15/23.
//

import SwiftUI
import Foundation
import Amplify

struct HoursPage: View {
    @State var events: [Event] = []
    @State var outsides: [Outside] = []
    @State var donations: [Donation] = []
    @State var currentTab = "Science Olympiad"
    let rows = [
        GridItem(.fixed(3), spacing: 20, alignment: .leading),
        GridItem(.fixed(2), spacing: 20, alignment: .leading)
        ]
    var body: some View {
        NavigationStack {
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            HoursBar(currentTab: $currentTab, tabTitle: "Science Olympiad")
                            HoursBar(currentTab: $currentTab, tabTitle: "Key Club")
                            HoursBar(currentTab: $currentTab, tabTitle: "Chess")
                            HoursBar(currentTab: $currentTab, tabTitle: "Care")
                            HoursBar(currentTab: $currentTab, tabTitle: "Model United Nations")
                            HoursBar(currentTab: $currentTab, tabTitle: "National Honors Society")
                            HoursBar(currentTab: $currentTab, tabTitle: "Student Council")
                        }.padding(.horizontal,10)
                    }.padding(.vertical,5).padding(.bottom,3).background(.white)
                    Divider()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                    
                        VStack(spacing: 15) {
                            HStack(spacing: 15) {
                                
                                // total events completed
                                VStack(alignment: .leading, spacing: 25) {
                                    HStack {
                                        Text("Total Events \nCompleted")
                                            .font(.custom("Roboto-Regular", size: 18))
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("7")
                                            .font(.custom("Roboto-Medium", size: 22))
                                            .foregroundColor(.black)
                                        
                                        /*HStack(spacing: 5) {
                                            Text("14 last week")
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(.gray)
                                            
                                            Image("upTrend")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.green)
                                            Text("+64%")
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(.green)
                                        }*/
                                    }
                                    
                                }.padding(25).background(RoundedRectangle(cornerRadius: 15).fill(.white))
                                
                                // total hours completed
                                VStack(alignment: .leading, spacing: 25) {
                                    HStack {
                                        Text("Total Hours \nCompleted")
                                            .font(.custom("Roboto-Regular", size: 18))
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("23 hrs")
                                            .font(.custom("Roboto-Medium", size: 22))
                                            .foregroundColor(.black)
                                        
                                        /*HStack(spacing: 5) {
                                            Text("12 hrs last week")
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(.gray)
                                            
                                            Image("downTrend")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.red)
                                            Text("-25%")
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(.red)
                                        }*/
                                    }
                                    
                                }.padding(25).background(RoundedRectangle(cornerRadius: 15).fill(.white))
                            }
                            
                            // member insights
                            VStack(alignment: .leading, spacing: 15) {
                                // Member insights for updates
                                HStack {
                                    Text("Leaderboard🔥")
                                        .font(.custom("Roboto-Regular", size: 18))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    /*HStack(spacing: 5) {
                                        Text("View more")
                                            .font(.custom("Roboto-Regular", size: 14))
                                            .foregroundColor(.gray)
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }*/
                                }
                                VStack(alignment: .leading, spacing: 10) {
                                    //TODO: Input real data from database here
                                    ForEach(insights) { member in
                                        HStack(spacing: 10) {
                                            Text(member.position)
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(Color("darkGray"))
                                            
                                            Text(member.name)
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Text(member.totalHours)
                                                .font(.custom("Roboto-Medium", size: 14))
                                                .foregroundColor(.black)
                                            
                                            /*HStack(spacing: 5) {
                                                Text(member.name)
                                                    .font(.custom("Roboto-Regular", size: 14))
                                                    .foregroundColor(.black)
                                                Image(member.image)
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(member.color)
                                                Text(member.change)
                                                    .font(.custom("Roboto-Regular", size: 14))
                                                    .foregroundColor(member.color)
                                            }*/
                                        }
                                        Divider()
                                    }
                                }
                            }.padding(25).background(RoundedRectangle(cornerRadius: 15).fill(.white))
                            
                            
                            // List of events
                            VStack(alignment: .leading, spacing: 20) {
                                Text("List of Events")
                                    .font(.custom("Roboto-Regular", size: 18))
                                    .foregroundColor(.black)
                                
                                LazyHGrid(rows: rows) {
                                    ForEach(eventTabs) { tab in
                                        HStack(spacing: 5) {
                                            Circle()
                                                .fill(tab.color)
                                                .frame(width: 10, height: 10)
                                            
                                            Text(tab.type)
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(Color("darkGray"))
                                        }
                                    }
                                }
                                
                                // event type and hours completed
                                VStack(alignment: .leading, spacing: 15) {
                                    ForEach(events) { event in
                                       EventsCell(event: event)
                                        Divider()
                                    }
                                }.padding(.top,15)
                                
                            }.padding(25).background(RoundedRectangle(cornerRadius: 15).fill(.white))
                            
                            // List of donations
                            VStack(alignment: .leading, spacing: 20) {
                                Text("List of Donations")
                                    .font(.custom("Roboto-Regular", size: 18))
                                    .foregroundColor(.black)
                                
                                LazyHGrid(rows: rows) {
                                    ForEach(eventTabs) { tab in
                                        HStack(spacing: 5) {
                                            Circle()
                                                .fill(tab.color)
                                                .frame(width: 10, height: 10)
                                            
                                            Text(tab.type)
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(Color("darkGray"))
                                        }
                                    }
                                }
                                
                                // event type and hours completed
                                VStack(alignment: .leading, spacing: 15) {
                                    ForEach(outsides) { outside in
                                        Divider()
                                    }
                                }.padding(.top,15)
                                
                            }.padding(25).background(RoundedRectangle(cornerRadius: 15).fill(.white))
                            
                            // List of nonsponsored events
                            VStack(alignment: .leading, spacing: 20) {
                                Text("List of Non-Sponsored Events")
                                    .font(.custom("Roboto-Regular", size: 18))
                                    .foregroundColor(.black)
                                
                                LazyHGrid(rows: rows) {
                                    ForEach(eventTabs) { tab in
                                        HStack(spacing: 5) {
                                            Circle()
                                                .fill(tab.color)
                                                .frame(width: 10, height: 10)
                                            
                                            Text(tab.type)
                                                .font(.custom("Roboto-Regular", size: 14))
                                                .foregroundColor(Color("darkGray"))
                                        }
                                    }
                                }
                                
                                // event type and hours completed
                                VStack(alignment: .leading, spacing: 15) {
                                    ForEach(donations) { donation in
                                        
                                        Divider()
                                    }
                                }.padding(.top,15)
                                
                            }.padding(25).background(RoundedRectangle(cornerRadius: 15).fill(.white))
                        }.padding(.horizontal,10).padding(.top,10).padding(.bottom,15)
                        
                        Spacer()
                    
                    }.background(Color("back"))
            }
        }.navigationTitle("Hours")
    }
}

struct EventsCell: View {
    var event: Event
    //let diffComponents = Calendar.current.dateComponents([.hour], from: event.start, to: event.end)
    //let hours = diffComponents.hour
    var body: some View {
        HStack {
            if event.type == "Meeting" {
                Circle()
                    .fill(Color("purple."))
                    .frame(width: 10, height: 10)
            } else if event.type == "Sponsored" {
                Circle()
                    .fill(Color("blue."))
                    .frame(width: 10, height: 10)
            } else if event.type == "Other"{
                Circle()
                    .fill(Color("yellow."))
                    .frame(width: 10, height: 10)
            }
            Text(event.title)
                .font(.custom("Roboto-Regular", size: 14))
                .foregroundColor(.black)
            Spacer()
            //TODO: This is where the club leaders input hours for students bc they have access to the students hours - figure that out
            Text("fix")
                .font(.custom("Roboto-Regular", size: 14))
                .foregroundColor(.black)
            +
            Text("/")
                .font(.custom("Roboto-Regular", size: 14))
                .foregroundColor(.black)
            +
            //TODO: have swiftui do the math for finding the amount of time in hours between the startTime and the endTime
            Text("fix")
                .font(.custom("Roboto-Regular", size: 14))
                .foregroundColor(.black)
        }
    }
}

struct HoursBar: View {
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

struct MemberInsights: Identifiable {
    var id = UUID().uuidString
    var name: String
    var image: String
    var change: String
    var color: Color
    var position: String
    var totalHours: String
}

var insights = [
    MemberInsights(name: "Angelina Ilijevski", image: "upTrend", change: "+18%", color: Color.green, position: "1", totalHours: "72"),
    MemberInsights(name: "Bob Jones", image: "upTrend", change: "+5%", color: Color.green, position: "2", totalHours: "70"),
    MemberInsights(name: "Kelly Bardeux", image: "downTrend", change: "-1%", color: Color.red, position: "3", totalHours: "69"),
    MemberInsights(name: "Ava Lu", image: "upTrend", change: "+2%", color: Color.green, position: "4", totalHours: "68.5"),
    MemberInsights(name: "Jeff Smolenski", image: "downTrend", change: "-3%", color: Color.red, position: "5", totalHours: "68"),

]

struct EventTabs: Identifiable {
    var id = UUID().uuidString
    var color: Color
    var type: String
}

var eventTabs = [
    EventTabs(color: Color("purple."), type: "Meetings"),
    EventTabs(color: Color("blue."), type: "Sponsored"),
    EventTabs(color: Color("yellow."), type: "Other"),
]

struct EventTypes: Identifiable {
    var id = UUID().uuidString
    var color: Color
    var title: String
    var completedHours: String
    var totalHours: String
}

var eventList = [
EventTypes(color: Color("purple."), title: "Care Packages", completedHours: "2", totalHours: "2"),
EventTypes(color: Color("blue."), title: "Digital Elite Camp", completedHours: "2", totalHours: "5"),
EventTypes(color: Color("purple."), title: "02.12.2023 Meeting", completedHours: ".5", totalHours: ".5"),
EventTypes(color: Color("red."), title: "SmartSocial Summit", completedHours: "5", totalHours: "5"),
EventTypes(color: Color("green."), title: "Outside Hours", completedHours: "8", totalHours: "15"),
EventTypes(color: Color("yellow."), title: "We Lead", completedHours: "3", totalHours: "6"),
EventTypes(color: Color("blue."), title: "Girl Scout Cookie Loading", completedHours: "0", totalHours: "5"),
EventTypes(color: Color("blue."), title: "Indigo Family", completedHours: "2", totalHours: "5"),
EventTypes(color: Color("purple."), title: "November Meeting", completedHours: ".5", totalHours: ".5"),

]
