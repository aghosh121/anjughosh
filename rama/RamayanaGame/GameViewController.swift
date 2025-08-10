import AppKit
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Create and configure the beautiful combat scene
            let scene = CombatScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            // Configure the view
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false
            
            // Enable high performance
            view.preferredFramesPerSecond = 60
            
            // Enable keyboard input for macOS
            view.window?.makeFirstResponder(scene)
        }
    }

    // macOS-specific view controller methods
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Ensure the scene can receive keyboard input
        if let view = self.view as? SKView,
           let scene = view.scene {
            view.window?.makeFirstResponder(scene)
        }
    }
}
