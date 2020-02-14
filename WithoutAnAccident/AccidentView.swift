//
//  AccidentView.swift
//  WithoutAnAccident
//
//  Created by Shane Qi on 2/12/20.
//  Copyright © 2020 Shane Qi. All rights reserved.
//

import SwiftUI
import CoreData

struct AccidentView: View {

	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var managedObjectContext

	@State var happenedAt = Date()
	@ObservedObject var journey: Journey

	var body: some View {
		NavigationView {
			List {
				DatePicker(selection: $happenedAt, label: { Text("Happened at:") })
			}.listStyle(GroupedListStyle())
				.navigationBarTitle(Text("New Accident"))
				.navigationBarItems(
					leading: Button(action: {
						self.presentationMode.wrappedValue.dismiss()
					}, label: {
						Text("Cancel")
					}),
					trailing: Button(action: {
						let newAccident = NSEntityDescription.insertNewObject(forEntityName: "Accident", into: self.managedObjectContext) as! Accident
						newAccident.id = UUID()
						newAccident.happenedAt = self.happenedAt
						self.journey.addAccident(newAccident)
						try! self.managedObjectContext.save()
						self.presentationMode.wrappedValue.dismiss()
					}, label: {
						Text("Done")
					}))

		}
	}

}
