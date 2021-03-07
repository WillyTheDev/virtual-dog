//
//  Scene.swift
//  virtual dog
//
//  Created by William on 04.03.21.
//

import Foundation
import SpriteKit

struct MyScene {
    let dog = SKSpriteNode(imageNamed: "idle_frame_1")
    let sky = SKSpriteNode(imageNamed: "sky_sunny")
    let sky_2 = SKSpriteNode(imageNamed: "sky_sunny")
    let ground = SKSpriteNode(imageNamed: "ground")
    let ground_2 = SKSpriteNode(imageNamed: "ground")
    let stars = SKSpriteNode(imageNamed: "stars_1")
    let stars_2 = SKSpriteNode(imageNamed: "stars_2")
    let rain = SKSpriteNode(imageNamed: "rain_1")
    let rain_2 = SKSpriteNode(imageNamed: "rain_1")
    let mainCamera = SKCameraNode()
    
    var dogIsFacingRight: Bool = true
    let collisionGroundCenter = -1536
    let collisionGround = SKShapeNode(rect: CGRect(x: 1024, y: 2, width: 1024, height: 2))
    let mainScene: SKScene = SKScene(size: CGSize(width: 960, height: 540))
    
    //MARK: - SETTING Scene
    func addingNodesToMainScene(){
        mainScene.addChild(sky)
        mainScene.addChild(sky_2)
        mainScene.addChild(stars)
        mainScene.addChild(stars_2)
        mainScene.addChild(ground)
        mainScene.addChild(ground_2)
        mainScene.addChild(dog)
        mainScene.addChild(rain)
        mainScene.addChild(rain_2)
        mainScene.addChild(collisionGround)
        mainScene.addChild(mainCamera)
        settingMainSceneNodesParameters()
    }
    
