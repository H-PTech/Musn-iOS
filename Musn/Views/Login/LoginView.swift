//
//  LoginView.swift
//  Musn
//
//  Created by 권민재 on 12/28/24.
//
import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Musn")
                .font(.system(size: 70))
                .fontWeight(.bold)
                .padding(.top, 120)
                .foregroundColor(.green)

            Spacer()

            Button(action: {
                Task {
                    await viewModel.loginWithKakao()
                }
            }) {
                HStack {
                    Image("kakao_login_icon")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("카카오 로그인")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.vertical, 12)
            }
            .frame(height: 48)
            .padding(.horizontal, 40)
            .background(Color(hex: "#FEE500"))
            .cornerRadius(8)

            
            Button(action: {
                googleLogin()
            }) {
                HStack {
                    Image("google_logo_icon")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("Continue with Google")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.vertical, 12)
            }
            .frame(height: 48)
            .padding(.horizontal, 40)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )

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


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    LoginView()
}
