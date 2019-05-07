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
   
    
    override func didMove(to view: SKView) {
        
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
                if (node.name == "cellNode" && !isGameOver){
                    let clickedNode:CellNode = node as! CellNode
                    clickedNode.isClicked = true
                    if(clickedNode.isMine){
                        minesRemaining -= 1
                        currentScore.text = "Mines Remaining: " + String(minesRemaining)
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
        currentScore.isHidden = false
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
        gameBG.zPosition = 2
        gameBG.isHidden = true
        self.addChild(gameBG)
        //6
        createGameBoard(width: Int(width), height: Int(height))
    }
    
    private func createGameBoard(width: Int, height: Int) {
        let cellWidth: CGFloat = 40
        let numRows = 9
        let numCols = 9
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        //loop through rows and columns, create cells
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                //let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                let cellNode = createCell(width: cellWidth)
                
                cellNode.strokeColor = SKColor.blue
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)
                cellNode.name = "cellNode" //give the cells a name for touch recognition
                cellNode.numNeighborsWithMine = 50
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
        let numMines = 10
        var i=0
        while (i<numMines){
            let posx = Int(arc4random()) % numCols
            print(posx)
            let posy = Int(arc4random()) % numRows
            print(posy)
            if(gameArray[posy+(numRows*posx)].node.isMine){
                continue
            }
            else{
                gameArray[posy+(numRows*posx)].node.isMine = true
                i += 1
            }
        }
        
        
        
    }
    
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
    }
    
    
    
}
