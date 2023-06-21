//
//  RepoCell.swift
//  GitHub
//
//  Created by Le Chris on 21.06.2023.
//

import SwiftUI

struct RepoCell: View {
    
    let title: String
    let description: String?
    let stars: Int
    let languageName: String?
    
    func randomColor(seed: String) -> Color {
        
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(UInt32(u))
        }
        
        srand48(total * 200)
        let r = CGFloat(drand48())
        
        srand48(total)
        let g = CGFloat(drand48())
        
        srand48(total / 200)
        let b = CGFloat(drand48())
        
        return Color(uiColor: UIColor(red: r, green: g, blue: b, alpha: 1))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(.bottom, 11)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                if let description {
                    Text(description)
                        .font(.system(size: 16))
                        .padding(.bottom, 11)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .opacity(0.5)
                }
                HStack(spacing: 0) {
                    Image("Star")
                        .renderingMode(.template)
                        .opacity(0.5)
                        .foregroundColor(.primary)
                        .padding(.trailing, 5)
                    Text(String(stars))
                        .font(.system(size: 16))
                        .opacity(0.5)
                        .foregroundColor(.primary)
                        .padding(.trailing, 16)
                    if let languageName {
                        Circle()
                            .frame(height: 11)
                            .foregroundColor(randomColor(seed: languageName))
                            .padding(.trailing, 6)
                        Text(languageName)
                            .foregroundColor(.primary)
                            .font(.system(size: 16))
                            .opacity(0.5)
                    }
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 35)
            Divider()
        }
    }
}

struct RepoCell_Previews: PreviewProvider {
    static var previews: some View {
        RepoCell(title: "30daysoflaptops.github.io",
                 description: "Destroy your Atom editor, Asteroids style!",
                 stars: 12,
                 languageName: "Swift")
    }
}
