//
//  PassportViewController.swift
//  Vagary
//
//  Created by Jonathan Witten on 8/20/17.
//  Copyright © 2017 Jonathan Witten. All rights reserved.
//

import Foundation
import ReSwift
import UIKit
import MapKit

protocol PassportPresenter: Presenter{
    var handler: PassportHandler? { get set }
}

class PassportViewController: UIViewController, StoreSubscriber, UICollectionViewDataSource, UICollectionViewDelegate, PassportPresenter {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var user: User?
    var trips: [Trip] = []
    let api = TravelApi()
    
    var handler: PassportHandler?
  
    @IBOutlet weak var shelfBackground: UIView!
    @IBOutlet weak var tripsLabel: UILabel!
    @IBOutlet weak var tripsCollectionView: UICollectionView!
    
    @IBOutlet weak var shelf: UIView!
    override func viewDidLoad(){
        tripsLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTapTripsLabel(tapGestureRecognizer:)))
        tripsLabel.addGestureRecognizer(tapGesture)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViaStore.sharedStore.subscribe(self)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getTrips()
        let path = UIBezierPath(roundedRect:shelf.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 25, height:  25))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        shelf.layer.mask = maskLayer

        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = view.bounds
        view.insertSubview(visualEffectView, at: 1)
        
        bottomConstraint.constant = -(shelf.frame.height - tripsLabel.frame.height)
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ViaStore.sharedStore.unsubscribe(self)
    }
    
    static func build(handler: PassportHandler) -> PassportViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PassportViewController") as! PassportViewController
        vc.handler = handler
        return vc
    }
    
    func newState(state: AppState) {
        guard let viewModel = PassportViewModel.build(state) else {
            return
        }
        if trips.count != viewModel.trips.count{
            trips = viewModel.trips
            tripsCollectionView.reloadData()
        }
    }
    
    func getTrips()  {
        handler?.updateTrips()
    }
    
    @objc func userDidTapTripsLabel(tapGestureRecognizer: UITapGestureRecognizer){
        var color: UIColor = UIColor.white
        if bottomConstraint.constant >= 0 {
            bottomConstraint.constant = -(shelf.frame.height - tripsLabel.frame.height)
            //color = UIColor.white
        }
        else {
            bottomConstraint.constant = 0
            //color = UIColor.cyan
        }
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.view.layoutIfNeeded()
            self.shelfBackground.backgroundColor = color
        })
    }
    
}

extension PassportViewController{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tripsCollectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellId.Trip.rawValue, for: indexPath)
        let trip = trips[indexPath.item]
        configureCell(cell, trip)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < trips.count{
            let trip = trips[indexPath.row]
            ViaStore.sharedStore.dispatch(PassportAction.showTripDetail(trip.id))
//            api.get(resource: Trip.self, path: .trip, forId: trip.id){trip in
//                ViaStore.sharedStore.dispatch(PassportAction.tripDetailResponse(trip))
//            }
//            api.getMany(resource: Post.self, path: .posts, forId: 1){ posts in
//                ViaStore.sharedStore.dispatch(PassportAction.tripDetailPostsResponse(posts))
//            }
        }
    }
    
    func configureCell(_ cell: UICollectionViewCell, _ trip: Trip ){
        if let cell = cell as? TripCollectionViewCell {
            cell.title.text = trip.title
        }
    }
    
}
