//
//  ExperienceDetailsScreenView.swift
//  AroundEgypt
//
//  Created by MagyElias on 18/01/2025.
//

import SwiftUI

struct ExperienceDetailsScreenView: View {
    @StateObject private var viewModel: ExperienceDetailsScreenViewModel

    init(experienceId: String) {
        _viewModel = StateObject(wrappedValue: ExperienceDetailsScreenViewModel(experienceId: experienceId))
    }

    var body: some View {
        LazyVStack {
            if let experienceDetails = viewModel.experienceDetails {
                ExperienceImageView(imageURL: experienceDetails.coverPhoto,
                                    viewCount: experienceDetails.viewsNo,
                                    showViewTitle: true)

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(experienceDetails.title)
                                .bold()
                            Spacer()

                            ExperienceLikeView(viewModel: ExperienceLikeViewModel(experienceId: experienceDetails.id, likesNo: experienceDetails.likesNo))
                        }
                        
                        Text("\(experienceDetails.city.name), Egypt.")
                            .foregroundColor(.gray)
                            .bold()
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
