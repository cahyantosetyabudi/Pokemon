//
//  PokemonImageVC.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 01/06/23.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
 
class PokemonImageVC: UIViewController {
    @IBOutlet weak var mainImg: UIImageView!
    
    private let disposeBag = DisposeBag()
    private let viewModel: PokemonImageViewModelProtocol
    
    init(viewModel: PokemonImageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init hasnot been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.imageUrl
            .drive(onNext: { [weak self] url in
                self?.mainImg.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
    }    
}

extension UIViewController {
    func showPokemonImageVC(with url: String) {
        let viewModel = PokemonImageViewModel(imageUrlString: url)
        let pokemonImageVC = PokemonImageVC(viewModel: viewModel)
        pokemonImageVC.modalPresentationStyle = .overFullScreen
        showDetailViewController(pokemonImageVC, sender: self)
    }
}
