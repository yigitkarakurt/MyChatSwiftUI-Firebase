//
//  ChatLogView.swift
//  MyChatSwiftUI-Firebase
//
//  Created by Yigit Karakurt on 13.04.2023.
//

import SwiftUI


struct ChatLogView: View {
    
    let chatUser: ChatUser?
    @State var chatText = ""
    
    var body: some View {
        
        VStack{
            ScrollView {
                ForEach(0..<10) { num in
                    
                    HStack{
                        Spacer()
                        HStack{
                            Text("Fake Message For Now")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.top,8)
                    
                    
                }
                
                HStack{ Spacer()}
                
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            
            HStack(spacing: 16){
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.darkGray))
                TextField("Description" , text: $chatText)
                Button {
                    
                } label: {
                    Text("Send")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.vertical,8)
                .background(Color.blue)
                .cornerRadius(4)
                

            }
            .padding(.horizontal)
            .padding(.vertical,8)
           
        }
        
        .navigationTitle(chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
            
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            ChatLogView(chatUser: .init(data: ["uid" : "nOdbsJXzoFbx8L8ZfUCt5zHOGnn2" ,"email" : "yigit@gmail.com"]))
        }
        
    }
}
