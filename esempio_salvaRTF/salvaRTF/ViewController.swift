//
//  ViewController.swift
//  salvaRTF
//
//  Created by Alessio Acri on 05/11/17.
//  Copyright © 2017 Alessio Acri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // UITextView collegata dallo Storyboard al codice
    @IBOutlet var myTextView: UITextView!
    
    
    // variabile che contiene il percorso al file
    var filePath : String {
        // in Swift è possibile "taroccare" le var quando vengono lette (get) o scritte (set)
        get {
            // quindi ogni volta viene chiamata questa var...
            // creiamo un formattatore di date con un formato personalizzato
            // (trucco per creare un nome usando una data univoca)
            let df = DateFormatter()
            df.dateFormat = "yyyyMMddHHmmss"
            
            // riempiamo la var filePath con la stringa restituita dal metodo cartellaDocuments()
            // + uno /
            // + la data formattata come indicato
            // + l'estensione del file (rtfd per avere anche le immagini)
            return cartellaDocuments() + "/" + df.string(from: Date()) + ".rtfd"
        }
    }
    // in sostanza quando ci serve la var filePath si auto-riempie con il percorso al file
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // aggiungiamo via codice un'immagine
        
        // prima si fa un allegato con dentro un'immagine
        let immagineAllegata = NSTextAttachment()
        immagineAllegata.image = UIImage(named: "swift")
        
        // poi una nuova stringa con attibuti mutabile partendo dal testo già presente
        let nuovaStringa = NSMutableAttributedString(attributedString: myTextView.attributedText)
        // aggiungiamo un paio di "a capo"
        nuovaStringa.append( NSAttributedString(string: "\n\n") )
        // e l'allegato con l'immagine
        nuovaStringa.append( NSAttributedString(attachment: immagineAllegata) )
        
        // cambiamo il testo nella textVoew con il nuovo testo
        // (in pratica adesso appare anche un'immagine, il testo l'ho scritto direttamente nello storyboard)
        myTextView.attributedText = nuovaStringa
    }

    
    // metodo che restituisce una string con dentro il percorso alla cartella Documents della sandbox della nostra App
    // copiare dalla console il percorso per trovare il file nel Finder del Mac
    func cartellaDocuments() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(paths[0] as String)
        return paths[0] as String
    }
    
    
    
    @IBAction func salva(_ sender: Any) {
        
        // prina di tutto creiamo il range di caratteri
        // ovviamente li passiamo tutti
        let range = NSMakeRange(0, myTextView.attributedText!.length)
        
        // try catch di Swift, è necessario perchè il metodo dataFromRange ha il throws
        do {
            // creiamo una var NSFileWrapper con dentro la stringa con attributi contenuta nella textView
            // come attributi del documento creato gli diciamo di fare un RTFD (che può contenre anche immagini)
            let data2 = try myTextView.attributedText!.fileWrapper(from: range, documentAttributes: [NSAttributedString.DocumentAttributeKey.documentType : NSAttributedString.DocumentType.rtfd])
            
            // salviamo il file sull'SSD
            try data2.write(to: URL(fileURLWithPath: filePath), options: .atomic, originalContentsURL: nil)
            
        } catch let error as NSError { // se c'è un errore...
            // lo stampiamo in console
            print(error.localizedDescription)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

