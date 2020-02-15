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

	@State var isEditing = false
	@State var showDatePicker = false
	@ObservedObject var journey: Journey
	
	// Temp values
	@State var title: String = ""
	@State var since: Date = Date()
	@State var action: String = ""
	@State var addingAccidentToJourney: Journey?
	
	let isInitiallyEditing: Bool?
	@State var editingAccident: Accident?

	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var managedObjectContext
	var fetchedResults: FetchRequest<Accident>

	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .none
		return formatter
	} ()

	private let dateTimeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	} ()
	
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
							TextField("Enter Title", text: $title)
								.multilineTextAlignment(.trailing)
								.foregroundColor(.orange)
						}
					}
					if self.isEditing {
						Button(action: {
							self.showDatePicker.toggle()
						}, label: {
							HStack{
								Text("Start from").foregroundColor(.black)
								Spacer()
								Text(self.dateFormatter.string(from: since)).foregroundColor(.orange)
							}
						})
						if self.showDatePicker {
							DatePicker(selection: $since, displayedComponents: [.date], label: { Text("") })
								.datePickerStyle(WheelDatePickerStyle())
								.labelsHidden()
						}
					} else {
						HStack{
							Text("Start from")
							Spacer()
							Text(self.dateFormatter.string(from: self.journey.since))
						}
					}
					HStack {
						Text("Action")
						if self.isEditing {
							TextField("Enter Action", text: $action)
								.multilineTextAlignment(.trailing)
								.foregroundColor(.orange)
						} else {
							Spacer()
							Text(action)
						}
					}
				}
				Section(header: HStack {
					Text("ACCIDENTS")
					Spacer()
					Button(action: {
						self.editingAccident = nil
						self.addingAccidentToJourney = self.journey

					},
						   label: { Text("ADD") })
				}) {
					ForEach(fetchedResults.wrappedValue, id: \Accident.id) { accident in
						Button(action: {
							self.editingAccident = accident
							self.addingAccidentToJourney = self.journey
						}, label: {
							HStack {
								Text(self.dateTimeFormatter.string(from: accident.happenedAt))
									.foregroundColor(.black)
								if self.isEditing {
									Spacer()
									Button(action: {
										self.managedObjectContext.delete(accident)
										try! self.managedObjectContext.save()
										}, label: { Image(systemName: "trash.fill") }).padding(8)
								}
							}
						})
					}
				}
				if self.isEditing {
					Section {
						HStack {
							Spacer()
							Button(action: {
								self.presentationMode.wrappedValue.dismiss()
								self.managedObjectContext.delete(self.journey)
								try! self.managedObjectContext.save()
							}, label: {
								Text("Delete")
							})
							Spacer()
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
						self.showDatePicker = false
					}, label: { Text("Cancel") })
				}
				}
				,trailing: Button(action: {
					UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
					if self.editingAccident != nil {
						AccidentView(journey: journey, editingAccident: self.editingAccident!)
							.environment(\.managedObjectContext, self.managedObjectContext)
					} else {
						AccidentView(journey: journey, editingAccident: nil)
							.environment(\.managedObjectContext, self.managedObjectContext)
					}
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
