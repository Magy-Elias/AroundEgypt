//
//  ExperienceLikeViewModel.swift
//  AroundEgypt
//
//  Created by moweex on 20/01/2025.
//

import Foundation
import Combine

class ExperienceLikeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let apiService = ApiService()
    private let experienceId: String

    @Published var likesNo: Int
    @Published var isLiked: Bool = false
    @Published var likeImage: String
    @Published var errorMessage: String?

    init(experienceId: String, likesNo: Int) {
        self.experienceId = experienceId
        self.likesNo = likesNo
        self.likeImage = "heart"
    }

    func likeExperience() {
        guard !isLiked else { return } // Avoid multiple likes
        apiService.likeExperience(id: experienceId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Like experience successfully.")
                    break
                case .failure(let failure):
                    print("Failed to like experience: \(failure.localizedDescription)")
                }
            }, receiveValue: { [weak self] likesResponse in
                self?.likesNo = likesResponse.data
                self?.likeImage = "heart.fill"
                self?.isLiked = true
            })
            .store(in: &cancellables) // Store the subscription
    }
}
