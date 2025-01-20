//
//  ExperienceLikeView.swift
//  AroundEgypt
//
//  Created by MagyElias on 20/01/2025.
//

import SwiftUI

struct ExperienceLikeView: View {
    @ObservedObject var viewModel: ExperienceLikeViewModel

    var body: some View {
        HStack {
            Text(viewModel.likesNo, format: .number)

            Button(action: {
                viewModel.likeExperience()
            }, label: {
                Image(systemName: viewModel.likeImage)
                    .foregroundColor(.pink)
                    .frame(width: 15, height: 15)
            })
            .disabled(viewModel.isLiked)
        }
    }
}
