//
//  ContentView.swift
//  GitHub
//
//  Created by Le Chris on 20.06.2023.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State private var isLoading: Bool = true
    @State private var isProgressFinished: Bool = false
    @State private var zoomEffect: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .bottom, spacing: 0) {
                    if colorScheme == .light {
                        Image("Icon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .padding(.trailing, 19)
                    } else {
                        Image("Icon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .padding(.trailing, 19)
                            .colorInvert()
                    }
                    Text("github")
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .title1)
                            .pointSize, weight: .bold, design: .default))
                        .padding(.trailing, 5)
                    Text("users")
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .title1)
                            .pointSize, weight: .ultraLight, design: .default))
                    Spacer()
                }
                .padding(.vertical, 20)
                .padding(.leading, 35)
                Image("Line")
                    .resizable()
                    .scaledToFit()
                ScrollView {
                    LazyVStack {
                        Spacer(minLength: 20)
                        
                        ForEach(Array(viewModel.users.enumerated()), id: \.offset) { index, user in
                            
                            Button(action: {
                                viewModel.router.showDetailViewScreen(user: user.name,
                                                                      avatarURL: user.avatarURL)
                            }, label: {
                                UserCell(url: user.avatarURL, name: user.name)
                                    .padding(.bottom, 20)
                                    .id(index)
                                    .onAppear {
                                        Task {
                                            await viewModel.loadUsersIfNeeded(index: index)
                                        }
                                    }
                            })
                        }
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
                .padding(.leading, 35)
            }.navigationBarHidden(true)
            if isLoading {
                ZStack {
                    Color("BackgroundColor").ignoresSafeArea()
                    VStack(spacing: 35) {
                        if colorScheme == .light {
                            Image("Icon")
                                .resizable()
                                .frame(width: 64, height: 64)
                        } else {
                            Image("Icon")
                                .resizable()
                                .frame(width: 64, height: 64)
                                .colorInvert()
                        }
                        ProgressView(value: isProgressFinished ? 1 : 0)
                            .padding(.horizontal, 35)
                            .frame(maxWidth: 200)
                            .onAppear {
                                DispatchQueue.main.async {
                                    withAnimation(Animation.linear(duration: 1)) {
                                        isProgressFinished = true
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(Animation.linear(duration: 0.3 )) {
                                        zoomEffect = true
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation(Animation.linear(duration: 1)) {
                                        isLoading = false
                                    }
                                }
                            }
                    }
                }.scaleEffect(zoomEffect ? 3 : 1)
                    .opacity(zoomEffect ? 0 : 1)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(repo: Repository(persistence: Persistence()),
                                          router: Router()))
    }
}
