//
//  NavigationCloseVewModifier.swift
//  MyStream
//
//  Created by stefano.spinelli on 27/09/22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Combine



//the service (protocol) will handle the firebase auth session, to check the change on auth state (logged in or logged out)

enum SessionState {
    case loggedIn
    case loggedOut
}

struct UserSessionDetails {
    let firstName: String
    let lastName: String
    let occupation: String
    let gender: String
}

protocol SessionService {
    
    //actual state of the session
    var state: SessionState { get }
    var userDetails: UserSessionDetails? { get }
    init()
    func logout()
}



//this is used to switch from the loggen in view to the logout view and so on

final class SessionServiceImpl: SessionService, ObservableObject {
    
    
    //this need to be published so the listener
    //could monitoring them in the view
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: UserSessionDetails?
    
    
    //this is needed if the Auth data object has some changes and it needs FireBaseAuth
    private var handler: AuthStateDidChangeListenerHandle?
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        setupObservations()
    }
            
    deinit {
        guard let handler = handler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
        print("deinit SessionServiceImpl")
    }
    
    func logout() {
        
        //it's optional this way if it fails it remains nil and the app doesn't crash
        
        try? Auth.auth().signOut()
    }
}

private extension SessionServiceImpl {
    
    func setupObservations() {
        
        handler = Auth
            .auth()
            .addStateDidChangeListener { [weak self] _,_ in
                guard let self = self else { return }
                
                let currentUser = Auth.auth().currentUser
                self.state = currentUser == nil ? .loggedOut : .loggedIn
                
                if let uid = currentUser?.uid {
                    
                    Database
                        .database()
                        .reference()
                        .child("users")
                        .child(uid)
                        .observe(.value) { [weak self] snapshot in
                            
                            guard let self = self,
                                  let value = snapshot.value as? NSDictionary,
                                  let firstName = value[RegistrationKeys.firstName.rawValue] as? String,
                                  let lastName = value[RegistrationKeys.lastName.rawValue] as? String,
                                  let occupation = value[RegistrationKeys.occupation.rawValue] as? String,
                                  let gender = value[RegistrationKeys.gender.rawValue] as? String else {
                                return
                            }

                            DispatchQueue.main.async {
                                self.userDetails = UserSessionDetails(firstName: firstName,
                                                                      lastName: lastName,
                                                                      occupation: occupation,
                                                                      gender: gender)
                            }
                        }
                }
            }
    }
}
