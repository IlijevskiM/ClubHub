//
//  CreateEvent.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/25/23.
//

import SwiftUI
import Amplify

struct CreateNewEvent: View {
    @Namespace var animation
    @State var current = "Meeting"
    @Binding var createEventTapped: Bool
    @State var isLoading = false
    @State var selectedIndex = 0
    
    let eventItems = [
    SelectedEventType(eventType: "Meeting"),
    SelectedEventType(eventType: "Sponsored"),
    SelectedEventType(eventType: "Outside"),
    SelectedEventType(eventType: "Donation"),
    SelectedEventType(eventType: "Other")
    ]
    var body: some View {
        
        VStack {
            VStack {
                
                HStack {
                    Spacer()
                    Text("Create event")
                        .font(.custom("Roboto-Medium", size: 20))
                        .foregroundColor(.black)
                        .padding(.leading,35)
                    Spacer()
                    Button {
                        self.createEventTapped.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .padding(8)
                            .background(
                                Circle().fill(Color("back"))
                            )
                            .frame(alignment: .topTrailing)
                    }
                }
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Type")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                        
                        HStack(spacing: 20) {
                            ForEach(eventItems) { item in
                                EventTypeFilter(current: $current, title: self.eventItems[selectedIndex].eventType, animation: animation)
                            }
                        }
                    }
                    
                    Spacer()
                }.padding(.vertical,5).padding(.bottom,5)
            }.padding(.horizontal,15).padding(.top,10)
            
            if current == "Meeting" {
                EventForm(createEventTapped: $createEventTapped, isLoading: $isLoading, eventItems: eventItems, selectedItem: $selectedIndex)
            } else if current == "Sponsored" {
                EventForm(createEventTapped: $createEventTapped, isLoading: $isLoading, eventItems: eventItems, selectedItem: $selectedIndex)
            } else if current == "Outside" {
                OutsideEvent()
            } else if current == "Donation" {
                DonationEvent()
            } else {
                EventForm(createEventTapped: $createEventTapped, isLoading: $isLoading, eventItems: eventItems, selectedItem: $selectedIndex)
            }
        }
        
            .overlay (
                ZStack(
                       content: {
                           
                    if isLoading{
                        //Color.black.opacity(0.1)
                        Color.white
                            .ignoresSafeArea()
                        LoadingScreenForNewEvent(isLoading: $isLoading)
                            
                    }
                })
            )
        
    }
}

struct SelectedEventType: Identifiable {
    var id = UUID().uuidString
    let eventType: String
}

struct EventTypeFilter: View {
    @Binding var current : String
    var title : String
    var animation : Namespace.ID
    var body: some View {
        
        //HStack {
            Button(action: {
                withAnimation{current = title}
            }) {
                
                //HStack {
                    
                    //ZStack {
                        
                        // matched geometry effect slide animation
                        /*if current == title {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("back"), lineWidth: 2)
                                .frame(height: 35)
                                .matchedGeometryEffect(id: "Tab", in: animation)
                            
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.clear, lineWidth: 2)
                                .frame(height: 35)
                        }*/
                        
                        Text(title)
                    .font(.custom(current == title ? "Roboto-Medium": "Roboto-Regular", size: 16))
                            .foregroundColor(current == title ? Color("darkBlue") : Color.gray)
                            //.padding(.horizontal)
                        
                    //}
                //}
            }
        //}
    }
}

struct EventForm: View {
    @State var title: String = ""
    @State var location: String = ""
    @State var description: String = ""
    @State var date = Date()
    @State var startTime = Date()
    @State var endTime = Date()
    //@State var due = Date()
    //@State var hourLimit: String = ""
    @State private var capacity: Int?
    @State var createMeetingEvent: Bool = false
    //@Binding var current: String
    @Binding var createEventTapped: Bool
    @Binding  var isLoading: Bool
    
    var eventItems: [SelectedEventType]
    @Binding var selectedItem: Int
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Event name")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                    TextField("Enter event name", text: $title)
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(10)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("back"), lineWidth: 1.5)
                        )
                        .accentColor(.black)
                }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                        TextField("Enter location", text: $location)
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("back"), lineWidth: 1.5)
                            )
                            .accentColor(.black)
                    }
                
                    HStack {
                        Text("Date")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .labelsHidden()
                    }
                    HStack {
                        Text("Start time")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    HStack {
                        Text("End time")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                
                    HStack {
                        Text("Capacity")
                            .font(.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Picker("", selection: $capacity) {
                            Text("None").tag(nil as Int?)
                            ForEach(1...500, id: \.self) { capacity in
                                Text("\(capacity)")
                                    .tag(capacity as Int?)
                            }
                        }.background(Capsule().stroke(Color("back"), lineWidth: 1.5))
                    }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                    TextField("Enter a description", text: $description, axis: .vertical)
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .frame(height: 100, alignment: .topLeading)
                        .padding(10)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("back"), lineWidth: 1.5)
                        )
                        .accentColor(.black)
                }
                
                //Spacer()
                
                    Button {
                        Task { await createEvent() }
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.createEventTapped = false
                        }
                        dismissKeyboard()
                    } label: {
                        Text("Create")
                            .font(.custom("Roboto-Medium", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,10)
                            .background(
                            Capsule()
                                .fill(LinearGradient(colors: [Color("darkBlue"), Color.blue], startPoint: .leading, endPoint: .trailing))
                            )
                    }
                        .disabled(title.isEmpty || location.isEmpty || description.isEmpty)
                        .opacity(title.isEmpty || location.isEmpty || description.isEmpty ? 0.6 : 1)
                    
                
            }.padding(.horizontal,15).padding(.bottom,50)
        }.scrollDismissesKeyboard(.immediately)
    }
    
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
    
    func createEvent()async{
        let eventId = UUID().uuidString
        do {
            let newEvent = Event(id: eventId, title: title, location: location, description: description, date: Temporal.DateTime(date), start: Temporal.DateTime(startTime), end: Temporal.DateTime(endTime), capacity: capacity ?? 1, type: self.eventItems[selectedItem].eventType, publishedTime: .now())
            
            let savedEvent = try await Amplify.DataStore.save(newEvent)
            print("Saved event: \(savedEvent)")
            
            title = ""
            location = ""
            description = ""
        }catch let error as DataStoreError{
            print("Failed with error \(error)")
        }catch{
            print("Unexpected error \(error)")
        }
    }
}

