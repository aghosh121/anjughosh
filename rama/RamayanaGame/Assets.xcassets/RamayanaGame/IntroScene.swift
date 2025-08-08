import SpriteKit
import UIKit

class IntroScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var titleNode: SKLabelNode!
    private var subtitleNode: SKLabelNode!
    private var introTextNodes: [SKLabelNode] = []
    private var characterNodes: [SKSpriteNode] = []
    private var particleSystem: SKEmitterNode!
    
    private var currentStep = 0
    private let introSteps = [
        "title_screen",
        "intro_scene", 
        "character_select"
    ]
    
    override func didMove(to view: SKView) {
        setupScene()
        startIntroSequence()
    }
    
    private func setupScene() {
        // Set up the scene
        backgroundColor = SKColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        
        // Create particle system for mystical effect
        createParticleSystem()
        
        // Set up touch handling
        isUserInteractionEnabled = true
    }
    
    private func createParticleSystem() {
        particleSystem = SKEmitterNode()
        particleSystem.particleTexture = createParticleTexture()
        particleSystem.particleBirthRate = 20
        particleSystem.particleLifetime = 4.0
        particleSystem.particleSpeed = 50
        particleSystem.particleSpeedRange = 20
        particleSystem.particleAlpha = 0.6
        particleSystem.particleAlphaRange = 0.4
        particleSystem.particleScale = 0.5
        particleSystem.particleScaleRange = 0.3
        particleSystem.particleColor = SKColor.white
        particleSystem.particleColorBlendFactor = 1.0
        particleSystem.particleColorBlendFactorRange = 0.5
        particleSystem.position = CGPoint(x: size.width/2, y: size.height)
        particleSystem.particlePositionRange = CGVector(dx: size.width, dy: 0)
        addChild(particleSystem)
    }
    
    private func createParticleTexture() -> SKTexture {
        let size = CGSize(width: 4, height: 4)
        let texture = SKTexture(size: size) { context in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(ovalIn: rect)
            UIColor.white.setFill()
            path.fill()
        }
        return texture
    }
    
    private func startIntroSequence() {
        currentStep = 0
        showTitleScreen()
    }
    
    private func showTitleScreen() {
        // Clear existing content
        removeAllChildren()
        addChild(particleSystem)
        
        // Create beautiful gradient background
        let background = createGradientBackground()
        backgroundNode = SKSpriteNode(texture: background)
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        // Create title with anime-style effects
        titleNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleNode.text = "RAMAYANA"
        titleNode.fontSize = 72
        titleNode.fontColor = SKColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Golden
        titleNode.position = CGPoint(x: size.width/2, y: size.height * 0.7)
        titleNode.zPosition = 10
        addChild(titleNode)
        
        // Add shadow effect
        let shadowNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
        shadowNode.text = "RAMAYANA"
        shadowNode.fontSize = 72
        shadowNode.fontColor = SKColor.black
        shadowNode.position = CGPoint(x: size.width/2 - 2, y: size.height * 0.7 - 2)
        shadowNode.zPosition = 9
        addChild(shadowNode)
        
        // Create subtitle
        subtitleNode = SKLabelNode(fontNamed: "AvenirNext-Regular")
        subtitleNode.text = "Divine Epic Adventure"
        subtitleNode.fontSize = 36
        subtitleNode.fontColor = SKColor.white
        subtitleNode.position = CGPoint(x: size.width/2, y: size.height * 0.6)
        subtitleNode.zPosition = 10
        addChild(subtitleNode)
        
        // Animate title appearance
        titleNode.setScale(0)
        subtitleNode.alpha = 0
        
        let titleAction = SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.scale(to: 1.0, duration: 1.0),
            SKAction.wait(forDuration: 1.0),
            SKAction.fadeAlpha(to: 0, duration: 1.0)
        ])
        
        let subtitleAction = SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            SKAction.fadeAlpha(to: 1.0, duration: 0.5),
            SKAction.wait(forDuration: 1.0),
            SKAction.fadeAlpha(to: 0, duration: 1.0)
        ])
        
        titleNode.run(titleAction)
        subtitleNode.run(subtitleAction)
        
        // Transition to next scene after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.showIntroScene()
        }
    }
    
    private func showIntroScene() {
        // Clear existing content
        removeAllChildren()
        addChild(particleSystem)
        
        // Create temple background
        let background = createTempleBackground()
        backgroundNode = SKSpriteNode(texture: background)
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        // Create introduction text with typewriter effect
        let introTexts = [
            "In the ancient land of Ayodhya,",
            "where dharma and devotion reign supreme,",
            "begins the epic tale of Lord Rama,",
            "the seventh avatar of Lord Vishnu.",
            "",
            "Join the divine adventure as you",
            "embark on a journey through the",
            "sacred pages of the Ramayana."
        ]
        
        var yPosition = size.height * 0.8
        for (index, text) in introTexts.enumerated() {
            let textNode = SKLabelNode(fontNamed: "AvenirNext-Regular")
            textNode.text = text
            textNode.fontSize = 28
            textNode.fontColor = SKColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Golden
            textNode.position = CGPoint(x: size.width/2, y: yPosition)
            textNode.zPosition = 10
            textNode.alpha = 0
            addChild(textNode)
            introTextNodes.append(textNode)
            
            // Animate text appearance
            let delay = Double(index) * 0.3
            let fadeAction = SKAction.sequence([
                SKAction.wait(forDuration: delay),
                SKAction.fadeAlpha(to: 1.0, duration: 0.5)
            ])
            textNode.run(fadeAction)
            
            yPosition -= 40
        }
        
        // Transition to character select after text animation
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(introTexts.count) * 0.3 + 2.0) {
            self.showCharacterSelect()
        }
    }
    
    private func showCharacterSelect() {
        // Clear existing content
        removeAllChildren()
        addChild(particleSystem)
        
        // Create character selection background
        let background = createCharacterSelectBackground()
        backgroundNode = SKSpriteNode(texture: background)
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        // Create character selection title
        let titleNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleNode.text = "Choose Your Character"
        titleNode.fontSize = 48
        titleNode.fontColor = SKColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        titleNode.position = CGPoint(x: size.width/2, y: size.height * 0.85)
        titleNode.zPosition = 10
        addChild(titleNode)
        
        // Create character options
        let characters = ["Rama", "Sita", "Hanuman"]
        let characterDescriptions = [
            "The Divine Prince - Master of Dharma",
            "The Sacred Goddess - Embodiment of Virtue", 
            "The Mighty Warrior - Devotee Supreme"
        ]
        
        for (index, character) in characters.enumerated() {
            let xPosition = size.width * (0.25 + Double(index) * 0.25)
            let yPosition = size.height * 0.5
            
            // Character portrait (placeholder)
            let characterNode = SKSpriteNode(color: getCharacterColor(character), size: CGSize(width: 120, height: 180))
            characterNode.position = CGPoint(x: xPosition, y: yPosition)
            characterNode.zPosition = 10
            addChild(characterNode)
            characterNodes.append(characterNode)
            
            // Character name
            let nameNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
            nameNode.text = character
            nameNode.fontSize = 24
            nameNode.fontColor = SKColor.white
            nameNode.position = CGPoint(x: xPosition, y: yPosition - 120)
            nameNode.zPosition = 10
            addChild(nameNode)
            
            // Character description
            let descNode = SKLabelNode(fontNamed: "AvenirNext-Regular")
            descNode.text = characterDescriptions[index]
            descNode.fontSize = 16
            descNode.fontColor = SKColor.lightGray
            descNode.position = CGPoint(x: xPosition, y: yPosition - 150)
            descNode.zPosition = 10
            descNode.preferredMaxLayoutWidth = 200
            addChild(descNode)
            
            // Animate character appearance
            characterNode.setScale(0)
            let scaleAction = SKAction.sequence([
                SKAction.wait(forDuration: Double(index) * 0.2),
                SKAction.scale(to: 1.0, duration: 0.5)
            ])
            characterNode.run(scaleAction)
        }
        
        // Add "Tap to Continue" instruction
        let instructionNode = SKLabelNode(fontNamed: "AvenirNext-Regular")
        instructionNode.text = "Tap anywhere to continue..."
        instructionNode.fontSize = 20
        instructionNode.fontColor = SKColor.white
        instructionNode.position = CGPoint(x: size.width/2, y: size.height * 0.1)
        instructionNode.zPosition = 10
        addChild(instructionNode)
        
        // Pulse animation for instruction
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 1.0),
            SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        ])
        instructionNode.run(SKAction.repeatForever(pulseAction))
    }
    
    private func getCharacterColor(_ character: String) -> SKColor {
        switch character {
        case "Rama":
            return SKColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0) // Blue
        case "Sita":
            return SKColor(red: 1.0, green: 0.89, blue: 0.77, alpha: 1.0) // Golden
        case "Hanuman":
            return SKColor(red: 1.0, green: 0.65, blue: 0.0, alpha: 1.0) // Orange
        default:
            return SKColor.white
        }
    }
    
    private func createGradientBackground() -> SKTexture {
        let size = CGSize(width: 1024, height: 768)
        let texture = SKTexture(size: size) { context in
            let colors = [UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0),
                         UIColor(red: 0.3, green: 0.1, blue: 0.4, alpha: 1.0)]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: colors.map { $0.cgColor } as CFArray,
                                    locations: [0, 1])!
            context.cgContext.drawLinearGradient(gradient,
                                               start: CGPoint(x: 0, y: 0),
                                               end: CGPoint(x: 0, y: size.height),
                                               options: [])
        }
        return texture
    }
    
    private func createTempleBackground() -> SKTexture {
        let size = CGSize(width: 1024, height: 768)
        let texture = SKTexture(size: size) { context in
            // Dark temple background
            let colors = [UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0),
                         UIColor(red: 0.3, green: 0.2, blue: 0.1, alpha: 1.0)]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: colors.map { $0.cgColor } as CFArray,
                                    locations: [0, 1])!
            context.cgContext.drawLinearGradient(gradient,
                                               start: CGPoint(x: 0, y: 0),
                                               end: CGPoint(x: 0, y: size.height),
                                               options: [])
            
            // Add temple pillars
            let pillarColor = UIColor(red: 0.55, green: 0.27, blue: 0.07, alpha: 1.0)
            pillarColor.setFill()
            for i in 0..<5 {
                let x = 100 + i * 180
                let pillarRect = CGRect(x: x, y: size.height/2, width: 40, height: size.height/2 - 50)
                context.cgContext.fill(pillarRect)
            }
        }
        return texture
    }
    
    private func createCharacterSelectBackground() -> SKTexture {
        let size = CGSize(width: 1024, height: 768)
        let texture = SKTexture(size: size) { context in
            // Purple gradient background
            let colors = [UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0),
                         UIColor(red: 0.4, green: 0.2, blue: 0.5, alpha: 1.0)]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: colors.map { $0.cgColor } as CFArray,
                                    locations: [0, 1])!
            context.cgContext.drawLinearGradient(gradient,
                                               start: CGPoint(x: 0, y: 0),
                                               end: CGPoint(x: 0, y: size.height),
                                               options: [])
        }
        return texture
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Check if touch is on a character
        for (index, characterNode) in characterNodes.enumerated() {
            if characterNode.contains(location) {
                selectCharacter(index)
                return
            }
        }
        
        // If touch is anywhere else, proceed to main menu
        transitionToMainMenu()
    }
    
    private func selectCharacter(_ index: Int) {
        let characters = ["Rama", "Sita", "Hanuman"]
        let selectedCharacter = characters[index]
        
        // Visual feedback
        let scaleAction = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])
        characterNodes[index].run(scaleAction)
        
        // Show selection message
        let messageNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
        messageNode.text = "You selected \(selectedCharacter)!"
        messageNode.fontSize = 32
        messageNode.fontColor = SKColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        messageNode.position = CGPoint(x: size.width/2, y: size.height * 0.3)
        messageNode.zPosition = 20
        addChild(messageNode)
        
        // Transition to main menu after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.transitionToMainMenu()
        }
    }
    
    private func transitionToMainMenu() {
        // Create fade transition
        let fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
        run(fadeAction) {
            // Present main menu scene
            let mainMenuScene = MainMenuScene(size: self.size)
            mainMenuScene.scaleMode = .aspectFill
            self.view?.presentScene(mainMenuScene, transition: SKTransition.fade(withDuration: 0.5))
        }
    }
}
