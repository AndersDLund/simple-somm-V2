//
//  ViewController.swift
//  simple_somm_V2
//
//  Created by Anders Lund on 2/28/18.
//  Copyright © 2018 simple_somm_V2. All rights reserved.
//

import UIKit
//import MaterialComponents
import Foundation
import TesseractOCR

class ViewController: UIViewController {
    let foods = [
        "Steak": "Cabernet Sauvignon, Merlot",
        "Crab" : "Chardonay",
        "Lobster" : "Chardonay",
        "Duck" : "Riesling",
        "Salmon" : "Pinot Noir",
        "Pork" : "Syrah",
        "Chicken" : "Sauvignon Blanc",
        "Hamburger" : "Zinfandel",
        "pasta" : "Sangiovese",
        "Pizza" : "Barbera",
        "Taco" : "Rioja, Gewurztraminer",
        "Burito" : "Rioja, Gewurztraminer",
        "salad" : "Sauvignon Blanc",
        "Asian" : "Riesling",
        "Curry" : "Gewurztraminer, Sauvignon Blanc"
    ]
    @IBOutlet weak var textView: UITextView!
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //for textchecker
    let textChecker = UITextChecker()
    //for Natural Language Proccessing
    let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
    let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
    
    
    var nouns = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        view.endEditing(true)
        presentImagePicker()
    }
    
    
    // Tesseract Image Recognition
    func performImageRecognition(_ image: UIImage) {
        print("tesseract!!!!!")
        // 1
        if let tesseract = G8Tesseract(language: "eng+fra") {
            print("in the if statement")
            // 2
            tesseract.engineMode = .tesseractCubeCombined
            // 3
            tesseract.pageSegmentationMode = .auto
            // 4
            tesseract.image = image.g8_blackAndWhite()
            // 5
            tesseract.recognize()
            print("recognize")
            // 6
            print(tesseract.recognizedText)
            
            //determineLanguage(for: tesseract.recognizedText)
            //tokenizeText(for: tesseract.recognizedText)
            //lemmatization(for: tesseract.recognizedText)
            partsOfSpeech(for: tesseract.recognizedText)
//            namedEntityRecognition(for: tesseract.recognizedText)
            
            //this is where i can use an api and input the above to find out if its actually a sentence.
            
            
            
            //put through langauge proccessor then maybe put that into an array so that its easier to uss spell check below?
            
            
            //spell checks
            let misspelledRange = textChecker.rangeOfMisspelledWord(
                in: tesseract.recognizedText, range: NSRange(0..<tesseract.recognizedText.utf16.count),
                startingAt: 0, wrap: false, language: "en_US")
            
            if misspelledRange.location != NSNotFound,
                let guesses = textChecker.guesses(
                    forWordRange: misspelledRange, in: tesseract.recognizedText, language: "en_US")
            {
                print("First guess: \(guesses)")
                
            } else {
                print("Not found")
            }
            
            
            
            //sets storyboard view to the ocr test
//            textView.text = tesseract.recognizedText
        }
        // 7
        activityIndicator.stopAnimating()
    }
    
    
    //find out what language is returned from ocr
    func determineLanguage(for text: String) {
        tagger.string = text
        let language = tagger.dominantLanguage
        print("The language is \(language!)")
    }
    
    //split returned ocr text into words
    func tokenizeText(for text: String) {
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
            let word = (text as NSString).substring(with: tokenRange)
            print(word, "tokenized!")
        }
    }
    
    //turns words into their base root
    func lemmatization(for text: String) {
        tagger.string = text
        let range = NSRange(location:0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, tokenRange, stop in
            if let lemma = tag?.rawValue {
                print(lemma, "lemmanized!")
            }
        }
    }
    
    
    //determine the word's part of the speech
    func partsOfSpeech(for text: String) {
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
            if let tag = tag {
                let word = (text as NSString).substring(with: tokenRange)
                if Array(foods.keys).contains(word){
                    textView.text = "\(foods[word]!) will pair well with the \(word)"
                    print("\(word): \(tag.rawValue)")
                }
                
            }
        }
    }
    
    //identify any names, organizations, or places
    func namedEntityRecognition(for text: String) {
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
            if let tag = tag, tags.contains(tag) {
                let name = (text as NSString).substring(with: tokenRange)
                print("\(name): \(tag.rawValue)")
            }
        }
    }
    
    func presentImagePicker() {
        print("in the image picker")
        // 1
        
        // 2
        let imagePickerActionSheet = UIAlertController(title:"Snap/Upload Image",
                                                       message: nil, preferredStyle: .actionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .camera
                                                self.present(imagePicker, animated: true)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // 1
        let libraryButton = UIAlertAction(title: "Choose Existing", style: .default) { (alert) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            print("animate")
            self.present(imagePicker, animated: true)
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 2
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        // 3
        print("animate")
        present(imagePickerActionSheet, animated: true)
    }
}

// 1
// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        print("image picker controller ----------------")
        // 2
        if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let scaledImage = selectedPhoto.scaleImage(640) {
            print("cool!")
            // 3
            activityIndicator.startAnimating()
            // 4
            
            dismiss(animated: true, completion:  {
                print("youre doin it!")
                self.performImageRecognition(scaledImage)
            })
        }
    }
    
    
}


// MARK: - UIImage extension
extension UIImage {
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
