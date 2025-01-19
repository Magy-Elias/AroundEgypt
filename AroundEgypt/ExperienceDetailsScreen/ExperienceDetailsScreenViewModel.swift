//
//  ExperienceDetailsScreenViewModel.swift
//  AroundEgypt
//
//  Created by MagyElias on 18/01/2025.
//

import Foundation
import UIKit
import Combine

class ExperienceDetailsScreenViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let apiService = ApiService()
    private let experienceId: String

    @Published var experienceDetails: ExperienceDetails?
    @Published var image: UIImage?
    @Published var likesNo: Int?
    @Published var isLiked: Bool = false
    @Published var likeImage: String
    @Published var errorMessage: String?

    init(experienceId: String) {
        self.experienceId = experienceId
        self.likeImage = "heart"
        fetchExperienceDetails()
        
    }

    func fetchExperienceDetails() {
        apiService.fetchExperienceDetails(id: experienceId)
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.getExperienceImage()
                case .failure(let failure):
                    self?.handleError(message: "Failed to fetch experience details: \(failure.localizedDescription)")
                }
            }, receiveValue: { [weak self] experienceDetails in
                self?.likesNo = experienceDetails.data.likesNo
                self?.experienceDetails = experienceDetails.data
            })
            .store(in: &cancellables)
    }

    func getExperienceImage() {
        guard let experienceDetails = experienceDetails else { return }
        apiService.downloadImage(from: experienceDetails.coverPhoto)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Image downloaded successfully.")
                    break
                case .failure(let failure):
                    self?.handleError(message: "Failed to download experience image: \(failure.localizedDescription)")
                }
            }, receiveValue: { [weak self] image in
                self?.image = image
            })
            .store(in: &cancellables) // Store the subscription
    }

    func likeExperience() {
        guard !isLiked else { return } // Avoid multiple likes
        apiService.likeExperience(id: experienceId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Like experience successfully.")
                    break
                case .failure(let failure):
                    self?.handleError(message: "Failed to like experience: \(failure.localizedDescription)")
                }
            }, receiveValue: { [weak self] likesResponse in
                self?.likesNo = likesResponse.data
                self?.likeImage = "heart.fill"
                self?.isLiked = true
            })
            .store(in: &cancellables) // Store the subscription
    }

    private func handleError(message: String) {
        self.errorMessage = message
    }
}
