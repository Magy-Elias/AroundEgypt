//
//  ExperienceImageView.swift
//  AroundEgypt
//
//  Created by MagyElias on 19/01/2025.
//

import SwiftUI

struct ExperienceImageView: View {
    var image: UIImage
    var viewCount: Int
    
    var body: some View {
        ZStack {
            // Display the image
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipped()
            
            // Eye icon overlay with the view count
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Image(systemName: "eye.fill")
                        .foregroundColor(.white)
                        .frame(width: 15, height: 15)
                    
                    Text("\(viewCount) views")
                        .foregroundColor(.white)
                }
                .padding(16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
