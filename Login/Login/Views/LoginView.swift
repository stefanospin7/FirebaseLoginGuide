//
//  LoginView.swift
//  MyStream
//
//  Created by stefano.spinelli on 26/09/22.
//


import SwiftUI

struct LoginView: View {
    
    @State private var showRegistration = false
    @State private var showForgotPassword = false
    
    @StateObject private var viewModel = LoginViewModelImpl(
        service: LoginServiceImpl()
    )
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(gradient: gradient, startPoint: .bottomTrailing, endPoint: .topLeading))
                .opacity(0.09)
                .shadow(color: .black, radius: 0.5
                        , x: 2, y: 2)
              
                .padding()
            
            VStack(spacing: 16) {
                
                Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.orange)
                            .padding()
                            .fontWeight(.ultraLight)
                            .shadow(color: .black, radius: 0.5
                                    , x: 2, y: 2)
                
                
                
                VStack(spacing: 16) {
                    
                    InputTextFieldView(text: $viewModel.credentials.email,
                                       placeholder: "Email",
                                       keyboardType: .emailAddress,
                                       systemImage: "envelope")
                  
                    
                    InputPasswordView(password: $viewModel.credentials.password,
                                      placeholder: "Password",
                                      systemImage: "lock")
                  
                }
                .padding()
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        showForgotPassword.toggle()
//                    }, label: {
//                        Text("Forgot Password?")
//                    })
//                    .font(.system(size: 16, weight: .bold))
//                    .sheet(isPresented: $showForgotPassword) {
//                            ForgotPasswordView()
//                    }
//                }
                
                Divider()
                    .padding()
                
                VStack(spacing: 16) {
                    
                    ButtonView(title: "Login",background: .orange,foreground: .black) {
                        viewModel.login()
                    }
                    
                    ButtonView(title: "Register",
                               background: .clear,
                               foreground: .black,
                               border: .orange) {
                        showRegistration.toggle()
                    }
                    .sheet(isPresented: $showRegistration) {
                            RegisterView()
                    }
                }.padding()
            }
            .padding(.horizontal, 15)
            .navigationTitle("Login")
            .alert(isPresented: $viewModel.hasError,
                   content: {
                    
                    if case .failed(let error) = viewModel.state {
                        return Alert(
                            title: Text("Error"),
                            message: Text(error.localizedDescription))
                    } else {
                        return Alert(
                            title: Text("Error"),
                            message: Text("Something went wrong"))
                    }
        })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
