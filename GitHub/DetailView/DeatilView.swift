//
//  DeatilView.swift
//  GitHub
//
//  Created by Le Chris on 21.06.2023.
//

import SwiftUI
import Kingfisher

struct DeatilView: View {
    
    @ObservedObject var viewModel: DetailViewModel
        
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    if let url = URL(string: viewModel.avatarURL) {
                        KFImage(url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 85, height: 85)
                            .clipShape(Circle())
                            .padding(.trailing, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: -5) {
                        Text("@\(viewModel.user)")
                            .font(.system(size: UIFont.preferredFont(forTextStyle: .title1)
                                .pointSize, weight: .bold, design: .default))                            .padding(.trailing, 5)
                        Text("repositories")
                            .font(.system(size: UIFont.preferredFont(forTextStyle: .title1)
                                .pointSize, weight: .ultraLight, design: .default))
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
                .padding(.leading, 35)
                Image("Line")
                    .resizable()
                    .scaledToFit()
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.userRepositories.enumerated()), id: \.offset) { index, user in
                            Button(action: {
                                viewModel.router.showWebView(url: user.htmlURL)
                            }, label: {
                                RepoCell(title: user.name,
                                         description: user.description,
                                         stars: user.stars,
                                         languageName: user.language)
                            })
                            
                            .id(index)
                            .onAppear {
                                Task {
                                    await viewModel.loadUserRepos(index: index)
                                }
                            }
                        }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
            }
        }.navigationBarHidden(false)
    }
}

struct DeatilView_Previews: PreviewProvider {
    static var previews: some View {
        DeatilView(viewModel: DetailViewModel(
            repo: Repository(persistence: Persistence()),
            router: Router(),
            user: "tomtt",
            avatarURL: "https://avatars.githubusercontent.com/u/31?v=4")
        )
    }
}

