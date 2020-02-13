//
//  ContentView.swift
//  WithoutAnAccident
//
//  Created by Shane Qi on 6/11/19.
//  Copyright © 2019 Shane Qi. All rights reserved.
//

import SwiftUI

struct JourneyX: Hashable, Identifiable {
	var id: String { return title }
	var title: String
    var since: Date
	let days: Int
	var button: String
    var accidents: [AccidentX]
}

struct AccidentX: Hashable, Identifiable {
    let id: String = UUID().uuidString
    var date: Date
}

extension Int: Identifiable {
    
    public var id: Int { return self }
    
}

private enum Destination {
    
    case viewJourney
    case createJourney
    case addAccident
    
}

struct JourneysList: View {

	@State var journeys: [JourneyX]
    @State var selectedJourneyIndex: Int?
    @State var isEditing = false
    @State private var destination: Destination?
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Journey.fetchRequest()) var journeysX: FetchedResults<Journey>


    var body: some View {
//        let journeys = self.journeysX.enumerated().map({ $0 })
        return NavigationView {
            List(journeysX, id: \.self) { journey in
                Button(action: {
//                    self.selectedJourneyIndex = index
//                    self.destination = .viewJourney
                }, label: {
                    HStack(alignment: .center) {
                        if self.isEditing {
                            Button(action: {
                                self.managedObjectContext.delete(journey)
                                try! self.managedObjectContext.save()
                            }, label: { Image(systemName: "trash.fill") })
                        }
                        VStack(alignment: .leading) {
                            Text(journey.title).font(.title)
                            Text("0 days without an accident").font(.body).lineLimit(nil)
                        }
                        Spacer()
                        Button(action: {
//                            self.selectedJourneyIndex = index
//                            self.destination = .addAccident
                        }, label: { Text(journey.action) })
                    }.padding(12)
                })
            }
            .navigationBarTitle(Text("Journeys"))
            .navigationBarItems(
                leading: Button(
                    action: {
                        self.isEditing.toggle()
                },
                    label: { Text(self.isEditing ? "Done" : "Edit") }),
                trailing: Button(
                    action: {
                        self.journeys.append(JourneyX(title: "Untitled", since: Date(), days: 0, button: "uh-oh", accidents: []))
                        self.selectedJourneyIndex = self.journeys.count
                        self.destination = .createJourney
                },
                    label: { Image(systemName: "plus.circle.fill") }))
        }
        .sheet(item: $selectedJourneyIndex, content: { index in
            if self.destination == .viewJourney {
                JourneyView(isEditing: false, journey: self.$journeys[index])
            } else if self.destination == .createJourney {
                JourneyView(isEditing: true, journey: self.$journeys[index])
            } else {
                AccidentView(accident: AccidentX(date: Date()), journey: self.$journeys[index])
            }
        })
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		JourneysList(journeys: [
//			Journey(title: "Luna", days: 39, button: "💩"),
//			Journey(title: "Diva", days: 32, button: "🐱")
			])
    }
}
#endif
