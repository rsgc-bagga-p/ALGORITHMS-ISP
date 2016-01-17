//
//  Sketch.swift
//  Animation
//
//  Created by Russell Gordon on 2015-12-05.
//  Copyright © 2015 Royal St. George's College. All rights reserved.
//

import Foundation

// NOTE: The Sketch class will define the methods required by the ORSSerialPortDelegate protocol
//
// “A protocol defines a blueprint of methods, properties, and other requirements that suit a
// particular task or piece of functionality.”
//
// Excerpt From: Apple Inc. “The Swift Programming Language (Swift 2).” iBooks. https://itun.es/ca/jEUH0.l
//
// In this case, the Sketch class implements methods that allow us to read and use the serial port, via
// the ORSSerialPort library.
class Sketch : NSObject, ORSSerialPortDelegate {
    
    // NOTE: Every sketch must contain an object of type Canvas named 'canvas'
    //       Therefore, the line immediately below must always be present.
    let canvas : Canvas
    
    // Declare any properties you need for your sketch below this comment, but before init()
    var serialPort : ORSSerialPort?       // Object required to read serial port
    var serialBuffer : String = ""
    var x = 0.00   // x input from accelerometer
    var y = 0   // Vertical position for the circle appearing on screen
    var s = 1
    var newX = 0 //new x variable, controls the horizontal
    var blockX: [Int] = [0,0,0,0,0,0,0,0,0,0] //obstruction x value
    var blockY: [Int] = [0,0,0,0,0,0,0,0,0,0] //obstruction y value
    var blockNum = 0 //number of obstructions
    var i = 1 //counter
    var boolCheck = true //bool checker
    var gameOver = false //game over
    var score = 0 //score counter
    var levelCounter = 0 //level counter
    
    // This runs once, equivalent to setup() in Processing
    override init() {
        
        // Create canvas object – specify size
        canvas = Canvas(width: 500, height: 700)
        
        // The frame rate can be adjusted; the default is 60 fps
        canvas.framesPerSecond = 60
        
        // Call superclass initializer
        super.init()
        
        // Find and list available ports
        var availablePorts = ORSSerialPortManager.sharedSerialPortManager().availablePorts
        if availablePorts.count == 0 {
            
            // Show error message if no ports found
            print("No connected serial ports found. Please connect your USB to serial adapter(s) and run the program again.\n")
            exit(EXIT_SUCCESS)
            
        } else {
            
            // List available ports in debug window (view this and adjust
            print("Available ports are...")
            for (i, port) in availablePorts.enumerate() {
                print("\(i). \(port.name)")
            }
            
            // Open the desired port
            serialPort = availablePorts[0]  // selecting first item in list of available ports
            serialPort!.baudRate = 9600
            serialPort!.delegate = self
            serialPort!.open()
            
        }
        
        //calls a random number for the number of obstructions
        blockNum = Int(arc4random_uniform(9)) + 1 //values between 1-10
        print(blockNum) //prints the value
        
    }
    
