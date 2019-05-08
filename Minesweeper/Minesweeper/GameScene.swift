//
//  GameScene.swift
//  Minesweeper
//
//  Created by Brian Malsan on 4/20/19.
//  Copyright © 2019 Brian Malsan. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    
    var gameLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    
    var game: GameManager!
    
    var currentScore: SKLabelNode!
    var gameBG: SKShapeNode!
    var gameArray: [(node: CellNode, x: Int, y: Int)] = []
    
    var minesRemaining:Int = 10
    var isGameOver:Bool = false
    var flagMode:Bool = false
    
    var clickButton: SKShapeNode!
    var flagButton: SKShapeNode!
    
    let numRows = 9
    let numCols = 9
    var numberTextures: [SKTexture] = []
   
    
    override func didMove(to view: SKView) {
        initializeTextures()
        
        initializeMenu()
        
        game = GameManager()
        
        initializeGameView()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" {
                    startGame()
                }
                if node.name == "ClickButton"{
                    if(flagMode){
                        flagMode = false
                        print(flagMode)
                    }
                }
                if node.name == "FlagButton"{
                    if(!flagMode){
                        flagMode = true
                        print(flagMode)
                    }
                }
                
                if (node.name == "cellNode" && !isGameOver){
                    let clickedNode:CellNode = node as! CellNode
                    clickedNode.isClicked = true
                    
                    if(flagMode && minesRemaining > 0){
                        clickedNode.isFlagged = true
                        clickedNode.fillTexture = SKTexture.init(imageNamed: "flag.png")
                        minesRemaining -= 1
                        currentScore.text = "Flags Remaining: " + String(minesRemaining)
                    }
                    else{
                        clickedNode.fillTexture = numberTextures[clickedNode.numNeighborsWithMine]
                    }
                    
                    
                    //print(clickedNode.numNeighborsWithMine)
                    
                    if(clickedNode.isMine && !flagMode){
                        clickedNode.fillTexture = SKTexture.init(imageNamed: "bomb.png")
                        print("BOOOM!!!")
                        GameOver()
                        
                    }
                }
            }
        }
    }
    
    private func startGame(){
        print("Game Started")
        
        //Once play button is hit, hide me
        gameLogo.isHidden = true
        bestScore.isHidden = true
        playButton.isHidden = true
        
        //Show gameboard and score
        gameBG.isHidden = false
        clickButton.isHidden = false
        flagButton.isHidden = false
        currentScore.isHidden = false
    }
    
    private func initializeTextures(){
        numberTextures.append(SKTexture.init(imageNamed: "0.png"))
        numberTextures.append(SKTexture.init(imageNamed: "1.png"))
        numberTextures.append(SKTexture.init(imageNamed: "2.png"))
        numberTextures.append(SKTexture.init(imageNamed: "3.png"))
        numberTextures.append(SKTexture.init(imageNamed: "4.png"))
        numberTextures.append(SKTexture.init(imageNamed: "5.png"))
        numberTextures.append(SKTexture.init(imageNamed: "6.png"))
        numberTextures.append(SKTexture.init(imageNamed: "7.png"))
        numberTextures.append(SKTexture.init(imageNamed: "8.png"))
    }
    
    private func initializeGameView() {
        //4
        currentScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        currentScore.zPosition = 1
        currentScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 60)
        currentScore.fontSize = 40
        currentScore.isHidden = true
        currentScore.text = "Mines Remaining: " + String(minesRemaining)
        currentScore.fontColor = SKColor.white
        self.addChild(currentScore)
        //5
        
        let width = frame.size.width - 200
        let height = frame.size.height - 300
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        gameBG = SKShapeNode(rect: rect, cornerRadius: 0.02)
        gameBG.fillColor = SKColor.darkGray
        gameBG.zPosition = 0
        gameBG.isHidden = true
        self.addChild(gameBG)
        //6
        createGameBoard(width: Int(width), height: Int(height))
        
        let rect2 = CGRect(x: -120, y: -200, width:70, height:70)
        clickButton = SKShapeNode(rect: rect2)
        clickButton.name = "ClickButton"
        clickButton.fillColor = SKColor.blue
        clickButton.zPosition = 1
        clickButton.isHidden = true
        self.addChild(clickButton)
        
        let rect3 = CGRect(x: 80, y: -200, width:70, height:70)
        flagButton = SKShapeNode(rect: rect3)
        flagButton.name = "FlagButton"
        flagButton.fillColor = SKColor.white
        flagButton.fillTexture = SKTexture.init(imageNamed: "flag.png")
        flagButton.zPosition = 1
        flagButton.isHidden = true
        self.addChild(flagButton)
        
    }
    
    private func createGameBoard(width: Int, height: Int) {
        let cellWidth: CGFloat = 60
        
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        //loop through rows and columns, create cells
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                //let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                let cellNode = createCell(width: cellWidth)
                
                cellNode.strokeColor = SKColor.black
                cellNode.fillColor = SKColor.white
                cellNode.zPosition = 0
                cellNode.position = CGPoint(x: x, y: y)
                cellNode.name = "cellNode" //give the cells a name for touch recognition
                
                //add to array of cells -- then add to game board
                gameArray.append((node: cellNode, x: i, y: j))
                gameBG.addChild(cellNode)
                //iterate x
                x += cellWidth
            }
            //reset x, iterate y
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
        
        //After board is generated...
        //Randomly pick who will be mines or not
        let numMines = minesRemaining //set the number of mines we want
        var i=0
        while (i<numMines){
            let posx = Int(arc4random()) % numCols
            //print(posx)
            let posy = Int(arc4random()) % numRows
            //print(posy)
            if(gameArray[posy+(numRows*posx)].node.isMine){
                continue
            }
            else{
                gameArray[posy+(numRows*posx)].node.isMine = true
                i += 1
            }
        }
        
        for cell in gameArray{
            cell.node.numNeighborsWithMine = countNeighbors(posx: cell.x, posy: cell.y)
        }
        
       
    }
    
    private func countNeighbors(posx: Int, posy: Int) -> Int{
        var total = 0
        //print(posx)
        //print(posy)
        
        //tL
        if(-1 < posx-1 && -1 < posy-1 ){
            if(access2D(posx:posx-1,posy:posy-1).isMine){
                total += 1
            }
        }
        //tM
        if(-1 < posx-1 ){
            if(access2D(posx:posx-1,posy:posy).isMine){
                total += 1
            }
        }
        //tR
        if(-1 < posx-1 && posy + 1 < numCols ){
            if(access2D(posx:posx-1,posy:posy + 1).isMine){
                total += 1
            }
        }
        //R
        if(posy + 1 < numCols ){
            if(access2D(posx:posx,posy:posy + 1).isMine){
                total += 1
            }
        }
        
        //bR
        if( posx + 1 < numRows && posy + 1 < numCols ){
            if(access2D(posx:posx + 1,posy:posy + 1).isMine){
                total += 1
            }
        }
        
        //bM
        if(posx + 1 < numRows){
            if(access2D(posx:posx + 1,posy:posy).isMine){
                total += 1
            }
        }
       
        //bL
        if(posx + 1 < numRows && -1 < posy - 1 ){
            if(access2D(posx:posx + 1,posy:posy - 1).isMine){
                total += 1
            }
        }
        
        //L
        if( -1 < posy - 1 ){
            if(access2D(posx:posx,posy:posy - 1).isMine){
                total += 1
            }
        }
        
        return total
        
        //let tL = access2D(posx:posx-1,posy:posy-1)
    }
    
    private func access2D(posx: Int, posy: Int) -> CellNode{
        return gameArray[posy+(numRows*posx)].node
    }
    
    //private func checkMine(posx: Int, posy: Int) -> Bool{
    //    return access2D(posx:posx,posy:posy).isMine
    //}
    
    private func createCell(width: CGFloat) -> CellNode{
        let node = CellNode(rectOf: CGSize(width: width, height: width))
        
        return node
    }
    
    private func initializeMenu() {
        //Create game title
        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameLogo.fontSize = 60
        gameLogo.text = "Minesweeper"
        gameLogo.fontColor = SKColor.red
        self.addChild(gameLogo)
        //Create best score label
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
        bestScore.fontSize = 40
        bestScore.text = "Best Score: 0"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
        //Create play button
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.cyan
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        playButton.path = path
        self.addChild(playButton)
    }
    
    private func GameOver(){
        isGameOver = true
        currentScore.text = "Game Over!!!"
        
        for cell in gameArray{
            if(cell.node.isMine){
                cell.node.fillTexture = SKTexture.init(imageNamed: "bomb.png")
            }
            else{
                if(!cell.node.isClicked){
                    cell.node.fillTexture = numberTextures[cell.node.numNeighborsWithMine]
                }
            }
        }
    }
    
    
    
}
