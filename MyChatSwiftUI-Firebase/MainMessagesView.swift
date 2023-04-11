//
//  MainMessagesView.swift
//  MyChatSwiftUI-Firebase
//
//  Created by Yigit Karakurt on 11.04.2023.
//

import SwiftUI

struct MainMessagesView: View {
    var body: some View {
        NavigationView {
            //custom nav bar
            
            VStack{
                Text("Custom nav bar")
                ScrollView {
                    ForEach(0..<10, id: \.self){ num in
                        
                        VStack{
                            HStack(spacing: 16) {
                                Image(systemName: "person.fill")
                                    .font(.system(size : 32))
                                    
                                
                                VStack(alignment: .leading){
                                    Text("User Name")
                                    Text("Message sent to user")
                                    
                                
                                }
                                Spacer()
                                
                                Text("22d")
                                    .font(.system(size: 14,weight: .semibold))
                            }
                            Divider()
                        }.padding(.horizontal)
                        
                    }
                }
            }
            
            .navigationBarHidden(true)
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
