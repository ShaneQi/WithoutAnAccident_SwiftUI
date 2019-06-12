//
//  JourneyView.swift
//  WithoutAnAccident
//
//  Created by Shane Qi on 6/12/19.
//  Copyright © 2019 Shane Qi. All rights reserved.
//

import SwiftUI

//struct Journey: Hashable, Identifiable {
//	var id: String { return title }
//	let title: String
//	let days: Int
//	let button: String
//}

struct J {

	let title: String
	let since: Date

}

struct Acc: Identifiable {

	let id: String

}

struct JourneyView: View {

	@State private var isEditing = false
	@State var date: Date = Date()
	@State var title: String = ""

	private let j = J(title: "Hello", since: Date())
	private let acc: [Acc] = [Acc(id: "acc1"), Acc(id: "acc2")]

	var body: some View {
		NavigationView {
			List {
				Section {
					if self.isEditing {
						TextField($title, placeholder: Text("Title"))
					}
					self.isEditing ? AnyView(DatePicker($date, label: { Text("Start from") })) : AnyView(Text("Start from \(j.since)"))
				}
				Section(header: Text("Accidents")) {
					ForEach(acc) { acc in
						Text(acc.id)
					}
				}
			}
				.listStyle(.grouped)
				.navigationBarTitle(Text(j.title))
				.navigationBarItems(
					trailing: Button(
						action: {
							self.isEditing.toggle()
					}, label: {
						self.isEditing ? Text("Done") : Text("Edit")
					}))
		}
	}
}

#if DEBUG
struct JourneyView_Previews: PreviewProvider {
	static var previews: some View {
		JourneyView()
	}
}
#endif

