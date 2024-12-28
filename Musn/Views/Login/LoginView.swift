//
//  LoginView.swift
//  Musn
//
//  Created by 권민재 on 12/28/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Musn")
                .font(Font.system(size: 42,weight: .bold))
                .padding(.top, 40)
            Spacer()
        }
        .ignoresSafeArea(.all)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    LoginView()
}
