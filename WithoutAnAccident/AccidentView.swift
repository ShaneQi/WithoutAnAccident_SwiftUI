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
	@State var editingAccident: Accident?

	private let dateTimeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	} ()

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Happened at")) {
					DatePicker(selection: $happenedAt, label: { Text("") })
						.datePickerStyle(WheelDatePickerStyle())
						.labelsHidden()
				}
			}.listStyle(GroupedListStyle())
				.navigationBarTitle(Text(self.editingAccident == nil ? "New Accident" : "Edit Accident"))
				.navigationBarItems(
					leading: Button(action: {
						self.presentationMode.wrappedValue.dismiss()
					}, label: {
						Text("Cancel")
					}),
					trailing: Button(action: {
						if let accident = self.editingAccident {
							accident.happenedAt = self.happenedAt
						} else {
							let newAccident = NSEntityDescription.insertNewObject(forEntityName: "Accident", into: self.managedObjectContext) as! Accident
							newAccident.id = UUID()
							newAccident.happenedAt = self.happenedAt
							self.journey.addAccident(newAccident)
						}
						try! self.managedObjectContext.save()
						self.presentationMode.wrappedValue.dismiss()
					}, label: {
						Text("Done")
					}))

		}.onAppear {
			if let accident = self.editingAccident {
				self.happenedAt = accident.happenedAt
			}
		}
	}

}
