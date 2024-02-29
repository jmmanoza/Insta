//
//  LoginViewController.swift
//  Insta
//
//  Created by Hallee Berry Manoza on 2/2/24.
//

import SafariServices
import UIKit

class LoginViewController: UIViewController {
    
    var loginViewModel: LoginViewModel?
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username or Email..."
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.returnKeyType = .done
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        return textField
    }()
    
    private let loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = Constants.cornerRadius
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    private let termsButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.secondaryLabel, for: .normal)
        btn.setTitle("Terms of Service", for: .normal)
        return btn
    }()
    
    private let privacyButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.secondaryLabel, for: .normal)
        btn.setTitle("Privacy Policy", for: .normal)
        return btn
    }()
    
    private let createAccountButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.label, for: .normal)
        btn.setTitle("New User? Create an Account", for: .normal)
        return btn
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        
        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
        view.addSubview(backgroundImageView)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        assignDelegates()
        assignButtonTargets()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupUI()
        configureHeaderView()
    }
}

// MARK - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            didTapLoginButton()
        }
        
        return true
    }
}

// MARK: -
private extension LoginViewController {
    
    private func setupUI() {
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.height/3.0
        )
        
        usernameTextField.frame = CGRect(
            x: 25,
            y: headerView.bottom + 40,
            width: view.width - 50,
            height: 52.0
        )
        
        passwordTextField.frame = CGRect(
            x: 25,
            y: usernameTextField.bottom + 10,
            width: view.width - 50,
            height: 52.0
        )
        
        loginButton.frame = CGRect(
            x: 25,
            y: passwordTextField.bottom + 16,
            width: view.width - 50,
            height: 52.0
        )
        
        createAccountButton.frame = CGRect(
            x: 25,
            y: loginButton.bottom + 10,
            width: view.width - 50,
            height: 52.0
        )
        
        termsButton.frame = CGRect(
            x: 10,
            y: view.height - view.safeAreaInsets.bottom - 100,
            width: view.width - 20,
            height: 50
        )
        
        privacyButton.frame = CGRect(
            x: 10,
            y: view.height - view.safeAreaInsets.bottom - 50,
            width: view.width - 20,
            height: 50
        )
    }
    
    private func addSubViews() {
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(headerView)
    }
    
    private func assignDelegates() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func assignButtonTargets() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
    }
    
    private func configureHeaderView() {
        guard headerView.subviews.count == 1 else {
            return
        }
        
        guard let backgroundView = headerView.subviews.first else {
            return
        }
        
        backgroundView.frame = headerView.bounds
        
        let textImageView = UIImageView(image: UIImage(named: "instaText"))
        headerView.addSubview(textImageView)
        textImageView.contentMode = .scaleAspectFit
        textImageView.frame = CGRect(x: headerView.width/4.0,
                                     y: view.safeAreaInsets.top,
                                     width: headerView.width/2.0,
                                     height: headerView.height - view.safeAreaInsets.top)
    }
}

// MARK: - Buttons Targets
private extension LoginViewController {
    @objc private func didTapLoginButton() {
        passwordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        
        guard let usernameEmail = usernameTextField.text, !usernameEmail.isEmpty,
        let password = passwordTextField.text, !password.isEmpty, password.count >= 8 else {
            return
        }
        
        var username: String?
        var email: String?
        
        // MARK: Login
        if usernameEmail.contains("@"), usernameEmail.contains(".") {
            email = usernameEmail
        } else {
            username = usernameEmail
        }
       
        AuthManager.shared.loginUser(username: username, email: email, password: password) { success in
            DispatchQueue.main.async { [weak self] in
                if success {
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Login Error",
                                                  message: "We were unable to log you in", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func didTapCreateAccountButton() {
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func didTapTermsButton() {
        guard let url = URL(string: "https://help.instagram.com/581066165581870") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapPrivacyButton() {
        guard let url = URL(string: "https://help.instagram.com/155833707900388") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}
