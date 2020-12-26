//
//  Config.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

struct Config {  }

extension Config {
    struct Color {
        static var separator: UIColor {
            .dynamic(light: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1),
                     dark: .separator)
        }

        static var highlightCell: UIColor {
            .dynamic(light: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1),
                    dark: .systemGray6)
        }
    }

}

extension Config {
    struct Image {
        static var arrowUp: UIImage {
            
            let config = UIImage.SymbolConfiguration(weight: .bold)

            if UIScreen.isDarkMode {
                return UIImage(systemName: "arrow.up", withConfiguration: config)!
                    .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(systemName: "arrow.up", withConfiguration: config)!
                    .withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            }
        }

        static var arrowDown: UIImage {
            
            let config = UIImage.SymbolConfiguration(weight: .bold)
            
            if UIScreen.isDarkMode {
                return UIImage(systemName: "arrow.down", withConfiguration: config)!
                    .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(systemName: "arrow.down", withConfiguration: config)!
                    .withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            }
        }

        static var comments: UIImage {
            if UIScreen.isDarkMode {
                return UIImage(named: "comments")!
                    .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(named: "comments")!
                    .withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            }
        }

        static var ellipsis: UIImage {
            if UIScreen.isDarkMode {
                return UIImage(systemName: "ellipsis")!
                    .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(systemName: "ellipsis")!
                    .withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            }
        }

        static var arrowshapeTurnUp: UIImage {
            UIImage(systemName: "arrowshape.turn.up.left.fill")!
                .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        }

        static var link: UIImage {
            UIImage(systemName: "link")!
                .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        }

        static var boltFill: UIImage {
            UIImage(systemName: "bolt.fill")!
                .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        }

        static var docPlainText: UIImage {
            UIImage(systemName: "doc.plaintext")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        }

        static var textQuote: UIImage {
            UIImage(systemName: "text.quote")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        }
        
        static var writeComment: UIImage {
            UIImage(systemName: "square.and.pencil")!.withTintColor(.label, renderingMode: .alwaysOriginal)
        }
        
        static var sortType: UIImage {
            UIImage(systemName: "tray.and.arrow.down.fill")!
                .withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        }
        
        static var postListing: UIImage {
            UIImage(systemName: "checkmark.seal.fill")!
                .withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        }
        
        static var addImage: UIImage {
            UIImage(named: "add-image")!
                .withTintColor(.label, renderingMode: .alwaysOriginal)
        }
        
        static var close: UIImage {
            UIImage(named: "xmark.circle")!
                .withTintColor(.label, renderingMode: .alwaysOriginal)
        }
    }
}

extension Config {
    struct Nib {
        static func loadNib(name: String?) -> UINib? {
            guard let name = name else {
                return nil
            }

            let bundle = Bundle.main
            let nib = UINib(nibName: name, bundle: bundle)

            return nib
        }
    }
}
