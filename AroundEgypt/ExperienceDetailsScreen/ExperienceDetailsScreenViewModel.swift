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

    @Published var experienceDetails: ExperienceDetails?
    @Published var image: UIImage?
    @Published var errorMessage: String?

    func fetchExperienceDetails() {
        apiService.fetchExperienceDetails(id: "7f209d18-36a1-44d5-a0ed-b7eddfad48d6")
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.getExperienceImage()
                case .failure(let failure):
                    self?.errorMessage = "Failed to fetch experience details: \(failure.localizedDescription)"
                }
            }, receiveValue: { [weak self] experienceDetails in
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
                    self?.errorMessage = "Failed to download experience image: \(failure.localizedDescription)"
                }
            }, receiveValue: { [weak self] image in
                self?.image = image
            })
            .store(in: &cancellables) // Store the subscription
    }
}
