//
//  HangoutCreateHostController.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import AppFoundation

final class HangoutCreateHostController: UIFeatureController<
    HangoutCreateFeature,
    HangoutCreateView
> {
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
    }
    override func handleEffect(_ effect: HangoutCreateSideEffect) {
        switch effect {
        case .loading:
            break
        case .error:
            break
        }
    }
}
