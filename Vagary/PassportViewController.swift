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


class PassportViewController: UIViewController, StoreSubscriber, UICollectionViewDataSource, UICollectionViewDelegate, PassportController {
    
    var user: User?
    var trips: [Trip] = []
  
    @IBOutlet weak var tripsCollectionView: UICollectionView!
    var delegate: PassportControllerDelegate?
    
    override func viewDidLoad(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.dispatch(getTrips())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
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
                api.getTrips(for: user){ trips in
                    DispatchQueue.main.async {
                        store.dispatch(TripsResponse(trips: trips))
                    }
                }
                
                return TripsSearch(user: user)
            }
            else{ return nil }
        }
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
            delegate?.selectedTrip(trips[indexPath.row])
        }
    }
    
    func configureCell(_ cell: UICollectionViewCell, _ trip: Trip ){
        if let cell = cell as? TripCollectionViewCell {
            cell.title.text = trip.title
        }
    }
    
}
