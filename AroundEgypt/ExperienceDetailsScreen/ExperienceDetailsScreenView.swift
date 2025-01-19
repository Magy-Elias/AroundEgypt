//
//  ExperienceDetailsScreenView.swift
//  AroundEgypt
//
//  Created by MagyElias on 18/01/2025.
//

import SwiftUI

struct ExperienceDetailsScreenView: View {
    @StateObject private var viewModel = ExperienceDetailsScreenViewModel()

    var body: some View {
        LazyVStack {
            if let experienceDetails = viewModel.experienceDetails, let image = viewModel.image {
                ExperienceImageView(image: image, viewCount: experienceDetails.viewsNo)

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text(experienceDetails.title)
                            .bold()
                        
                        Text("\(experienceDetails.city.name), Egypt.")
                    }

                    Divider()
                        .overlay(Color.gray)
                    
                    VStack(alignment: .leading) {
                        Text("Description")
                            .bold()
                        
                        Text(experienceDetails.description)
                    }
                }
                .padding(.horizontal)
                
            } else if let errorMessage = viewModel.errorMessage {
                drawErrorView(with: errorMessage)
            } else {
                loadingView
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            viewModel.fetchExperienceDetails()
        }
    }

    func drawErrorView(with errorMessage: String) -> some View {
        Text("Error: \(errorMessage)")
            .foregroundColor(.red)
            .padding(.horizontal)
    }

    var loadingView: some View {
        Text("Loading...")
            .padding(.horizontal)
    }
}

#Preview {
    ExperienceDetailsScreenView()
}