    // Runs repeatedly, equivalent to draw() in Processing
    func draw() {
        
        if (gameOver == false){ // if the game is still continuing
            
            // vertical position of circle
            y = y + s
            
            ++score //adds to the score value
            // reset the circle and obstructions
            if (y > canvas.height) {
                ++levelCounter
                y = 0 //starts at the bootom of the canvas
                blockNum = Int(arc4random_uniform(9)) + 1 //calls a random number of obstructions
                print(blockNum) //prints the value
                boolCheck = true //re creates the obstructions
                i = 0  //resets the counter
                for j in 0...blockNum{ //assigns random values to the array
                    blockX[j] = Int(arc4random_uniform(300)) //random number between 0 and 300
                    blockY[j] = Int(arc4random_uniform(700)) //random number between 0 and 700
                }
            }
            
            // "Clear" the background with a black rectangle
            canvas.drawShapesWithBorders = false
            canvas.fillColor = Color(hue: 0, saturation: 0, brightness: 0, alpha: 100)
            canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
            
            // Writes the title of the project on the screen
            //ALGORITHMS-ISP
            canvas.textColor = Color(hue: Float(canvas.frameCount), saturation: 80, brightness: 90, alpha: 100)
            canvas.drawText(message: "ALGORITHMS-ISP", size: 40, x: (canvas.width/2) - 175, y: (canvas.height/2) - 40)
            
            //level
            canvas.textColor = Color(hue: Float(canvas.frameCount), saturation: 80, brightness: 90, alpha: 100)
            canvas.drawText(message: "Level = " + String(levelCounter), size: 25, x: (canvas.width/2) - 225, y:650)
            
            //score
            canvas.textColor = Color(hue: Float(canvas.frameCount), saturation: 80, brightness: 90, alpha: 100)
            canvas.drawText(message: "Score = " + String(score), size: 25, x: (canvas.width/2) + 95, y: 650)
            
            // Draw a circle that moves across the screen
            canvas.drawShapesWithBorders = false
            canvas.fillColor = Color(hue: Float(canvas.frameCount), saturation: 80, brightness: 90, alpha: 100)
            canvas.drawEllipse(centreX: newX, centreY: y, width: 15, height: 15) //the circle is tracked
            canvas.drawTriangle(bottomRightX: newX - 20, bottomRightY: y - 10, width: 40, height: 40) //the triangle is drawn above the circle to put the x and y in the centre
            
            while(boolCheck) { //while this is true
                //Drawing the obstructions
                canvas.drawShapesWithBorders = false
                canvas.fillColor = Color(hue: 0, saturation: 100, brightness: 100, alpha: 100)
                canvas.drawRectangle(bottomRightX: blockX[i], bottomRightY: blockY[i], width: 60, height: 60)
                
                ++i //adds to the counter
                
                if i >= blockNum{ //if the counter is greater than or equal to the random number
                    boolCheck = false //ends loop
                    i = 0 //resets counter
                }
                
            }
            boolCheck = true //recreates the obstructions
            
            for p in 1...blockNum{ //for int p in blocknum
                if (y > blockY[p] && y < blockY[p] + 60 && newX > blockX[p] && newX < blockX[p] + 60){ //if the x and y value of the circle are equal to the block position then do this
                    
                    gameOver = true //game over
                    
                }
            }
        }
        else {
            
            //game over
            
            // "Clear" the screen with a black rectangle
            canvas.drawShapesWithBorders = false
            canvas.fillColor = Color(hue: 0, saturation: 0, brightness: 0, alpha: 100)
            canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
            //game over
            canvas.textColor = Color(hue: Float(canvas.frameCount), saturation: 80, brightness: 90, alpha: 100)
            canvas.drawText(message: "GAME OVER", size: 40, x: (canvas.width/2) - 120, y: (canvas.height/2) - 40)
            //adding an emoji
            canvas.drawText(message: "😈", size: 50, x: (canvas.width/2) - 30, y: (canvas.height/2) - 100)
            //level
            canvas.textColor = Color(hue: Float(canvas.frameCount), saturation: 80, brightness: 90, alpha: 100)
            canvas.drawText(message: "Level = " + String(levelCounter), size: 25, x: (canvas.width/2) - 225, y:650)
            
            //score
            canvas.textColor = Color(hue: Float(canvas.frameCount), saturation: 80, brightness: 90, alpha: 100)
            canvas.drawText(message: "Score = " + String(score), size: 25, x: (canvas.width/2) + 95, y: 650)
            
        }
    }
    
    // ORSSerialPortDelegate
    // These four methods are required to conform to the ORSSerialPort protocol
    // (Basically, the methods will be invoked when serial port events happen)
    func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
        
        // Print whatever we receive off the serial port to the console
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {
            
            //print("\(string)", terminator: "")
            
            // Iterate over all the characters received from the serial port this time
            for chr in string.characters {
                
                // Check for delimiter
                if chr == "|" {
                    
                    // Entire value sent from Arduino board received, assign to
                    // variable that controls the horizontal position of the circle on screen
                    if let xAsString = serialBuffer as String? { //takes the value as a doublefloat
                        if (xAsString != "") { //if there is something coming in the serial port
                            print("\(xAsString)") //prints value
                            x =  Double(xAsString)!// converts to double float
                            x = (x * -500) + 200// multiplies it by -500 to change the sides of the accelerometer and
                            // to keep it at scale
                            newX = Int(x) //coverts to integer and assigns it to new variable
                            
                        }
                    }
                    // print("\(string)", terminator: "") //debugging
                    // Reset the string that is the buffer for data received from serial port
                    serialBuffer = ""
                    
                } else {
                    
                    // Have not received all the data yet, append what was received to buffer
                    serialBuffer += String(chr)
                }
                
            }
            
            // DEBUG: Print what's coming over the serial port
            //print("\(string)", terminator: "")
            
        }
        
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
        print("Serial port (\(serialPort)) encountered error: \(error)")
    }
    
    func serialPortWasOpened(serialPort: ORSSerialPort) {
        print("Serial port \(serialPort) was opened")
    }
    
}