//
//  AccidentView.swift
//  WithoutAnAccident
//
//  Created by Zengtai Qi on 2/12/20.
//  Copyright © 2020 Shane Qi. All rights reserved.
//

import SwiftUI

struct AccidentView: View {
    
    @State var accident = AccidentX(date: Date())
    @Binding var journey: JourneyX
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                DatePicker(selection: $accident.date, label: { Text("Happened at:") })
            }.listStyle(GroupedListStyle())
                .navigationBarItems(
                    leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    }),
                    trailing: Button(action: {
                        self.journey.accidents.append(self.accident)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                    }))
            
        }
    }
    
}
