//
//  InputPasswordView.swift
//  MyStream
//
//  Created by stefano.spinelli on 28/09/22.
//

import SwiftUI

struct InputPasswordView: View {
    
    @Binding var password: String
    let placeholder: String
    let systemImage: String?
    
    private let textFieldLeading: CGFloat = 30
    
    var body: some View {
        
        VStack {
            
            SecureField(placeholder, text: $password)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                       minHeight: 44,
                       alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(.leading, systemImage == nil ? textFieldLeading / 2 : textFieldLeading)
                .background(
                    
                    ZStack(alignment: .leading) {
                        
                        if let systemImage = systemImage {
                            
                            Image(systemName: systemImage)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.leading, 5)
                                .foregroundColor(Color.orange)
                        }
                        
                        RoundedRectangle(cornerRadius: 10,
                                         style: .continuous)
                            .stroke(Color.orange, lineWidth: 1)
                    }
                )
        }
    }
}

struct InputPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        InputPasswordView(password: .constant(""), placeholder: "Password", systemImage: "lock")
    }
}
