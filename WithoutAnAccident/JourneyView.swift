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
	@State var date: Date = Date()
	@State var title: String = ""
    @Binding var journey: JourneyX
    @State var newAccident: AccidentX?
    
	var body: some View {
        NavigationView {
            List {
                Section {
                    if self.isEditing {
                        HStack {
                            Text("Title")
                            TextField("Enter Title", text: $journey.title).multilineTextAlignment(.trailing)
                        }
                    }
                    if self.isEditing {
                        DatePicker(selection: $journey.since, label: { Text("Start from") })
                    } else {
                        Text("Start from \(journey.since)")
                    }
                    HStack {
                        Text("Action")
                        if self.isEditing {
                            TextField("Enter Action", text: $journey.button).multilineTextAlignment(.trailing)
                        } else {
                            Spacer()
                            Text(journey.button)
                        }
                    }
                }
                Section(header: HStack {
                    Text("ACCIDENTS:")
                    Spacer()
                    Button(action: { self.newAccident = AccidentX(date: Date()) }, label: { Text("ADD") })
                }) {
                    ForEach(journey.accidents) { accident in
                        HStack {
                            Text("\(accident.date)")
                            if self.isEditing {
                                Spacer()
                                Button(action: {
                                    self.journey.accidents.removeAll(where: { $0 == accident })
                                }, label: { Image(systemName: "trash.fill") })
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text(self.isEditing ? "Edit Journey" : self.journey.title))
            .navigationBarItems(trailing: Button(action: {
                self.isEditing.toggle()
            }, label: {
                self.isEditing ? Text("Done") : Text("Edit")
            }))
                .sheet(item: $newAccident, content: { _ in
                    AccidentView(journey: self.$journey)
                })
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
