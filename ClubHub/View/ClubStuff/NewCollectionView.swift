//
//  NewCollectionView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/18/23.
//

import SwiftUI

struct NewCollectionView: View {
    @State var addCollection = false
    @State var newCollectionName = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Button {
                    self.addCollection.toggle()
                } label: {
                    Text("Cancel")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.black)
                }
                Spacer()
                Text("New Collection")
                    .font(.custom("Roboto-Medium", size: 18))
                    .foregroundColor(.black)
                    .padding(.leading,-3)
                Spacer()
                Button {
                    self.addCollection.toggle()
                } label: {
                    Text("Done")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(newCollectionName != "" ? Color("darkBlue") : .gray)
                }
            }.padding(.horizontal, 15)
            Divider()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Name")
                    .font(.custom("Roboto-Medium", size: 16))
                    .foregroundColor(.black)
                
                TextField("Collection Name", text: $newCollectionName)
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.black)
                
                HStack(spacing: 5) {
                    Image("plus")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.blue)
                    
                    Text("Add file")
                        .font(.custom("Roboto-Regular", size: 16))
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }.padding(.horizontal, 15)
        }.padding(.top,10)
    }
}
