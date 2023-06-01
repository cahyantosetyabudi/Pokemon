//
//  PokemonDetailVC.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 01/06/23.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class PokemonDetailVC: UIViewController {
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var subtypesLbl: UILabel!
    @IBOutlet weak var flavorLbl: UILabel!
    
    private let disposeBag = DisposeBag()
    private let viewModel: PokemonDetailViewModelProtocol
    
    init(viewModel: PokemonDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init hasnot been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindView()
    }
    
    private func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapThumbnailImg))
        thumbnailImg.addGestureRecognizer(tapGestureRecognizer)
        
        flavorLbl.font = UIFont.italicSystemFont(ofSize: 16)
    }
    
    private func bindView() {
        viewModel.thumbnailUrl
            .drive(onNext: { [weak self] url in
                self?.thumbnailImg.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        viewModel.name
            .drive(nameLbl.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.type
            .drive(typeLbl.rx.text)
            .disposed(by: disposeBag)

        viewModel.subtypes
            .drive(subtypesLbl.rx.text)
            .disposed(by: disposeBag)

        viewModel.flavor
            .drive(flavorLbl.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.onTapThumbnail
            .drive(onNext: { [weak self] urlString in
                self?.showPokemonImageVC(with: urlString)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func didTapThumbnailImg() {
        viewModel.didTapThumbnailImg()
    }
}

extension UIViewController {
    func showPokemonDetailVC(pokemon: Pokemon) {
        title = pokemon.name
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor(red: 22/255, green: 27/255, blue: 34/255, alpha: 1.0)
        let viewModel = PokemonDetailViewModel(pokemon: pokemon)
        let pokemonDetailVC = PokemonDetailVC(viewModel: viewModel)
        show(pokemonDetailVC, sender: self)
    }
}
