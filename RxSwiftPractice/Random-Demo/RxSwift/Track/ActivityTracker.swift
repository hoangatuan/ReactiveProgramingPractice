//
//  ActivityTracker.swift
//  RxSwiftPractice
//
//  Created by Digilife on 27/06/2021.
//

import Foundation
import RxSwift
import RxCocoa

public let LOADING_KEY: String = "loading"

class ActivityTracker<Activity: Hashable> {
    typealias State = [Activity: Bool]
    
    private let _activityState = BehaviorRelay<State>(value: [:])
    
    private func update(status: Bool, for activity: Activity) {
        var state = _activityState.value
        if state[activity] != status {
            state[activity] = status
            _activityState.accept(state)
        }
    }
    
    private func startActivity(_ activity: Activity) {
        update(status: true, for: activity)
    }
    
    private func stopActivity(_ activity: Activity) {
        update(status: false, for: activity)
    }
    
    public func status(for activity: Activity) -> Observable<Bool> {
        return _activityState.compactMap { state -> Bool? in
            return state[activity]
        }.distinctUntilChanged().observeOn(MainScheduler.instance)
    }
    
    func trackActivity<O: ObservableType>(_ activity: Activity, from source: O) -> Observable<O.Element> {
        return source.do(onError: { _ in
            self.stopActivity(activity)
        }, onCompleted: {
            self.stopActivity(activity)
        }, onSubscribe: {
            self.startActivity(activity)
        }, onDispose: {
            self.stopActivity(activity)
        })
    }
    
    func test() {
//        let a = Obse
    }
}


extension ObservableType {
    func trackActivity<Activity: Hashable>(_ activity: Activity, with tracker: ActivityTracker<Activity>) -> Observable<Element> {
        return tracker.trackActivity(activity, from: self)
    }
}


extension Observable {
    func trackActivity<Activity: Hashable>(_ activity: Activity, with tracker: ActivityTracker<Activity>) -> Observable<Element> {
        return tracker.trackActivity(activity, from: self)
    }
}
