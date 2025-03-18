//
//  WelcomeView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/17/25.
//
import SwiftUI

struct WelcomeView: View {
    @AppStorage("hasSeenWelcomeScreen") private var hasSeenWelcomeScreen: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Welcome to Youth Baseball Sponsorship")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            Text("Support young athletes by sponsoring their performance and helping them reach their goals!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Image(systemName: "sportscourt")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.blue)
            
            Spacer()
            
            Button(action: {
                hasSeenWelcomeScreen = true
            }) {
                Text("Get Started")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
    }
}
