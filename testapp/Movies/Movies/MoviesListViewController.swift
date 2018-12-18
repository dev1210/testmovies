//
//  MoviesListViewController.swift
//  Movies
//
//  Created by iosdeveloper on 12/17/18.
//  Copyright © 2018 MobileDevTest. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var movies: [MovieInfo]?
    @IBOutlet var moviesTable: UITableView?
    @IBOutlet var activityIndicator: UIActivityIndicatorView?

    var featuredMoviesController: FeaturedMoviesListController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
        moviesTable?.tableFooterView = UIView.init(frame: CGRect.zero)
        self.fetchMoviesList()
        // Do any additional setup after loading the view.
    }
    
    func fetchMoviesList(){
        activityIndicator?.startAnimating()
        APIHelper.fetchMoviesList { (moviesList, error, urlResponse) in
            self.activityIndicator?.stopAnimating()
            if let list = moviesList as? [MovieInfo] {
                self.movies = Array(list[5..<list.count])
                self.moviesTable?.reloadData()
                self.featuredMoviesController.featuredMovies = Array(list[0..<5])
                self.featuredMoviesController.loadPageController()
            }else if (error != nil) {
                let alert = UIAlertController(title: "ERROR",
                                              message: error?.localizedDescription,
                                              preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK",
                                                 style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)

            }
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FeaturedMoviesListController {
            self.featuredMoviesController = vc
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movies != nil) ? movies!.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? MovieListCell, let movie = movies?[indexPath.row] {
            cell.loadDataWithMovieInfo(movie)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsNav") as? UINavigationController,let movieVC = vc.topViewController as? MovieDetailsViewController, let movie = movies?[indexPath.row]   {
            movieVC.movieInfo = movie
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
}

class MovieListCell: UITableViewCell {
    @IBOutlet var img_icon:UIImageView!
    @IBOutlet var lbl_title:UILabel!
    func loadDataWithMovieInfo(_ movieInfo: MovieInfo){
        lbl_title.text = movieInfo.title
        if let image = movieInfo.posterImage{
            self.img_icon.image = image
        }else{
            APIHelper.getImageWithPath(movieInfo.posterImagePath) { (result, error, response) in
                if let image = result as? UIImage {
                    self.img_icon.image = image
                    movieInfo.posterImage = image
                }
            }
        }
    }
}
