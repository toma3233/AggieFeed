//
//  DetailVC.swift
//  AggieFeed
//
//  Created by Tom Abraham on 2/1/21.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblobj: UILabel!
    @IBOutlet weak var lblpub: UILabel!
    
    var detailedNews: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Print detailed information about activity into respective labels
        lbltitle.text = "\((detailedNews?.news_title)!)"
        lblname.text = "\((detailedNews?.news_displayName)!)"
        lblobj.text = "\((detailedNews?.news_objectType)!)"
        lblpub.text = "\((detailedNews?.news_published)!)"
        
    }
    


}
