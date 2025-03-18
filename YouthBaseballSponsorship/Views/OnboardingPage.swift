//
//  OnboardingPage.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/17/25.
//
import SwiftUI

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String
    let tag: Int

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.blue)

            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .tag(tag)
    }
}
