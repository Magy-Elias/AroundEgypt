//
//  ExperiencesScreenView.swift
//  AroundEgypt
//
//  Created by MagyElias on 19/01/2025.
//

import SwiftUI
import Kingfisher

struct ExperiencesScreenView: View {
    @StateObject var viewModel = ExperiencesScreenViewModel()
    @State private var isSearching: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("Try \"Luxor\"", text: $viewModel.searchText, onCommit: {
                        isSearching = true
                        viewModel.searchExperiences()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if isSearching {
                        Button(action: {
                            viewModel.searchText = ""
                            isSearching = false
                            viewModel.loadDefaultData()
                        }) {
                            Text("Clear")
                        }
                    }
                }
                .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        if !isSearching {
                            welcomeView
                            
                            recommendedExperiencesView
                        }
                        
                        recentExperiencesView
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }

    var welcomeView: some View {
        VStack(alignment: .leading) {
            Text("Welcome!")
                .font(.headline)
            
            Text("Now you can explore any experience in 360 degrees and get all the details about it all in one place.")
        }
    }

    var recommendedExperiencesView: some View {
        LazyVStack(alignment: .leading) {
            Text("Recommended Experiences")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(viewModel.recommendedExperiences, id: \.id) { experience in
                        NavigationLink(
                            destination: ExperienceDetailsScreenView(experienceId: experience.id)
                        ) {
                            drawExperienceHomeImageView(for: experience)
                        }
                    }
                }
            }
        }
    }

    var recentExperiencesView: some View {
        LazyVStack(alignment: .leading) {
            Text("Most Recent")
                .font(.headline)
            if isSearching, let filteredExperiences = viewModel.filteredExperiences {
                ForEach(filteredExperiences, id: \.id) { experience in
                    NavigationLink(
                        destination: ExperienceDetailsScreenView(experienceId: experience.id)
                    ) {
                        drawExperienceHomeImageView(for: experience)
                    }
                }
            } else {
                ForEach(viewModel.recentExperiences, id: \.id) { experience in
                    NavigationLink(
                        destination: ExperienceDetailsScreenView(experienceId: experience.id)
                    ) {
                        drawExperienceHomeImageView(for: experience)
                    }
                }
            }
        }
    }

    func drawExperienceHomeImageView(for experience: ExperienceResponse) -> some View {
        LazyVStack {
            ExperienceImageView(imageURL: experience.coverPhoto,
                                viewCount: experience.viewsNo,
                                showViewTitle: false)
            .frame(width: 350, height: 170, alignment: .leading)
            .cornerRadius(10)

            HStack {
                Text(experience.title)
                Spacer()
                ExperienceLikeView(viewModel: ExperienceLikeViewModel(experienceId: experience.id, likesNo: experience.likesNo))
            }
        }
    }
}
