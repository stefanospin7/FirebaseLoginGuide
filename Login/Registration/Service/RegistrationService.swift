//
//  LoginView.swift
//  MyStream
//
//  Created by stefano.spinelli on 26/09/22.
//


import Combine
import Foundation
import Firebase
import FirebaseDatabase



//keys value we need to store in Firebase

enum Gender: String, Identifiable, CaseIterable {
    var id: Self { self }
    case male
    case female
}

struct RegistrationCredentials {
     
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var occupation: String
    var gender: Gender
}

protocol RegistrationService {
    
    //retunr a publisher checking if it has succer or not giving an error
    func register(with credentials: RegistrationCredentials) -> AnyPublisher<Void, Error>
}

enum RegistrationKeys: String {
    case firstName
    case lastName
    case occupation
    case gender
}

final class RegistrationServiceImpl: RegistrationService {
    
    func register(with credentials: RegistrationCredentials) -> AnyPublisher<Void, Error> {
        
        //logic of the publisher
        
        Deferred {

            Future { promise in
                
                Auth.auth().createUser(withEmail: credentials.email,
                                       password: credentials.password) { res, error in
                    
                    if let err = error {
                        
                        //unwrap and receiving Firebase error
                        promise(.failure(err))
                    } else {
                        //in case of success we use Firebase Database to store user data
                        //this works with a dictionary (enum) allowing us to specify the keys
                        
                        //from the results we got from user we can unwrap an user id with a dictionary and user data
                        if let uid = res?.user.uid {
                            
                            let values = [RegistrationKeys.firstName.rawValue: credentials.firstName,
                                          RegistrationKeys.lastName.rawValue: credentials.lastName,
                                          RegistrationKeys.occupation.rawValue: credentials.occupation,
                                          RegistrationKeys.gender.rawValue: credentials.gender.rawValue] as [String : Any]
                            //here we access the database with references to our "tables" with association on uid and credentials
                            Database
                                .database()
                                .reference()
                                .child("users")
                                .child(uid)
                                .updateChildValues(values) { error, ref in
                                    //if there is an error we throw an error
                                    if let err = error {
                                        promise(.failure(err))
                                    } else {
                                        //if there is success we throw back nothing ()
                                        promise(.success(()))
                                    }
                                }
                        }
                    }
                }
            }
        }
        //Receive publisher on main thread
        .receive(on: RunLoop.main)
        //this turn the publisher into a generic publisher
        .eraseToAnyPublisher()
    }
}
