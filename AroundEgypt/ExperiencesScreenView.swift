//
//  ExperiencesScreenView.swift
//  AroundEgypt
//
//  Created by MagyElias on 19/01/2025.
//

import SwiftUI

struct ExperiencesScreenView: View {
    @State private var isPresented = false

    var body: some View {
        VStack {
            Button("Show Detail Experience View") {
                isPresented.toggle()
            }
            .padding()
            .sheet(isPresented: $isPresented) {
                ExperienceDetailsScreenView(experienceId: "7f209d18-36a1-44d5-a0ed-b7eddfad48d6") // View that gets presented
            }
        }
    }
}
