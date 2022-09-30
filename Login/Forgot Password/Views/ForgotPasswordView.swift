//
//  LoginView.swift
//  MyStream
//
//  Created by stefano.spinelli on 26/09/22.
//


import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var viewModel = ForgotPasswordViewModelImpl(
        service: ForgotPasswordServiceImpl()
    )
    
    var body: some View {
            VStack(spacing: 16) {
            
                InputTextFieldView(text: $viewModel.email,
                                   placeholder: "Email",
                                   keyboardType: .emailAddress,
                                   systemImage: "envelope")
                
                ButtonView(title: "Send Password Reset") {
                    viewModel.sendPasswordResetRequest()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal, 15)
            .navigationTitle("Reset Password")
            .applyClose()
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
