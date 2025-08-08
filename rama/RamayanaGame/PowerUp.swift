import SpriteKit
import GameplayKit

enum PowerUpType {
    case health    // Divine healing
    case speed     // Hanuman's speed
    case power     // Rama's divine power
    case shield    // Divine protection
}

class PowerUp: SKSpriteNode {
    
    let type: PowerUpType
    private var isCollected: Bool = false
    
    // Physics categories
    let powerUpCategory: UInt32 = 0x1 << 2
    
    init(type: PowerUpType = .health) {
        self.type = type
        let texture = createPowerUpTexture(for: type)
        super.init(texture: texture, color: .clear, size: CGSize(width: 25, height: 25))
        
        setupPhysics()
        setupAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = .health
        super.init(coder: aDecoder)
    }
    
    private func createPowerUpTexture(for type: PowerUpType) -> SKTexture {
        let size = CGSize(width: 25, height: 25)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        switch type {
        case .health:
            // Red cross for health
            context.setFillColor(UIColor.systemRed.cgColor)
            context.fill(CGRect(x: 10, y: 5, width: 5, height: 15))  // Vertical
            context.fill(CGRect(x: 5, y: 10, width: 15, height: 5))  // Horizontal
            
        case .speed:
            // Lightning bolt for speed
            context.setFillColor(UIColor.systemYellow.cgColor)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 8, y: 5))
            path.addLine(to: CGPoint(x: 12, y: 10))
            path.addLine(to: CGPoint(x: 10, y: 12))
            path.addLine(to: CGPoint(x: 17, y: 20))
            path.addLine(to: CGPoint(x: 15, y: 22))
            path.addLine(to: CGPoint(x: 8, y: 15))
            path.addLine(to: CGPoint(x: 10, y: 13))
            path.close()
            path.fill()
            
        case .power:
            // Star for power
            context.setFillColor(UIColor.systemOrange.cgColor)
            let path = UIBezierPath()
            let center = CGPoint(x: 12.5, y: 12.5)
            let radius: CGFloat = 8
            for i in 0..<5 {
                let angle = CGFloat(i) * CGFloat.pi * 2 / 5 - CGFloat.pi / 2
                let point = CGPoint(
                    x: center.x + radius * cos(angle),
                    y: center.y + radius * sin(angle)
                )
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.close()
            path.fill()
            
        case .shield:
            // Shield shape
            context.setFillColor(UIColor.systemBlue.cgColor)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 12.5, y: 5))
            path.addLine(to: CGPoint(x: 20, y: 8))
            path.addLine(to: CGPoint(x: 20, y: 15))
            path.addCurve(to: CGPoint(x: 12.5, y: 22), controlPoint1: CGPoint(x: 20, y: 18), controlPoint2: CGPoint(x: 17, y: 22))
            path.addCurve(to: CGPoint(x: 5, y: 15), controlPoint1: CGPoint(x: 8, y: 22), controlPoint2: CGPoint(x: 5, y: 18))
            path.addLine(to: CGPoint(x: 5, y: 8))
            path.close()
            path.fill()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image)
    }
    
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: 12.5)
        physicsBody?.categoryBitMask = powerUpCategory
        physicsBody?.contactTestBitMask = 0x1 << 0 // Player category
        physicsBody?.collisionBitMask = 0
        physicsBody?.isDynamic = false
    }
    
    private func setupAnimations() {
        // Floating animation
        let floatUp = SKAction.moveBy(x: 0, y: 10, duration: 1.0)
        let floatDown = SKAction.moveBy(x: 0, y: -10, duration: 1.0)
        let floatSequence = SKAction.sequence([floatUp, floatDown])
        run(SKAction.repeatForever(floatSequence))
        
        // Rotation animation
        let rotate = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 3.0)
        run(SKAction.repeatForever(rotate))
        
        // Pulse animation
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.5),
            SKAction.scale(to: 1.0, duration: 0.5)
        ])
        run(SKAction.repeatForever(pulse))
        
        // Add particle effect based on type
        addParticleEffect()
    }
    
    private func addParticleEffect() {
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 5
        emitter.particleLifetime = 2.0
        emitter.particleSpeed = 20
        emitter.particleSpeedRange = 10
        emitter.particleAlpha = 0.6
        emitter.particleAlphaRange = 0.3
        emitter.particleScale = 0.1
        emitter.particleScaleRange = 0.05
        emitter.position = CGPoint(x: 0, y: 0)
        emitter.zPosition = -1
        
        switch type {
        case .health:
            emitter.particleColor = .systemRed
        case .speed:
            emitter.particleColor = .systemYellow
        case .power:
            emitter.particleColor = .systemOrange
        case .shield:
            emitter.particleColor = .systemBlue
        }
        
        addChild(emitter)
    }
    
    func collect() {
        if isCollected { return }
        
        isCollected = true
        
        // Collection animation
        let collectAnimation = SKAction.group([
            SKAction.scale(to: 1.5, duration: 0.2),
            SKAction.fadeOut(withDuration: 0.2)
        ])
        
        run(collectAnimation) {
            self.removeFromParent()
        }
        
        // Play collection sound
        AudioManager.shared.playSound(.powerUpCollect)
    }
    
    func getType() -> PowerUpType {
        return type
    }
    
    func isAvailable() -> Bool {
        return !isCollected
    }
}
