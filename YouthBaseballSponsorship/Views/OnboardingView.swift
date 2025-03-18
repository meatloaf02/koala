//
//  OnboardingView.swift
//  YouthBaseballSponsorship
//
//  Created by Marco Siliezar on 3/17/25.
//
import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenWelcomeScreen") private var hasSeenWelcomeScreen: Bool = false
    @State private var currentPage = 0

    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage(image: "sportscourt", title: "Welcome to Youth Baseball Sponsorship", description: "Support young athletes by sponsoring their performance and helping them reach their goals!", tag: 0)
            
            OnboardingPage(image: "star.circle", title: "Performance-Based Sponsorships", description: "Pledge based on stats like home runs, strikeouts, and more!", tag: 1)
            
            OnboardingPage(image: "chart.bar", title: "Track Player Progress", description: "See how your sponsorship helps players improve over time!", tag: 2)

            // Final Screen
            VStack {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.green)
                    .padding()

                Text("You're Ready!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

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
                .padding(.top, 20)
            }
            .tag(3)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle()) // Shows dots at the bottom
    }
}
