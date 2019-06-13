//
//  ContentView.swift
//  WithoutAnAccident
//
//  Created by Shane Qi on 6/11/19.
//  Copyright © 2019 Shane Qi. All rights reserved.
//

import SwiftUI

struct Journey: Hashable, Identifiable {
	var id: String { return title }
	let title: String
	let days: Int
	let button: String
}

struct JourneysList: View {

	var journeys: [Journey]

	var body: some View {
		NavigationView {
			List(journeys) { journey in
				HStack(alignment: .center) {
					VStack(alignment: .leading) {
						Text(journey.title).font(.title)
						Text("\(journey.days) days without an accident").font(.body).lineLimit(nil)
					}
					Spacer()
					Button(action: {}, label: { Text(journey.button) })
					}.padding(12)
				}.navigationBarTitle(Text("Journeys"))
				.navigationBarItems(
					trailing: Button(
						action: {},
						label: {
							Image(systemName: "plus.circle.fill")
					}))
		}
	}
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		JourneysList(journeys: [
			Journey(title: "Luna", days: 39, button: "💩"),
			Journey(title: "Diva", days: 32, button: "🐱")
			])
    }
}
#endif
