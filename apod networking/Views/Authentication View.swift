//
//  Authentication View.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//
import SwiftUI


struct AuthenticationView: View {
    
    @State var emailAddress = ""
    @State var password = ""
   
    var showChevron:Bool
    
    @EnvironmentObject var users: UsersController
    @EnvironmentObject var activeUser: ActiveUserController
    
    @State var passwordIssue = false
    @State var Login = false
    @State var notAUser = false
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        
        NavigationView{
            ZStack{
//                LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.red]), startPoint: .top, endPoint: .bottom)
                Color.secondary
                
                VStack{
                    Image(systemName: activeUser.chevronTitle).resizable()
                                                              .opacity(showChevron ? 1.0 : 0.0 )
                                                              .frame(width:30, height: 20)
                                                              .foregroundColor(Color.black.opacity(1.0))
                        
                        
                    
                    Spacer()
                    
                    if notAUser {
                        Text("Email not registered").foregroundColor(.red)
                    }
                    
                    VStack(alignment:.leading, spacing:0){
                                        Text("Enter Email-address")
                                        TextField("email address", text: $emailAddress)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .keyboardType(.alphabet)
                                }
                    
                    VStack(alignment:.leading, spacing:0){
                        
                                        HStack{   Text("Enter Password")
                                            if passwordIssue{
                                                Text("password not correct").foregroundColor(.red)
                                                }
                                            }
                        
                                        SecureField("password", text: $password)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                    VStack{
                        Button{
                            refreshed()
                            tryLogin()
                        }
                        label:{
                            Text("LOGIN")
                        }
                    }.padding(.bottom, 20)
                    
                    
                    Spacer()
                    
                    Text ("Not a user yet?").font(.title)
                        .padding(.bottom)
                    
                    NavigationLink(destination: SignUpView()){
                        
                        VStack{
                            Text("SIGN UP").font(.title3)
                                .foregroundColor(.white)
                          }
                    }
                    
                   Spacer()
                }
            }.navigationTitle("LOGIN")
             .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    func tryLogin () {
        
        for user in users.allUsers {
            
            if user.emailAddress == emailAddress {
                
                guard user.password == password else {
                    passwordIssue = true
                    return
                }
                activeUser.setUserIsActive(value: true)
                activeUser.activeUser = user
                activeUser.saveActiveUserInfo()
                activeUser.favoritesApod()
                Login = true
                dismiss()
                return
            }
        }
       
        notAUser = true
        return
    }
    
    func refreshed () {
        passwordIssue = false
        Login = false
        notAUser = false
    }
    
}






struct SignUpView: View {
    
   
    
    @State var registeringuser = registeringUser.model
    @State var SignUp = false
    
    @State var invalidEmail = false
    @State var choosenUsername = false
    @State var passwordNotEqual = false
    @State var blankField = false
    
    @EnvironmentObject var users: UsersController
    
    var body: some View {
        
        VStack {
            
            VStack(alignment:.leading, spacing:0) {
                
                            Text("First Name")
                TextField("input first name", text: $registeringuser.firstName)
                                                                               .textFieldStyle(RoundedBorderTextFieldStyle())
                                                                               .keyboardType(.alphabet)
            }
            
            VStack(alignment:.leading, spacing:0){
                
                            Text("Last Name")
                TextField("input last name", text: $registeringuser.lastName)
                                                                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                                                                            .keyboardType(.alphabet)
                            }
            
            VStack(alignment:.leading, spacing:0){
                            HStack{ Text("UserName")
                                        if choosenUsername{
                                    Text("username not available, kindly choose a unique username").foregroundColor(.blue)
                                    }
                                 }
                
                TextField("choose a unique username", text: $registeringuser.userName)
                                                                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                                                                            .keyboardType(.asciiCapable)
                                                                            }
            
            VStack(alignment:.leading, spacing:0){
                            HStack{ Text("Email Address")
                                        if invalidEmail {
                                    Text("Email is registered already, try logging in").foregroundColor(.red)
                                    }
                                }
                
                TextField("imput your email address", text: $registeringuser.emailAddress )
                                                                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                                                                            .keyboardType(.emailAddress)
                            }
            
            VStack(alignment:.leading, spacing:0){
                            HStack{ Text("Password")
                                        if passwordNotEqual{
                                    Text("passwords do not match").foregroundColor(.red)
                                    }
                                  }
                
                TextField("choose password", text: $registeringuser.password)
                                                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                                                            .textContentType(.newPassword)
                            }
            
            VStack(alignment:.leading, spacing:0){
                            HStack{ Text("Confirm Password")
                                        if passwordNotEqual{
                                    Text("password does not match").foregroundColor(.red)
                                    }
                                  }
                
                TextField("confirm your password", text: $registeringuser.confirmPassword)
                                                                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                                                                            .textContentType(.newPassword)
                            }
            
            Button{
                refreshed()
                tryUserSignUp()
            }
                label:{
                    Text("SIGN UP")
                }
            
        }.navigationTitle("SIGN UP")
    }
    
    
    
    
    func tryUserSignUp () {
      
        guard (!registeringuser.emailAddress.isEmpty && !registeringuser.userName.isEmpty && !registeringuser.firstName.isEmpty && !registeringuser.lastName.isEmpty) else {
            blankField = true
            return
        }
        
        for user in users.allUsers {
            
            if user.emailAddress == registeringuser.emailAddress {
                invalidEmail = true
                return
            }
            
            if user.userName == registeringuser.userName {
                choosenUsername = true
                return
            }
        }
        
        guard registeringuser.password == registeringuser.confirmPassword  else {
            passwordNotEqual = true
            return
        }
        
        users.createUser(firstName: registeringuser.firstName, lastName: registeringuser.lastName, userName: registeringuser.userName, emailAddress: registeringuser.emailAddress, password: registeringuser.password)
        
        registeringuser.firstName = ""
        registeringuser.lastName = ""
        registeringuser.userName = ""
        registeringuser.emailAddress = ""
        registeringuser.password = ""
        registeringuser.confirmPassword = ""
        
        SignUp = true
    }
    
    
    func refreshed () {
        
        invalidEmail = false
        choosenUsername = false
        passwordNotEqual = false
        blankField = false
    }
    
}
