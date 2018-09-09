//
//  SmallCapsLabel.swift
//  chariot
//
//  Created by Bradley Walters on 9/9/18.
//  Copyright © 2018 Chariot App. All rights reserved.
//

import UIKit

@IBDesignable class SmallCapsLabel: UILabel {

    @IBInspectable var fontSize: CGFloat = 24 {
        didSet { updateFont() }
    }

    @IBInspectable var fontWeight: UIFont.Weight = .regular {
        didSet { updateFont() }
    }

    private func updateFont() {
        let baseFont = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let smallCapsDesc = baseFont.fontDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.featureSettings: [
                [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kUpperCaseType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseSmallCapsSelector
                ]
            ]
            ])

        let font = UIFont(descriptor: smallCapsDesc, size: baseFont.pointSize)

        self.font = font
    }
}
