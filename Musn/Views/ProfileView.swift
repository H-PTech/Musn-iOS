//
//  ProfileView.swift
//  Musn
//
//  Created by 권민재 on 12/16/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
         
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
            
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(Color.gray.opacity(0.8))
                    .shadow(radius: 4)
                
             
                Text("John Doe")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                
            
                Text("iOS Developer | Music Lover 🎵")
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
        
                HStack(spacing: 20) {
                    Button(action: {
                        print("Edit Profile")
                    }) {
                        Text("Edit Profile")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .padding()
                            .frame(width: 140)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        print("Log Out")
                    }) {
                        Text("Log Out")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(width: 140)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
}
