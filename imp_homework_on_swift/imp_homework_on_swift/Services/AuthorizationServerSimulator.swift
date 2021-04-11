//
//  AuthorizationServerSimulator.swift
//  Simulator to students applications make authorized status with login and password. Freehand. Do not use for judgment
//
//  Created by Alex Orlov on 01.04.2021.
//

import Foundation


private struct AuthorizationMockSimulatorConstants {
    static let usersArrayKey = "AuthorizationMockSimulator.usersArrayKey"
    
    struct Error {
        static let noUser = "Пользователь не найден"
        static let wrongPassword = "Неверный пароль"
        static let changeLogin = "Имя пользователя недоступно"
    }
}

protocol Authorization {
    
    func registerUser(login: String, password: String) -> AuthorizationMockSimulator.LogInAnswer
    func logIn(login: String, password: String) -> AuthorizationMockSimulator.LogInAnswer
    func getProfile(token: String) -> AuthorizationMockSimulator.ProfileAnswer?
    @discardableResult
    func postPrefferedColor(token: String, color: AuthorizationMockSimulator.ApplicationUserPrefferedColor) -> AuthorizationMockSimulator.CommonAnswer
    @discardableResult
    func postUserImage(token: String,
                       base64: String) -> AuthorizationMockSimulator.CommonAnswer
    func revoke() -> AuthorizationMockSimulator.CommonAnswer
}

class AuthorizationMockSimulator: Authorization {
    
    struct CommonAnswer {
        
        let result: Bool
        let error: String?
    }
    
    struct ProfileAnswer {
        
        let result: Bool
        let user: ApplicationUser?
        let error: String?
    }
    
    struct LogInAnswer {
        
        let result: Bool
        let token: String?
        let error: String?
    }
    
    struct ApplicationUserPrefferedColor: Equatable, Codable {
        let green: Double
        let red: Double
        let blue: Double
    }
    
    struct ApplicationUser: Equatable, Codable {
        let token: String
        let registrationDate: Date
        var login: String
        var password: String
        var photo: String?
        var prefferedColor: ApplicationUserPrefferedColor?
    }
    
    func registerUser(login: String, password: String) -> LogInAnswer {
        
        var localSavedUsersArray = usersArray()
        if localSavedUsersArray == nil {
            localSavedUsersArray = []
        }
        
        if localSavedUsersArray?.first(where: { (savedUser) -> Bool in
            return savedUser.login.uppercased() == login.uppercased()
        }) != nil {
            
            return LogInAnswer(result: false,
                               token: nil,
                               error: AuthorizationMockSimulatorConstants.Error.changeLogin)
        }
        
        let token = UUID().uuidString
        let user = ApplicationUser(token: token,
                                   registrationDate: Date(),
                                   login: login,
                                   password: password,
                                   photo: nil,
                                   prefferedColor: nil)
        localSavedUsersArray?.append(user)
        save(localSavedUsersArray ?? [])
        
        return LogInAnswer.init(result: true,
                                token: token,
                                error: nil)
    }
    
    func logIn(login: String, password: String) -> LogInAnswer {
        
        guard let localSavedUsersArray = usersArray(),
              let user = localSavedUsersArray.first(where: { (savedUser) -> Bool in
            
                return savedUser.login.uppercased() == login.uppercased()
        })
        else {
            return LogInAnswer(result: false,
                               token: nil,
                               error: AuthorizationMockSimulatorConstants.Error.noUser)
        }
        
        if user.password != password {
            
            return LogInAnswer(result: false,
                               token: nil,
                               error: AuthorizationMockSimulatorConstants.Error.wrongPassword)
        }
        
        return LogInAnswer(result: true,
                           token: user.token,
                           error: nil)
    }
    
    func getProfile(token: String) -> ProfileAnswer? {
        
        guard let user = userByToken(token)
        else {
            return ProfileAnswer(result: false,
                                 user: nil,
                                 error: AuthorizationMockSimulatorConstants.Error.noUser)
        }
        
        return ProfileAnswer(result: true,
                             user: user,
                             error: nil)
    }
    
    @discardableResult
    func postPrefferedColor(token: String,
                            color: ApplicationUserPrefferedColor) -> CommonAnswer {
        guard var usersArrayToChange = usersArray(),
              var user = userByToken(token)
        else {
            return CommonAnswer(result: false,
                                error: AuthorizationMockSimulatorConstants.Error.noUser)
        }
        
        usersArrayToChange.removeAll(where: { (arrayUser) -> Bool in
            arrayUser == user
        })
        user.prefferedColor = color
        usersArrayToChange.append(user)
        save(usersArrayToChange)
        return CommonAnswer(result: true, error: nil)
    }
    
    @discardableResult
    func postUserImage(token: String,
                       base64: String) -> CommonAnswer {
        guard var usersArrayToChange = usersArray(),
              var user = userByToken(token)
        else {
            return CommonAnswer(result: false,
                                error: AuthorizationMockSimulatorConstants.Error.noUser)
        }
        
        usersArrayToChange.removeAll(where: { (arrayUser) -> Bool in
            arrayUser == user
        })
        user.photo = base64
        usersArrayToChange.append(user)
        save(usersArrayToChange)
        return CommonAnswer(result: true, error: nil)
    }
    
    func revoke() -> CommonAnswer {
        save([])
        return CommonAnswer(result: true, error: nil)
    }
    
    private func userByToken(_ token: String) -> ApplicationUser? {
        
        let localSavedUsersArray = usersArray()
        return localSavedUsersArray?.first(where: { (savedUser) -> Bool in
            
            return savedUser.token == token
        })
    }
    
    private func usersArray() -> [ApplicationUser]? {
        
        guard let data = UserDefaults.standard.data(forKey: AuthorizationMockSimulatorConstants.usersArrayKey)
        else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let decodedArray = try decoder.decode([ApplicationUser].self, from: data)
            return decodedArray
        } catch {
            print("\(Self.self) can not decode dataObjects")
        }
        return nil
    }
    
    private func save(_ array: [ApplicationUser]) {
        
        let encoder = JSONEncoder()
        do {
            let encodedArray = try encoder.encode(array)
            UserDefaults.standard.set(encodedArray, forKey: AuthorizationMockSimulatorConstants.usersArrayKey)
        } catch {
            print("\(Self.self) can not save dataObjects")
        }
    }
}
