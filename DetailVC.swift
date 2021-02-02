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
    
    var detailedActivity: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Print detailed information about activity into respective labels
        lbltitle.text = "\((detailedActivity?.title)!)"
        lblname.text = "\((detailedActivity?.actor.displayName)!)"
        lblobj.text = "\((detailedActivity?.object.objectType)!)"
        lblpub.text = "\((detailedActivity?.published)!)"
        
    }
    


}
