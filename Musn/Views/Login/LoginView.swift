//
//  LoginView.swift
//  Musn
//
//  Created by 권민재 on 12/28/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 20) {
       
            Text("Musn")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 90)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                kakaoLogin()
            }) {
                Image("kakao_login")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .background(Color.clear)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            
            Button(action: {
                googleLogin()
            }) {
                Image("google_login")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .background(Color.clear)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    

    func kakaoLogin() {
        print("Kakao Login Clicked")
       
    }
    
    func googleLogin() {
        print("Google Login Clicked")
        
    }
}

#Preview {
    LoginView()
}
