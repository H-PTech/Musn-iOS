//
//  SearchView.swift
//  Musn
//
//  Created by 권민재 on 12/16/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    let recentSearches = ["에스파", "Can't Control Myself", "빨간맛", "Spicy"]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("드랍할 음악 검색", text: $searchText)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color(white: 0.15))
                .cornerRadius(10)
                .padding(.horizontal)

                Text("최근 검색어")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.top, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(recentSearches, id: \.self) { search in
                            Text(search)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(white: 0.2))
                                .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)

                Spacer()
                Text("지금 이 주변에")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                    + Text(" 드랍하고 싶은 음악")
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color.green)
                    + Text("은 무엇인가요?")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)

                Spacer()
            }
        }
    }
}

#Preview {
    SearchView()
}
