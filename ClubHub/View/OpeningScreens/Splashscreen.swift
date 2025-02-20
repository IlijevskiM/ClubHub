//
//  Splashscreen.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

struct Splashscreen: View {
    //Animation Properties
    @State var showText = false
    @State var rotateAnimation = false
    // show image
    @State var showImage = false
    @State var isFinished = false
    var body: some View {
        // For Safety..
        
        HStack{
            if !isFinished {
                ZStack {
                        ZStack{
                            HStack(spacing: 0){
                                HStack(spacing: 0) {
                                    Text("Club")
                                        .font(.custom("Roboto-Bold", size: 45))
                                        .foregroundColor(.white)
                                    Text("Hub")
                                        .font(.custom("Roboto-Regular", size: 45))
                                        .foregroundColor(.white)
                                }.opacity(showText ? 1 : 0)
                                
                                Image("applogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70, height: 70)
                                    .rotationEffect(rotateAnimation ? Angle(degrees: 360) : Angle(degrees: 0))
                                    .scaleEffect(showImage ? 1 : 0)
                            }
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }.background(Color("darkBlue")).ignoresSafeArea()
                .onAppear{
                    //Delaying .3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        withAnimation(.spring()){
                            showText.toggle()
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        withAnimation(.easeInOut(duration: 1)){
                            rotateAnimation.toggle()
                            showImage.toggle()
                        }
                        
                        //After .5s finishing splashscreen
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                            withAnimation{
                                isFinished.toggle()
                            }
                        }
                    }
                }
            }
        }
    }
}
