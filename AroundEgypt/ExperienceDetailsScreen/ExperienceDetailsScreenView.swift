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
                if let image = viewModel.image {
                    ExperienceImageView(image: image, viewCount: experienceDetails.viewsNo)
                }

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(experienceDetails.title)
                                .bold()
                            Spacer()

                            likeView
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

    var likeView: some View {
        HStack {
            Button(action: {
                viewModel.likeExperience()
            }, label: {
                Image(systemName: viewModel.likeImage)
                    .foregroundColor(.pink)
                    .frame(width: 15, height: 15)
            })
            .disabled(viewModel.isLiked)
            
            if let likesNo = viewModel.likesNo {
                Text(likesNo, format: .number)
            }
        }
    }
}

#Preview {
    ExperienceDetailsScreenView(experienceId: "7f209d18-36a1-44d5-a0ed-b7eddfad48d6")
}
