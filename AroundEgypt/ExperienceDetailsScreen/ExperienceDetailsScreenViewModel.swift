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

    @Published var experienceDetails: ExperienceResponse?
    @Published var errorMessage: String?

    init(experienceId: String) {
        self.experienceId = experienceId
        fetchExperienceDetails()
    }

    func fetchExperienceDetails() {
        apiService.fetchExperienceDetails(id: experienceId)
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Fetch experiences list successfully.")
                    break
                case .failure(let failure):
                    self?.handleError(message: "Failed to fetch experience details: \(failure.localizedDescription)")
                }
            }, receiveValue: { [weak self] experienceDetails in
                self?.experienceDetails = experienceDetails.data
            })
            .store(in: &cancellables)
    }

    private func handleError(message: String) {
        self.errorMessage = message
    }
}
