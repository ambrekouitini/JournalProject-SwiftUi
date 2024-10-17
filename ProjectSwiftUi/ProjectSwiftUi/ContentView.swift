//
//  ContentView.swift
//  ProjectSwiftUi
//
//  Created by KOUITINI Ambre on 16/10/2024.
//
import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    
    let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.15)
    let surfaceColor = Color(red: 0.15, green: 0.15, blue: 0.2)
    let accentColor = Color(red: 0.6, green: 0.8, blue: 0.8)
    let textColor = Color.white
    
    var body: some View {
        NavigationView {
            if isLoggedIn {
                RootView()
            } else {
                ZStack {
                    backgroundColor.edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 25) {
                        Spacer()
                        
                        Text("Connexion 😊")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(textColor)
                        
                        VStack(spacing: 20) {
                            CustomTextField(placeholder: "Nom d'utilisateur", text: $username, imageName: "person")
                            CustomTextField(placeholder: "Mot de passe", text: $password, imageName: "lock", isSecure: true)
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: {
                            if username == "Root" && password == "Root" {
                                isLoggedIn = true
                            } else {
                                showAlert = true
                            }
                        }) {
                            Text("Se connecter")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(accentColor)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    .padding()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Erreur"), message: Text("Identifiants incorrects"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let imageName: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.gray)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .accentColor(.white)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.white.opacity(0.7))
                    }
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .accentColor(.white)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.white.opacity(0.7))
                    }
            }
        }
        .padding(.horizontal)
        .frame(height: 55)
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
