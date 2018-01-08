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


class PassportViewController: UIViewController, StoreSubscriber, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var user: User?
    var trips: [Trip] = []
    let api = TravelApi()
  
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
        ViaStore.sharedStore.dispatch(getTrips())
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
    
    func newState(state: AppState) {
        let viewModel = PassportViewModel(state)
        if trips.count != viewModel.trips.count{
            trips = viewModel.trips
            tripsCollectionView.reloadData()
        }
    }
    
    func getTrips() -> Store<AppState>.ActionCreator {
        
        return { state, store in
            if let user = state.auth.user {
                let api: TravelApi = TravelApi()
                api.getMany(resource: Trip.self, path: .trips, forId: 0){ trips in
                    DispatchQueue.main.async {
                        store.dispatch(TripsResponse(trips: trips))
                    }
                }
                return TripsSearch(user: user)
            }
            else{ return nil }
        }
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
            ViaStore.sharedStore.dispatch(ShowTripDetail(tripId: trip.id))
            api.get(resource: Trip.self, path: .trip, forId: trip.id){trip in
                ViaStore.sharedStore.dispatch(TripDetailResponse(trip: trip))
            }
            api.getMany(resource: Post.self, path: .posts, forId: 1){ posts in
                ViaStore.sharedStore.dispatch(TripDetailPostsResponse(posts: posts))
            }
        }
    }
    
    func configureCell(_ cell: UICollectionViewCell, _ trip: Trip ){
        if let cell = cell as? TripCollectionViewCell {
            cell.title.text = trip.title
        }
    }
    
}
