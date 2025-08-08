import SpriteKit
import GameplayKit

class LevelSelectScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var titleLabel: SKLabelNode!
    private var backButton: SKSpriteNode!
    private var levelButtons: [SKSpriteNode] = []
    
    private let levels = [
        (name: "Level 1", title: "The Birth of Rama", description: "Begin your journey as Prince Rama", unlocked: true),
        (name: "Level 2", title: "The Forest Exile", description: "Navigate through the dangerous forest", unlocked: true),
        (name: "Level 3", title: "The Golden Deer", description: "Face the magical golden deer", unlocked: true),
        (name: "Level 4", title: "Sita's Abduction", description: "Rescue Sita from Ravana", unlocked: false),
        (name: "Level 5", title: "The Bridge to Lanka", description: "Build the bridge with Hanuman's help", unlocked: false),
        (name: "Level 6", title: "The Final Battle", description: "Confront Ravana in the ultimate battle", unlocked: false)
    ]
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupBackButton()
        setupLevelButtons()
    }
    
    private func setupBackground() {
        // Create a mystical forest background
        let background = SKSpriteNode(color: .clear, size: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradient.colors = [
            UIColor(red: 0.2, green: 0.4, blue: 0.1, alpha: 1.0).cgColor,
            UIColor(red: 0.1, green: 0.3, blue: 0.2, alpha: 1.0).cgColor,
            UIColor(red: 0.3, green: 0.2, blue: 0.4, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let gradientImage = UIImage.image(from: gradient)
        let texture = SKTexture(image: gradientImage)
        background.texture = texture
        
        addChild(background)
        backgroundNode = background
    }
    
    private func setupTitle() {
        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = "Choose Your Journey"
        titleLabel.fontSize = 36
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height * 0.9)
        titleLabel.zPosition = 10
        addChild(titleLabel)
    }
    
    private func setupBackButton() {
        backButton = SKSpriteNode(color: .systemRed, size: CGSize(width: 100, height: 40))
        backButton.position = CGPoint(x: 80, y: size.height - 50)
        backButton.name = "back_button"
        
        let label = SKLabelNode(fontNamed: "AvenirNext-Medium")
        label.text = "Back"
        label.fontSize = 16
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        backButton.addChild(label)
        
        addChild(backButton)
    }
    
    private func setupLevelButtons() {
        let buttonWidth: CGFloat = size.width * 0.8
        let buttonHeight: CGFloat = 80
        let spacing: CGFloat = 20
        let startY = size.height * 0.7
        
        for (index, level) in levels.enumerated() {
            let button = createLevelButton(level: level, size: CGSize(width: buttonWidth, height: buttonHeight))
            button.position = CGPoint(x: size.width/2, y: startY - CGFloat(index) * (buttonHeight + spacing))
            button.name = "level_\(index + 1)"
            
            levelButtons.append(button)
            addChild(button)
        }
    }
    
    private func createLevelButton(level: (name: String, title: String, description: String, unlocked: Bool), size: CGSize) -> SKSpriteNode {
        let button = SKSpriteNode(color: level.unlocked ? .systemBlue : .systemGray, size: size)
        button.alpha = level.unlocked ? 0.9 : 0.5
        button.name = level.name.lowercased().replacingOccurrences(of: " ", with: "_")
        
        // Level title
        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = level.title
        titleLabel.fontSize = 18
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: 0, y: 15)
        titleLabel.horizontalAlignmentMode = .center
        button.addChild(titleLabel)
        
        // Level description
        let descLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        descLabel.text = level.description
        descLabel.fontSize = 14
        descLabel.fontColor = .lightGray
        descLabel.position = CGPoint(x: 0, y: -5)
        descLabel.horizontalAlignmentMode = .center
        button.addChild(descLabel)
        
        // Lock icon for locked levels
        if !level.unlocked {
            let lockIcon = SKSpriteNode(color: .white, size: CGSize(width: 20, height: 20))
            lockIcon.position = CGPoint(x: size.width/2 - 30, y: 0)
            button.addChild(lockIcon)
        }
        
        return button
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "back_button" {
            navigateBackToMainMenu()
            return
        }
        
        // Check if a level button was tapped
        for (index, button) in levelButtons.enumerated() {
            if touchedNode == button || touchedNode.parent == button {
                if levels[index].unlocked {
                    startLevel(index + 1)
                } else {
                    showLevelLockedMessage()
                }
                break
            }
        }
    }
    
    private func navigateBackToMainMenu() {
        let mainMenuScene = MainMenuScene(size: size)
        mainMenuScene.scaleMode = .aspectFill
        view?.presentScene(mainMenuScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    private func startLevel(_ levelNumber: Int) {
        let gameScene = GameScene(size: size, level: levelNumber)
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: SKTransition.doorway(withDuration: 0.8))
    }
    
    private func showLevelLockedMessage() {
        let messageLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        messageLabel.text = "Complete previous levels to unlock!"
        messageLabel.fontSize = 20
        messageLabel.fontColor = .yellow
        messageLabel.position = CGPoint(x: size.width/2, y: size.height * 0.3)
        messageLabel.zPosition = 20
        addChild(messageLabel)
        
        let fadeOut = SKAction.fadeOut(withDuration: 2.0)
        let remove = SKAction.removeFromParent()
        messageLabel.run(SKAction.sequence([fadeOut, remove]))
    }
}
