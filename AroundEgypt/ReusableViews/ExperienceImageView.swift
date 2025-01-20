//
//  ExperienceImageView.swift
//  AroundEgypt
//
//  Created by MagyElias on 19/01/2025.
//

import SwiftUI
import Kingfisher

struct ExperienceImageView: View {
    var imageURL: String // URL to the image
    var viewCount: Int
    var showViewTitle: Bool
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Use Kingfisher to load the image asynchronously
            KFImage(URL(string: imageURL))
                .placeholder {
                    ProgressView() // Placeholder while the image loads
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .cacheOriginalImage() // Cache the original image for future use
                .resizable()
                .scaledToFill()
                .clipped()
            
            // Eye icon overlay with the view count
            HStack {
                Image(systemName: "eye.fill")
                    .foregroundColor(.white)
                    .frame(width: 15, height: 15)
                
                Text("\(viewCount)\(showViewTitle ? " views" : "")")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding([.leading, .bottom], 16)
        }
    }
}
