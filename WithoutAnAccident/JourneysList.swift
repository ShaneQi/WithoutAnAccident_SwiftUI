//
//  ContentView.swift
//  WithoutAnAccident
//
//  Created by Shane Qi on 6/11/19.
//  Copyright © 2019 Shane Qi. All rights reserved.
//

import SwiftUI
import CoreData

private enum Destination {

	case viewJourney
	case createJourney
	case addAccident

}

struct JourneysList: View {

	@State var selectedJourneyIndex: Int?
	@State var isEditing = false
	@State private var destination: Destination?

	@State var selectedJourney: Journey?
	@Environment(\.managedObjectContext) var managedObjectContext
	@FetchRequest(fetchRequest: Journey.fetchRequest()) var journeysX: FetchedResults<Journey>


	var body: some View {
		return NavigationView {
			List(journeysX, id: \.self) { journey in
				Button(action: {
					self.selectedJourney = journey
					self.destination = .viewJourney
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
							self.selectedJourney = journey
							self.destination = .addAccident
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
						let newJourney = NSEntityDescription.insertNewObject(forEntityName: "Journey", into: self.managedObjectContext) as! Journey
						newJourney.id = UUID()
						newJourney.since = Date()
						self.selectedJourney = newJourney
						self.destination = .createJourney
				},
					label: { Image(systemName: "plus.circle.fill") }))
		}
		.sheet(item: $selectedJourney, content: { journey in
			if self.destination == .viewJourney {
				JourneyView(isEditing: false, journey: journey)
					.environment(\.managedObjectContext, self.managedObjectContext)
			} else if self.destination == .createJourney {
				JourneyView(isEditing: true, journey: journey)
					.environment(\.managedObjectContext, self.managedObjectContext)
			} else {
				AccidentView(journey: journey)
					.environment(\.managedObjectContext, self.managedObjectContext)
			}
		})
	}
}