struct LoadingScreenForNewEvent: View {
    @Binding var isLoading: Bool
    var body: some View {
            VStack(spacing: 15){
                ProgressView()
                    .tint(.blue)
                Text("Creating event...")
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.black)
            }
    }
}

struct DonationEvent: View {
    @State var title: String = ""
    @State var location: String = ""
    @State var description: String = ""
    @State var due = Date()
    @State var time = Date()
    @State var createDonationEvent: Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 20) {
                    
                VStack(alignment: .leading, spacing: 10) {
                    Text("Event name")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                    TextField("Enter event name", text: $title)
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(10)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("back"), lineWidth: 1.5)
                        )
                        .accentColor(.black)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Location")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                    TextField("Enter location", text: $location)
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(10)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("back"), lineWidth: 1.5)
                        )
                        .accentColor(.black)
                }
                
                HStack {
                    Text("Due date & time")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                    Spacer()
                    HStack {
                        DatePicker("", selection: $due, displayedComponents: .date)
                            .labelsHidden()
                        
                        DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                    TextField("Enter a description", text: $description, axis: .vertical)
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .frame(height: 100, alignment: .topLeading)
                        .padding(10)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("back"), lineWidth: 1.5)
                        )
                        .accentColor(.black)
                }
                //Spacer()
                    Button {
                        Task { await createDonationEvent() }
                        dismissKeyboard()
                        self.createDonationEvent.toggle()
                    } label: {
                        Text("Create")
                        .font(.custom("Roboto-Medium", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical,10)
                        .background(
                        Capsule()
                            .fill(LinearGradient(colors: [Color("darkBlue"), Color.blue], startPoint: .leading, endPoint: .trailing))
                        )
                    }
                        .disabled(title.isEmpty || location.isEmpty || description.isEmpty)
                        .opacity(title.isEmpty || location.isEmpty || description.isEmpty ? 0.6 : 1)
                
            }.padding(.horizontal,15)
        }.scrollDismissesKeyboard(.immediately)
    }
    
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
    
    func createDonationEvent()async{
        let donationEventId = UUID().uuidString
        
        do {
            let newDonationEvent = Donation(id: donationEventId, publishedTime: .now(), title: title, location: location, description: description, due: Temporal.DateTime(due))
            
            let savedEvent = try await Amplify.DataStore.save(newDonationEvent)
            print("Saved event: \(savedEvent)")
            
            title = ""
            location = ""
            description = ""
        }catch let error as DataStoreError{
            print("Failed with error \(error)")
        }catch{
            print("Unexpected error \(error)")
        }
    }
}

struct OutsideEvent: View {
    @State var title: String = ""
    @State var due = Date()
    @State var time = Date()
    @State var hourLimit: Int?
    @State var createOutsideEvent: Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 20) {
                    
                VStack(alignment: .leading, spacing: 10) {
                    Text("Event name")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                    TextField("Enter event name", text: $title)
                        .font(.custom("Roboto-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(10)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("back"), lineWidth: 1.5)
                        )
                        .accentColor(.black)
                }
                
                HStack {
                    Text("Due date & time")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                    Spacer()
                    HStack {
                        DatePicker("", selection: $due, displayedComponents: .date)
                            .labelsHidden()
                        
                        DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                
                HStack {
                    Text("Hour limit")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Picker("", selection: $hourLimit) {
                        Text("None").tag(nil as Int?)
                        ForEach(1...200, id: \.self) { limit in
                            Text("\(limit)")
                                .tag(limit as Int?)
                        }
                    }.background(Capsule().stroke(Color("back"), lineWidth: 1.5))
                }
                
                //Spacer()
                Button {
                    Task { await createOutsideEvent() }
                    dismissKeyboard()
                        self.createOutsideEvent.toggle()
                    } label: {
                        Text("Create")
                        .font(.custom("Roboto-Medium", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical,10)
                        .background(
                        Capsule()
                            .fill(LinearGradient(colors: [Color("darkBlue"), Color.blue], startPoint: .leading, endPoint: .trailing))
                        )
                    }
                        .disabled(title.isEmpty)
                        .opacity(title.isEmpty ? 0.6 : 1)
            
                
            }.padding(.horizontal,15)
        }.scrollDismissesKeyboard(.immediately)
    }
    
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
    
    func createOutsideEvent()async{
        let outsideEventId = UUID().uuidString
        
        do {
            // TODO: Change hourlimit so there is a default of "None"
            let newOutsideEvent = Outside(id: outsideEventId, publishedTime: .now(), title: title, due: Temporal.DateTime(due), hourLimit: hourLimit ?? 1)
            
            let savedEvent = try await Amplify.DataStore.save(newOutsideEvent)
            print("Saved event: \(savedEvent)")
            
            title = ""
        }catch let error as DataStoreError{
            print("Failed with error \(error)")
        }catch{
            print("Unexpected error \(error)")
        }
    }
}
