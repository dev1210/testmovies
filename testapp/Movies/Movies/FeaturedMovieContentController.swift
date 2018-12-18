//
//  FeaturedMovieContentController.swift
//  Movies
//
//  Created by iosdeveloper on 12/17/18.
//  Copyright © 2018 MobileDevTest. All rights reserved.
//

import UIKit

class FeaturedMovieContentController: UIViewController {

    @IBOutlet var img_poster: UIImageView!
    @IBOutlet var lbl_title: UILabel!
    var pageIndex: Int!
    var movieInfo: MovieInfo!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_title.text = movieInfo.title
        if let image = self.movieInfo.posterImage{
            self.img_poster.image = image
        }else{
            APIHelper.getImageWithPath(movieInfo.posterImagePath) { (result, error, response) in
                if let image = result as? UIImage {
                    self.img_poster.image = image
                    self.movieInfo.posterImage = image
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func getstureRecognized(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsNav") as? UINavigationController, let movieVC = vc.topViewController as? MovieDetailsViewController   {
            vc.modalTransitionStyle = .crossDissolve
            movieVC.movieInfo = movieInfo
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }


}
