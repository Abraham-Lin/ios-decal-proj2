//
//  ViewController.swift
//  Hangman
//
//  Created by Gene Yoo on 10/13/15.
//  Copyright © 2015 cs198-ios. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource  {
    var game : Hangman!
    var pickerData: [String] = [String]()
    var numOfWrongGuesses = 1;
    var isCorrect : Bool!
    
    
    @IBOutlet weak var wordToGuess: UILabel!
    @IBOutlet weak var pickLetter: UIPickerView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var guessedLetter: UILabel!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        if (game == nil) {
            game = Hangman()
            game.start()
            wordToGuess.text = game.knownString
        }
        super.viewDidLoad()
        self.pickLetter.delegate = self
        self.pickLetter.dataSource = self
        pickerData = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }

    @IBAction func guessLetter(sender: AnyObject) {
        let input = pickerData[pickLetter.selectedRowInComponent(0)]
        isCorrect = game.guessLetter(input)
        
        if (!isCorrect) {
            numOfWrongGuesses += 1
        }
        
        changeGuessedLetters()
        updateImage()
        wordToGuess.text = game.knownString
        
        var isComplete = true
        
        for (var i = 0; i < game.answer!.characters.count; i++) {
            if (wordToGuess.text! as NSString).substringWithRange(NSMakeRange(i, 1)) == "_" {
                isComplete = false
            }
        }
        
        
        if (isComplete) {
            showWinAlert()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newGame(sender: AnyObject) {
        game.start()
        numOfWrongGuesses = 1
        changeGuessedLetters()
        updateImage()
        wordToGuess.text = game.knownString
    }
    
    func updateImage() {
        image.image = UIImage(named: "hangman\(numOfWrongGuesses).gif")
        if (numOfWrongGuesses == 7) {
            showFailAlert()
            //startOver(game);
        }
    }
    
    func showFailAlert () {
        let alertView = UIAlertController(title: "You're dead!", message: "6 incorrect guesses GG", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func showWinAlert () {
        let alertView = UIAlertController(title: "YOU GUESSED CORRECTLY!", message: "Good job, you didn't die.", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }

    func changeGuessedLetters() {
        print("\(game.guesses)")
        guessedLetter.text = game.guesses()
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

