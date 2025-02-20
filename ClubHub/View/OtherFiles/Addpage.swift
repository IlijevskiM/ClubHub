//
//  AddPage.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct Addpage: View {
    
    @State var chipSelected = false
    let columns = [
            GridItem(.flexible(minimum: 2, maximum: 2), spacing: 5),
            GridItem(.flexible(minimum: 2, maximum: 2), spacing: 5),
        ]
    
    var body: some View {
        
        VStack {
            
            Divider()
            
            //Spacer()
            
            ScrollView(.vertical, showsIndicators: false) {
                  
                    Button {
                        self.chipSelected.toggle()
                    } label: {
                        
                    // Option chips
                    LazyVGrid(columns: columns, spacing: 10) {
                        
                        //ForEach(chips, id: \.self) { chip in
                            
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(chipSelected ? Color("blue") : Color.gray , lineWidth: 1)
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 100)
                                
                            
                                Text("National Honors Society")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.leading)
                                    .padding(10)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                
                                
                                Image(systemName: chipSelected ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 22))
                                    .scaleEffect(chipSelected ? 1.05 : 1.0)
                                    .foregroundColor(chipSelected ? Color("blue") : Color.white)
                                    .padding(.trailing,10)
                                    .padding(.top,10)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            chipSelected.toggle()
                                        }
                                    }
                                
                            }
                        //}.padding(.top,5)
                    }
                }
            }
        }
    }
}
