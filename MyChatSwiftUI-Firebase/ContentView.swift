//
//  ContentView.swift
//  MyChatSwiftUI-Firebase
//
//  Created by Yigit Karakurt on 7.04.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                VStack{
                    
                    
                    Picker(selection: $isLoginMode, label: Text("Picker ere")) {
                        
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 64))
                            .padding()
                        
                    }
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.none)
                    SecureField("Password", text: $password)
                    
                    Button{
                        
                    }label: {
                        HStack{
                            Spacer()
                            Text("Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical,10)
                            Spacer()
                        }.background(Color.blue)
                        
                    }
                }.padding()
                
                
            }
            .navigationTitle("Create Account")
            
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
