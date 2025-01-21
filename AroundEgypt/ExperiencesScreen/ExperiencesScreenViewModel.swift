//
//  ExperiencesScreenViewModel.swift
//  AroundEgypt
//
//  Created by MagyElias on 19/01/2025.
//

import Foundation
import Combine

class ExperiencesScreenViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let apiService = ApiService()

    @Published var recommendedExperiences = [ExperienceResponse]()
    @Published var recentExperiences = [ExperienceResponse]()
    @Published var searchText: String = ""
    @Published var filteredExperiences: [ExperienceResponse]?
    @Published var errorMessage: String?

    init() {
        loadDefaultData()
    }

    func loadDefaultData() {
        filteredExperiences = nil
        fetchRecommendedExperiences()
        fetchRecentExperiences()
    }

    private func fetchRecommendedExperiences() {
        if NetworkManager.shared.isConnected {
            apiService.fetchRecommendedExperiences()
                .receive(on: DispatchQueue.main)
                .sink (receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("Fetch recommended experiences list successfully.")
                        break
                    case .failure(let failure):
                        self?.handleError(message: "Failed to fetch experience details: \(failure.localizedDescription)")
                    }
                }, receiveValue: { [weak self] experiencesListResponse in
                    guard let self = self else { return }
                    self.recommendedExperiences = experiencesListResponse.data
                    
                    // Save to Core Data
                    CoreDataManager.shared.saveRecommendedExperiences(experiencesListResponse.data)
                })
                .store(in: &cancellables)
        } else {
            // Network is offline, fetch from Core Data
            self.recommendedExperiences = CoreDataManager.shared.fetchRecommendedExperiences()
        }
    }

    private func fetchRecentExperiences() {
        if NetworkManager.shared.isConnected {
            apiService.fetchRecentExperiences()
                .receive(on: DispatchQueue.main)
                .sink (receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("Fetch recent experiences list successfully.")
                        break
                    case .failure(let failure):
                        self?.handleError(message: "Failed to fetch experience details: \(failure.localizedDescription)")
                    }
                }, receiveValue: { [weak self] experiencesListResponse in
                    guard let self = self else { return }
                    self.recentExperiences = experiencesListResponse.data
                    
                    // Save to Core Data
                    CoreDataManager.shared.saveRecentExperiences(experiencesListResponse.data)
                })
                .store(in: &cancellables)
        } else {
            // Network is offline, fetch from Core Data
            self.recentExperiences = CoreDataManager.shared.fetchRecentExperiences()
        }
    }

    func searchExperiences() {
        if NetworkManager.shared.isConnected {
            apiService.searchExperiences(searchText: searchText)
                .receive(on: DispatchQueue.main)
                .sink (receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("Fetch experience details successfully.")
                        break
                    case .failure(let failure):
                        self?.handleError(message: "Failed to search experiences with title: \(failure.localizedDescription)")
                    }
                }, receiveValue: { [weak self] experienceDetails in
                    self?.filteredExperiences = experienceDetails.data
                })
                .store(in: &cancellables)
        } else {
            // Network is offline, filter cached experiences from Core Data
            let recentExperiences = CoreDataManager.shared.fetchRecentExperiences()
            filteredExperiences = recentExperiences.filter { experience in
                experience.title.lowercased().contains(searchText.lowercased())
            }
            print("Offline mode: Filtered experiences from cached data.")
        }
    }

    private func handleError(message: String) {
        self.errorMessage = message
    }
}
