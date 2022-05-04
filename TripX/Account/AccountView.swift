//
//  AccountView.swift
//  TripX
//
//  Created by JL on 2022/3/20.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        VStack{
            Text("User Profile").font(.largeTitle).bold()
                .padding(.top, 50)
            
            HStack{
                
                
                VStack(spacing: 0){
                    
                    Rectangle()
                    .fill(Color("Color"))
                    .frame(width: 80, height: 3)
                    .zIndex(1)
                    
                    
                    
                    Image("profile")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.top, 6)
                    .padding(.bottom, 4)
                    .padding(.horizontal, 8)
                    .background(Color("Color1"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                    .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                }
                
                VStack(alignment: .leading, spacing: 12){
                    
                    Text("Zheyong")
                        .font(.title)
                        .foregroundColor(Color.black.opacity(0.8))
                    
                    Text("Undergraduate Student")
                        .foregroundColor(Color.black.opacity(0.7))
                        .padding(.top, 8)
                    
                    Text("zhuzy0330@gmail.com")
                        .foregroundColor(Color.black.opacity(0.7))
                }
                .padding(.leading, 20)
                
                Spacer(minLength: 0)
            }.padding(.top, 80)
        }
            
           
            .padding(.horizontal, 20)
            .padding(.bottom, 400)
            
    }

}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