    func settingMainSceneNodesParameters(){
        dog.texture?.usesMipmaps = true
                dog.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 128, height: 57))
        mainScene.camera = mainCamera
        mainCamera.position = CGPoint(x: 0, y: -425)
        mainCamera.setScale(0.15)
        
        rain.position = CGPoint(x: 0, y: -425)
        rain.size = CGSize(width: 1024, height: 80)
        rain.alpha = 0
        sky.position = CGPoint(x: 0, y: -390 )
        sky.size = CGSize(width: 1024, height: 288)
        stars.size = CGSize(width: 1024, height: 64)
        stars.position = CGPoint(x: 0, y: -410)
        stars.alpha = 0
        ground.position = CGPoint(x: 0, y: -460)
        ground.size = CGSize(width: 1024, height: 39.2)
        
        sky_2.position = CGPoint(x: -1024, y: -390 )
        sky_2.size = CGSize(width: 1024, height: 288)
        ground_2.position = CGPoint(x: -1024, y: -460)
        ground_2.size = CGSize(width: 1024, height: 64)
        stars_2.size = CGSize(width: 1024, height: 64)
        stars_2.position = CGPoint(x: -1024, y: -410)
        stars.alpha = 0
        rain_2.position = CGPoint(x: -1024, y: -425)
        rain_2.size = CGSize(width: 1024, height: 80)
        rain_2.alpha = 0
        
        dog.position = CGPoint(x: 0 , y: -260)
        dog.setScale(0.5)
        dog.run(SKAction.repeatForever(SKAction.animate(with: dogIdleRightFrames, timePerFrame: 0.15)), withKey: "idle")
       
        
        rain.run(SKAction.repeatForever(SKAction.animate(with: rainFrames, timePerFrame: 0.1)), withKey: "raining")
        rain_2.run(SKAction.repeatForever(SKAction.animate(with: rainFrames, timePerFrame: 0.1)), withKey: "raining_2")
        
        print("rain widht: \(rain.size.width), ground width: \(ground.size.width), sky width: \(sky.size.width),")
        definingAnimation(actualKeyAnimation: "idle")
        
        //Defining Limit
        
        
        collisionGround.physicsBody = SKPhysicsBody(edgeChainFrom: collisionGround.path!)
        collisionGround.physicsBody?.restitution = 0.0
        collisionGround.physicsBody?.categoryBitMask = 0b0001
        collisionGround.alpha = 0
        collisionGround.fillColor = UIColor.red
        dog.physicsBody?.collisionBitMask = 0b0001
        collisionGround.position = CGPoint(x: collisionGroundCenter, y: -468)
    }
    
    
    //MARK: - Defining Dog Action Function
    
    //Random Moving dog Animation
    func definingAnimation(actualKeyAnimation: String){
        print("Dog Position: \(dog.position.x)")
        dog.removeAction(forKey: actualKeyAnimation)
        var newKey: String = "idle"
        var secondsBeforeNewAnimation: Double = 0
            let randomNumber = Int.random(in: 0...7)
            print(randomNumber)
            switch randomNumber {
            case 0:
                newKey = "idleRight"
                dog.run(SKAction.repeatForever(SKAction.animate(with: dogIdleRightFrames, timePerFrame: 0.13)), withKey: newKey)
                secondsBeforeNewAnimation = 3
            case 1:
                newKey = "idleLeft"
                dog.run(SKAction.repeatForever(SKAction.animate(with: dogIdleLeftFrames, timePerFrame: 0.13)), withKey: newKey)
                secondsBeforeNewAnimation = 3
            case 2:
                newKey = "walkRight"
                dog.run(SKAction.repeatForever(SKAction.animate(with: dogWalkRightFrames, timePerFrame: 0.13)), withKey: newKey)
                dog.run(SKAction.move(by: CGVector(dx: 128, dy: 0), duration: 12.8))
                mainCamera.run(SKAction.moveTo(x: mainCamera.position.x < 475 || mainCamera.position.x > -475 ? dog.position.x + 128 : dog.position.x , duration: 12.8))
                collisionGround.run(SKAction.moveBy(x: 128, y: 0, duration: 3.2))
                secondsBeforeNewAnimation = 12.8
                InfiniteScolling(x: dog.position.x, isRunning: false, direction: "right")
            case 3:
                newKey = "walkLeft"
                dog.run(SKAction.repeatForever(SKAction.animate(with: dogWalkLeftFrames, timePerFrame: 0.13)), withKey: newKey)
                dog.run(SKAction.move(by: CGVector(dx: -128, dy: 0), duration: 12.8))
                mainCamera.run(SKAction.moveTo(x: mainCamera.position.x < 475 || mainCamera.position.x > -475 ? dog.position.x - 128 : dog.position.x , duration: 12.8))
                secondsBeforeNewAnimation = 12.8
                collisionGround.run(SKAction.moveBy(x: -128, y: 0, duration: 3.2))
                InfiniteScolling(x: dog.position.x, isRunning: false, direction: "left")
            case 4:
                newKey = "runRight"
                InfiniteScolling(x: dog.position.x, isRunning: true, direction: "right")
                dog.run(SKAction.repeatForever(SKAction.animate(with: dogRunRightFrames, timePerFrame: 0.13)), withKey: newKey)
                dog.run(SKAction.move(by: CGVector(dx: 128, dy: 0), duration: 1.5))
                mainCamera.run(SKAction.moveTo(x: mainCamera.position.x < 384 || mainCamera.position.x > -384 ? dog.position.x + 128 : dog.position.x , duration: 1.4))
                secondsBeforeNewAnimation = 1.5
                collisionGround.run(SKAction.moveBy(x: 128, y: 0, duration: 1.5))
            case 5:
                newKey = "runLeft"
                InfiniteScolling(x: dog.position.x, isRunning: true, direction: "left")
                dog.run(SKAction.repeatForever(SKAction.animate(with: dogRunLeftFrames, timePerFrame: 0.13)), withKey: newKey)
                dog.run(SKAction.move(by: CGVector(dx: -128, dy: 0), duration: 1.5))
                mainCamera.run(SKAction.moveTo(x: mainCamera.position.x < 384 || mainCamera.position.x > -384 ? dog.position.x - 128 : dog.position.x , duration: 1.6))
                secondsBeforeNewAnimation = 1.5
                collisionGround.run(SKAction.moveBy(x: -128, y: 0, duration: 1.5))
            case 6:
                newKey = "yawn"
                dog.run(SKAction.animate(with: dogYawnFrames, timePerFrame: 0.1), withKey: newKey)
                secondsBeforeNewAnimation = 2.3
            case 7:
                newKey = "sleep"
                dog.run(SKAction.repeatForever(SKAction.animate(with: dogSleepFrames, timePerFrame: 0.4)), withKey: newKey)
                secondsBeforeNewAnimation = 10.0
            default:
                print(randomNumber)
            }
        _ = Timer.scheduledTimer(withTimeInterval: secondsBeforeNewAnimation, repeats: false) { (_) in
            dog.removeAction(forKey: newKey)
            dog.run(SKAction.repeatForever(SKAction.animate(with: dogIdleRightFrames, timePerFrame: 0.13)), withKey: "idle")
            _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                definingAnimation(actualKeyAnimation: "idle")
            }
        }
    }
    
    
    
    
    // MARK: - Loading Sprites Assets
    
    // Loading Sprite Animations
        func loadingSpriteFrames(frameName: String, isFacingRight: Bool, nbOfFrames: Int) -> [SKTexture]{
            var frames: [SKTexture] = []
            for i in 1...nbOfFrames {
                let textureName = frameName + String(i) + (isFacingRight ? "" : "_left")
                frames.append(SKTexture(imageNamed: textureName))
            }
            return frames
        }

    //IDlE
    var dogIdleRightFrames: [SKTexture] {
        return loadingSpriteFrames(frameName: "idle_frame_", isFacingRight: true, nbOfFrames: 6)
    }
    var dogIdleLeftFrames: [SKTexture] {
        return loadingSpriteFrames(frameName: "idle_frame_", isFacingRight: false, nbOfFrames: 6)
    }
    //WALK
    var dogWalkRightFrames: [SKTexture] {
        return loadingSpriteFrames(frameName: "walk_frame_", isFacingRight: true, nbOfFrames: 8)
    }
    var dogWalkLeftFrames: [SKTexture] {
        return loadingSpriteFrames(frameName: "walk_frame_", isFacingRight: false, nbOfFrames: 8)
    }
    
    //RUN
    var dogRunRightFrames: [SKTexture] {
        return loadingSpriteFrames(frameName: "run_frame_", isFacingRight: true, nbOfFrames: 8)
    }
    var dogRunLeftFrames: [SKTexture] {
        return loadingSpriteFrames(frameName: "run_frame_", isFacingRight: false, nbOfFrames: 8)
    }
    
    //Yawn
    var dogYawnFrames: [SKTexture] {
        return loadingSpriteFrames(frameName: "yawn_frame_", isFacingRight: true, nbOfFrames: 23)
    }
    
    //Sleep
    var dogSleepFrames: [SKTexture]{
        return loadingSpriteFrames(frameName: "sleep_frame_", isFacingRight: true, nbOfFrames: 8)
    }
    
    //Weather & Background
    var rainFrames: [SKTexture]{
        return loadingSpriteFrames(frameName: "rain_", isFacingRight: true, nbOfFrames: 8)
    }
    
    var starsFrame: [SKTexture]{
        return loadingSpriteFrames(frameName: "stars_", isFacingRight: true, nbOfFrames: 4)
    }
    
    var heartFrames: [SKTexture]{
        return loadingSpriteFrames(frameName: "heart_", isFacingRight: true, nbOfFrames: 6)
    }
    
    //MARK: - Infinite Scrolling Function
    
    // InfiniteScrollingFunction
    func InfiniteScolling(x dogPosition: CGFloat, isRunning: Bool, direction: String){
        print(dogPosition)
        print(Int(dogPosition.rounded(.up)))
        if Int(dogPosition.rounded(.up))%256 == 0 && Int(dogPosition.rounded(.up))%512 != 0 {
            print("Should move background")
            if(direction == "left"){
                print("distance between dog and sky: \(dogPosition.distance(to: sky.position.x))")
                print("distance between dog and sky_2: \(dogPosition.distance(to: sky_2.position.x))")
                if(abs(dogPosition.distance(to: sky.position.x)) < abs(dogPosition.distance(to: sky_2.position.x))){
                    print("moving sky 2 to the left")
                    sky_2.position.x = sky.position.x - 1024
                    ground_2.position.x = ground.position.x - 1024
                    rain_2.position.x = rain.position.x - 1024
                    stars_2.position.x = stars.position.x - 1024
                } else {
                    print("moving sky to the left")
                    sky.position.x = sky_2.position.x - 1024
                    ground.position.x  = ground_2.position.x - 1024
                    rain.position.x = rain_2.position.x - 1024
                    stars.position.x = stars_2.position.x - 1024
                }
            }else{
                if(abs(dogPosition.distance(to: sky.position.x)) < abs(dogPosition.distance(to: sky_2.position.x))){
                    print("moving sky 2 to the right")
                    sky_2.position.x = sky.position.x + 1024
                    ground_2.position.x = ground.position.x + 1024
                    rain_2.position.x = rain.position.x + 1024
                    stars_2.position.x = stars.position.x + 1024
                } else {
                    print("moving sky to the right")
                    sky.position.x = sky_2.position.x + 1024
                    ground.position.x  = ground_2.position.x + 1024
                    rain.position.x = rain_2.position.x + 1024
                    stars.position.x = stars_2.position.x + 1024
                }
            }
            
        }
    }
}
