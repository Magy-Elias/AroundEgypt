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
                ExperienceDetailsScreenView() // View that gets presented
            }
        }
    }
}
