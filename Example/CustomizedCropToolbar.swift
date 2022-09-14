//
//  CustomizedCropToolBar.swift
//  MantisExample
//
//  Created by Echo on 4/26/20.
//  Copyright © 2020 Echo. All rights reserved.
//

import UIKit
import Mantis

class CustomizedCropToolbar: UIView, CropToolbarProtocol {
    var iconProvider: CropToolbarIconProvider?
    
    weak var cropToolbarDelegate: CropToolbarDelegate?
    
    private (set)var config: CropToolbarConfigProtocol?
    
    private var fixedRatioSettingButton: UIButton?
    private var cropButton: UIButton?
    private var cancelButton: UIButton?
    private var stackView: UIStackView?
    
    var custom: ((Double) -> Void)?
    
    func createToolbarUI(config: CropToolbarConfigProtocol?) {
        self.config = config
        
        guard let config = config else {
            return
        }
        
        backgroundColor = config.backgroundColor
        
        cropButton = createOptionButton(withTitle: "Crop", andAction: #selector(crop))
        cancelButton = createOptionButton(withTitle: "Cancel", andAction: #selector(cancel))
        fixedRatioSettingButton = createOptionButton(withTitle: "Ratio", andAction: #selector(showRatioList))
        stackView = UIStackView()
        addSubview(stackView!)
        
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        stackView?.alignment = .center
        stackView?.distribution = .fillEqually
        
        stackView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        stackView?.addArrangedSubview(cancelButton!)
        stackView?.addArrangedSubview(fixedRatioSettingButton!)
        stackView?.addArrangedSubview(cropButton!)
    }

    public func handleFixedRatioSetted(ratio: Double) {
        fixedRatioSettingButton?.setTitleColor(.blue, for: .normal)
        fixedRatioSettingButton?.setTitle("Unlock", for: .normal)
    }
    
    public func handleFixedRatioUnSetted() {
        fixedRatioSettingButton?.setTitleColor(.white, for: .normal)
        fixedRatioSettingButton?.setTitle("Ratio", for: .normal)
    }
    
    func adjustLayoutWhenOrientationChange() {
        if Orientation.isPortrait {
            stackView?.axis = .horizontal
        } else {
            stackView?.axis = .vertical
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        guard let config = config else {
            return superSize
        }
        
        if Orientation.isPortrait {
            return CGSize(width: superSize.width, height: config.heightForVerticalOrientation)
        } else {
            return CGSize(width: config.widthForHorizontalOrientation, height: superSize.height)
        }
    }

    func getRatioListPresentSourceView() -> UIView? {
        return fixedRatioSettingButton
    }
            
    @objc private func crop() {
        cropToolbarDelegate?.didSelectCrop()
    }
    
    @objc private func cancel() {
        cropToolbarDelegate?.didSelectCancel()
    }
    
    @objc private func showRatioList() {
        cropToolbarDelegate?.didSelectSetRatio()
    }
    
    private func createOptionButton(withTitle title: String?, andAction action: Selector) -> UIButton {
        guard let config = config else {
            return UIButton()
        }

        let buttonColor = config.foregroundColor
        let buttonFontSize: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ?
            config.optionButtonFontSizeForPad :
            config.optionButtonFontSize
        
        let buttonFont = UIFont.systemFont(ofSize: buttonFontSize)
        
        let button = UIButton(type: .system)
        button.tintColor = config.foregroundColor
        button.titleLabel?.font = buttonFont
        
        if let title = title {
            button.setTitle(title, for: .normal)
            button.setTitleColor(buttonColor, for: .normal)
        }
        
        button.addTarget(self, action: action, for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        
        return button
    }
}
