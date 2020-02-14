//
//  JourneyView.swift
//  WithoutAnAccident
//
//  Created by Shane Qi on 6/12/19.
//  Copyright © 2019 Shane Qi. All rights reserved.
//

import SwiftUI
import CoreData

struct JourneyView: View {

    @State var isEditing: Bool = false
    @ObservedObject var journey: Journey
    
    // Temp values
    @State var title: String = ""
    @State var since: Date = Date()
    @State var action: String = ""
    @State var addingAccidentToJourney: Journey?
    
    let isInitiallyEditing: Bool?
    
    @Environment(\.managedObjectContext) var managedObjectContext
    var fetchedResults: FetchRequest<Accident>
    
    init(isEditing: Bool, journey: Journey) {
        self.isInitiallyEditing = isEditing
        self.journey = journey
        fetchedResults = FetchRequest(
            entity: Accident.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Accident.happenedAt, ascending: false)],
            predicate: NSPredicate(format: "journey == %@", journey))
    }

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
                Section(header: HStack {
                    Text("ACCIDENTS:")
                    Spacer()
                    Button(action: { self.addingAccidentToJourney = self.journey },
                           label: { Text("ADD") })
                }) {
                    ForEach(fetchedResults.wrappedValue, id: \Accident.id) { accident in
                        HStack {
                            Text("\(accident.happenedAt)")
                            if self.isEditing {
                                Spacer()
                                Button(action: {
                                    self.managedObjectContext.delete(accident)
                                    try! self.managedObjectContext.save()
                                }, label: { Image(systemName: "trash.fill") })
                            }
                        }
                    }
                }
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
                .sheet(item: $addingAccidentToJourney, content: { journey in
                    AccidentView(journey: journey)
                })
        }.onAppear {
            if let isEditing = self.isInitiallyEditing {
                self.isEditing = isEditing
            }
            self.title = self.journey.title
            self.since = self.journey.since
            self.action = self.journey.action
        }
	}
}
