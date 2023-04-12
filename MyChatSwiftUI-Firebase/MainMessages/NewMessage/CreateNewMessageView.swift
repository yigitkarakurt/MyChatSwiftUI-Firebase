//
//  CreateNewMessageView.swift
//  MyChatSwiftUI-Firebase
//
//  Created by Yigit Karakurt on 12.04.2023.
//

import SwiftUI

class CreateNewMessageViewModel: ObservableObject{
    
    @Published var users = [ChatUser]()
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers(){
        
    }
}

struct CreateNewMessageView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(0..<10){ num in
                    Text("New User")
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        }label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
