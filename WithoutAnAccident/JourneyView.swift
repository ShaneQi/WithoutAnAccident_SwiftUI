//
//  JourneyView.swift
//  WithoutAnAccident
//
//  Created by Shane Qi on 6/12/19.
//  Copyright © 2019 Shane Qi. All rights reserved.
//

import SwiftUI

struct JourneyView: View {

    @State var isEditing: Bool
    @ObservedObject var journey: Journey
    
    // Temp values
    @State var title: String = ""
    @State var since: Date = Date()
    @State var action: String = ""
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
	var body: some View {
        NavigationView {
            List {
                Section {
                    if self.isEditing {
                        HStack {
                            Text("Title")
                            TextField("Enter Title", text: $title).multilineTextAlignment(.trailing)
                        }
                    }
                    if self.isEditing {
                        DatePicker(selection: $since, label: { Text("Start from") })
                    } else {
                        Text("Start from \(since)")
                    }
                    HStack {
                        Text("Action")
                        if self.isEditing {
                            TextField("Enter Action", text: $action).multilineTextAlignment(.trailing)
                        } else {
                            Spacer()
                            Text(action)
                        }
                    }
                }
//                Section(header: HStack {
//                    Text("ACCIDENTS:")
//                    Spacer()
////                    Button(action: { self.newAccident = AccidentX(date: Date()) },
////                           label: { Text("ADD") })
//                }) {
//                    ForEach(journey.accidents as! Set<Accident>, id: \Accident.id) { accident in
//                        HStack {
//                            Text("\(accident.date)")
//                            if self.isEditing {
//                                Spacer()
//                                Button(action: {
//                                    self.journey.accidents.removeAll(where: { $0 == accident })
//                                }, label: { Image(systemName: "trash.fill") })
//                            }
//                        }
//                    }
//                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text(isEditing ? "Edit Journey" : title))
            .navigationBarItems(leading: Group {
                if self.isEditing {
                    Button(action: {
                        self.title = self.journey.title
                        self.since = self.journey.since
                        self.action = self.journey.action
                        self.isEditing.toggle()
                    }, label: { Text("Cancel") })
                }
                }
                ,trailing: Button(action: {
                    if self.isEditing {
                        self.journey.title = self.title
                        self.journey.since = self.since
                        self.journey.action = self.action
                        try! self.managedObjectContext.save()
                    }
                self.isEditing.toggle()
            }, label: {
                self.isEditing ? Text("Done") : Text("Edit")
            }))
//                .sheet(item: $newAccident, content: { _ in
//                    AccidentView(journey: self.$journey)
//                })
        }.onAppear {
            self.title = self.journey.title
            self.since = self.journey.since
            self.action = self.journey.action
        }
	}
}

#if DEBUG
//struct JourneyView_Previews: PreviewProvider {
//	static var previews: some View {
////		JourneyView(journey: Journey(title: "Luna", days: 39, button: "💩"))
//	}
//}
#endif

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}
