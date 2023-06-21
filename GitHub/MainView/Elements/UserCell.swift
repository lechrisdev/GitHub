//
//  UserCell.swift
//  GitHub
//
//  Created by Le Chris on 20.06.2023.
//

import SwiftUI
import Kingfisher

struct UserCell: View {
    
    let url: String
    let name: String
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            if let url = URL(string: url) {
                KFImage(url)
                    .onFailureImage(KFCrossPlatformImage(named: "DefaultAvatar"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 85, height: 85)
                    .clipShape(Circle())
                    .padding(.trailing, 20)
            }
            Text("@\(name)")
                .foregroundColor(.primary)
                .font(.system(size: 16))
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(url: "https://avatars.githubusercontent.com/u/34?v=4",
                 name: "fvgfgvf")
    }
}
