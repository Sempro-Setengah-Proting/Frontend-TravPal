//
//  UIApplication+RootViewController.swift
//  TravPal
//
//  Created by Revan Arturito on 23/09/26.
//

import UIKit

extension UIApplication {
    var rootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: { $0.isKeyWindow })?
            .rootViewController
    }
}
