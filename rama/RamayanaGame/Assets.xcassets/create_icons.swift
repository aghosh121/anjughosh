import UIKit
import Foundation

// Simple icon generator for Ramayana game
func createIcon(size: CGSize, scale: CGFloat) -> UIImage {
    let finalSize = CGSize(width: size.width * scale, height: size.height * scale)
    
    UIGraphicsBeginImageContextWithOptions(finalSize, false, 0)
    let context = UIGraphicsGetCurrentContext()!
    
    // Background - gradient from purple to orange (Ramayana colors)
    let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                             colors: [UIColor.systemPurple.cgColor, UIColor.systemOrange.cgColor] as CFArray,
                             locations: [0.0, 1.0])!
    
    context.drawLinearGradient(gradient,
                              start: CGPoint(x: 0, y: 0),
                              end: CGPoint(x: finalSize.width, y: finalSize.height),
                              options: [])
    
    // Add a simple "R" for Ramayana
    let text = "R"
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.boldSystemFont(ofSize: finalSize.width * 0.4),
        .foregroundColor: UIColor.white
    ]
    
    let textSize = text.size(withAttributes: attributes)
    let textRect = CGRect(x: (finalSize.width - textSize.width) / 2,
                         y: (finalSize.height - textSize.height) / 2,
                         width: textSize.width,
                         height: textSize.height)
    
    text.draw(in: textRect, withAttributes: attributes)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
}

// Create icons for different sizes
let iconSizes = [
    ("20x20", CGSize(width: 20, height: 20), [2, 3]),
    ("29x29", CGSize(width: 29, height: 29), [2, 3]),
    ("40x40", CGSize(width: 40, height: 40), [2, 3]),
    ("60x60", CGSize(width: 60, height: 60), [2, 3]),
    ("76x76", CGSize(width: 76, height: 76), [2]),
    ("83.5x83.5", CGSize(width: 83.5, height: 83.5), [2]),
    ("1024x1024", CGSize(width: 1024, height: 1024), [1])
]

let outputDir = "RamayanaGame/Assets.xcassets/AppIcon.appiconset"

for (name, size, scales) in iconSizes {
    for scale in scales {
        let icon = createIcon(size: size, scale: CGFloat(scale))
        let filename = "\(name)@\(scale)x.png"
        let filepath = "\(outputDir)/\(filename)"
        
        if let data = icon.pngData() {
            try? data.write(to: URL(fileURLWithPath: filepath))
            print("Created: \(filename)")
        }
    }
}

print("Icon generation complete!")
