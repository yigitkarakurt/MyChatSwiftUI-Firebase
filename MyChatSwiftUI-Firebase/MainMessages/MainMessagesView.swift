//
//  MainMessagesView.swift
//  MyChatSwiftUI-Firebase
//
//  Created by Yigit Karakurt on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class MainMessagesViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    @Published var chatUser : ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    
    init(){
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        
        fetchRecentMessages()
    }
    
    @Published var recentMessages = [RecentMessage]()
    
    private func fetchRecentMessages(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error =  error {
                    self.errorMessage = "Faield to listen for recent messages: \(error.localizedDescription)"
                    print(error.localizedDescription)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }){
                        self.recentMessages.remove(at: index)
                        
                    }
                    do{
                        if let rm = try? change.document.data(as: RecentMessage.self){
                            self.recentMessages.insert(rm, at: 0)
                            
                        }
                    }catch{
                        print(error)
                    }
                                              
                })
            }
    }
    
    func fetchCurrentUser(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            self.errorMessage = "Could not find firebase uid"
            return
            
        }
        
        self.errorMessage = "\(uid)"
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user: ", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No Data Found"
                return}
            
            self.chatUser = .init(data: data)
        }
    }
    
    func handleSignOut(){
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
        
    }
}

struct MainMessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    @State var shouldNavigateToChatLogView = false
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack{
                customNavBar
                messageView
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView, destination: {
                    ChatLogView(chatUser: self.chatUser)
                })
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16){
            
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(Color(.label), lineWidth : 1)
                )
                .shadow(radius: 5)
            
            //Image(systemName: "person.fill")
             //   .font(.system(size: 34,weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                
                Text(email.capitalized)
                    .font(.system(size: 24,weight: .bold))
                    
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14,height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                
            }
            Spacer()
            
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }

            
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                }),
                    .cancel()
            ])
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(didCompleteLoginProcess:     {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }
    }

    func elapsedTimeString(for date: Date) -> String {
        let secondsElapsed = Int(Date().timeIntervalSince(date))
        
        if secondsElapsed < 60 {
            return "Just Now"
        }
        else if secondsElapsed < 3600 {
            let minutes = secondsElapsed / 60
            return "\(minutes)m"
        }
        else if secondsElapsed < 86400 {
            let hours = secondsElapsed / 3600
            return "\(hours)h"
        }
        else {
            let days = secondsElapsed / 86400
            return "\(days)d"
        }
    }
 
    private var messageView: some View{
        ScrollView {
            ForEach(vm.recentMessages){ recentMessage in
                VStack{
                    NavigationLink {
                        Text("Destination")
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: recentMessage.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipped()
                                .cornerRadius(64)
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                    .stroke(Color(.label), lineWidth : 1)
                                )
                                .shadow(radius: 5)
                            
                            VStack(alignment: .leading){
                                Text(recentMessage.email.replacingOccurrences(of: "@gmail.com", with: "").capitalized )
                                    .font(.system(size: 16,weight: .bold))
                                    .foregroundColor(Color(.label))
                                    .multilineTextAlignment(.leading)
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(.leading)
                            
                            }
                            Spacer()
                            
                            Text(elapsedTimeString(for: recentMessage.timestamp))
                                .font(.system(size: 14,weight: .semibold))
                        }
                    }

                    
                    Divider()
                        .padding(.vertical,8)
                }.padding(.horizontal)
            }.padding(.bottom, 50)
        }
    }
    
    
    @State var shouldShowNewMessageScreen = false
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack{
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
                
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            CreateNewMessageView(didSelectNewUser: { user in
                print(user.email)
                self.shouldNavigateToChatLogView.toggle()
                self.chatUser = user
            })
            
        }
    }
    
    @State var chatUser: ChatUser?
}


struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            
    }
}
