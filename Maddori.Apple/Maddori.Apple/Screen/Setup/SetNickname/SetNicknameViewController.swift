//
//  SetupNicknameViewController.swift
//  Maddori.Apple
//
//  Created by LeeSungHo on 2022/10/20.
//

import UIKit

import Alamofire
import SnapKit

final class SetNicknameViewController: BaseViewController {
    
    // FIXME: - 합류한 팀 이름 받아오기
    var teamName = "맛쟁이사과처럼세글자"
    private let minLength: Int = 0
    private let nicknameMaxLength: Int = 6
    private let roleMaxLength: Int = 20
    
    // MARK: - property
    
    private lazy var backButton: BackButton = {
        let button = BackButton()
        let action = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.setNicknameControllerNavigationTitleLabel
        label.textColor = .black100
        label.font = .label2
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = teamName + TextLiteral.setNicknameControllerTitleLabel
        label.font = .title
        label.textColor = .black100
        label.numberOfLines = 0
        label.setLineSpacingWithColorApplied(amount: 4, colorTo: teamName, with: .blue200)
        return label
    }()
    private lazy var profileImageButton: ProfileImageButton = {
        let button = ProfileImageButton()
        let action = UIAction { [weak self] _ in
            self?.didTappedProfile()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.setNicknameControllerNicknameLabel
        label.textColor = .black100
        label.font = .label2
        label.applyColor(to: "*", with: .red100)
        return label
    }()
    private let nicknameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeHolderText = TextLiteral.setNicknameControllerNicknameTextFieldPlaceHolderText
        return textField
    }()
    private lazy var nicknameTextLimitLabel: UILabel = {
        let label = UILabel()
        label.setTextWithLineHeight(text: "\(minLength)/\(nicknameMaxLength)", lineHeight: 22)
        label.font = .body2
        label.textColor = .gray500
        return label
    }()
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.setNicknameControllerRoleLabel
        label.textColor = .black100
        label.font = .label2
        return label
    }()
    private let roleTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeHolderText = TextLiteral.setNicknameControllerRoleTextFieldPlaceHolderText
        return textField
    }()
    private lazy var roleTextLimitLabel: UILabel = {
        let label = UILabel()
        label.setTextWithLineHeight(text: "\(minLength)/\(roleMaxLength)", lineHeight: 22)
        label.font = .body2
        label.textColor = .gray500
        return label
    }()
    private lazy var doneButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.setNicknameControllerDoneButtonText
        button.isDisabled = true
        let action = UIAction { [weak self] _ in
            guard let nickname = self?.nicknameTextField.text else { return }
            guard let role = self?.roleTextField.text else { return }
            // FIXME: - 수정된 api 연결 (userJoinTeam)
            self?.nicknameTextField.resignFirstResponder()
            self?.roleTextField.resignFirstResponder()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationCenter()
    }
    
    override func render() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(SizeLiteral.topPadding)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.height.equalTo(66.5)
        }
        
        view.addSubview(profileImageButton)
        profileImageButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(68)
        }
        
        view.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(SizeLiteral.labelComponentPadding)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        view.addSubview(nicknameTextLimitLabel)
        nicknameTextLimitLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(27)
        }
        
        view.addSubview(roleLabel)
        roleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(SizeLiteral.componentIntervalPadding)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        view.addSubview(roleTextField)
        roleTextField.snp.makeConstraints {
            $0.top.equalTo(roleLabel.snp.bottom).offset(SizeLiteral.labelComponentPadding)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        view.addSubview(roleTextLimitLabel)
        roleTextLimitLabel.snp.makeConstraints {
            $0.top.equalTo(roleTextField.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(27)
        }
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(2)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        let button = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: button)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.titleView = navigationTitleLabel
        navigationItem.titleView?.isHidden = true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - func
    
    private func didTappedProfile() {
        let actionSheet = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "앨범에서 사진 선택", style: .default) { _ in print("앨범") }
        let cameraAction = UIAlertAction(title: "사진 촬영", style: .default) { _ in print("사진 촬영") }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func setupDelegate() {
        nicknameTextField.delegate = self
        roleTextField.delegate = self
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func endEditingView() {
        if !doneButton.isTouchInside {
            view.endEditing(true)
        }
    }
    
    private func setCounter(textField: UITextField, count: Int) {
        let maxLength = textField == nicknameTextField ? nicknameMaxLength : roleMaxLength
        let textLimitLabel = textField == nicknameTextField ? nicknameTextLimitLabel : roleTextLimitLabel
        if count <= maxLength {
            textLimitLabel.text = "\(count)/\(maxLength)"
        }
        else {
            textLimitLabel.text = "\(maxLength)/\(maxLength)"
        }
    }
    
    private func checkMaxLength(textField: UITextField) {
        let maxLength = textField == nicknameTextField ? nicknameMaxLength : roleMaxLength
        if let text = textField.text {
            if text.count > maxLength {
                let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                let fixedText = text[text.startIndex..<endIndex]
                textField.text = fixedText + " "
                
                DispatchQueue.main.async {
                    textField.text = String(fixedText)
                }
            }
        }
    }
    
    private func didTappedTextField() {
        titleLabel.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        profileImageButton.snp.updateConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(-4)
        }
        navigationItem.titleView?.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowAnimatedContent, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func didTappedBackground() {
        titleLabel.snp.updateConstraints {
            $0.height.equalTo(66.5)
        }
        profileImageButton.snp.updateConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
        }
        navigationItem.titleView?.isHidden = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowAnimatedContent, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - selector
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2, animations: {
                self.doneButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 24)
            })
        }
        
        didTappedTextField()
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.doneButton.transform = .identity
        })
        
        didTappedBackground()
    }
}
    
// MARK: - Extension

extension SetNicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setCounter(textField: textField, count: textField.text?.count ?? 0)
        checkMaxLength(textField: textField)
        
        let hasText = textField.hasText
        doneButton.isDisabled = !hasText
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
