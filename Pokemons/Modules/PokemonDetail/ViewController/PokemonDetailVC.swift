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
    @IBOutlet weak var pokemonCollectionView: UICollectionView!

    private let disposeBag = DisposeBag()
    private let viewModel: PokemonDetailViewModelProtocol
    
    weak var coordinator: Coordinator?

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
        setupCollectionView()
        bindCollectionView()
        bindView()
    }
    
    private func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapThumbnailImg))
        thumbnailImg.addGestureRecognizer(tapGestureRecognizer)
        
        flavorLbl.font = UIFont.italicSystemFont(ofSize: 16)
    }
    
    private func setupCollectionView() {
        pokemonCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        pokemonCollectionView.register(UINib(nibName: "PokemonCardCell", bundle: nil), forCellWithReuseIdentifier: "PokemonCardCell")
    }
    
    private func bindCollectionView() {
        viewModel.recommendedPokemons
            .drive(pokemonCollectionView.rx.items(cellIdentifier: "PokemonCardCell", cellType: PokemonCardCell.self)) { row, pokemon, cell in
                let viewModel = PokemonCardViewModel(thumbnailUrl: pokemon.images.large)
                cell.bind(viewModel: viewModel)
            }
            .disposed(by: disposeBag)
        
        pokemonCollectionView.rx.modelSelected(Pokemon.self)
            .bind(onNext: { [weak self] pokemon in
                self?.coordinator?.showPokemonDetailVC(pokemon: pokemon)
            })
            .disposed(by: disposeBag)
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
        
        Driver.combineLatest(viewModel.hp, viewModel.type)
            .map({ "\($1) (HP \($0))" })
            .drive(typeLbl.rx.text)
            .disposed(by: disposeBag)
        
        Driver.combineLatest(viewModel.supertype, viewModel.subtypes)
            .map({ "\($0) - \($1)"})
            .drive(subtypesLbl.rx.text)
            .disposed(by: disposeBag)

        viewModel.flavor
            .drive(flavorLbl.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.onTapThumbnail
            .drive(onNext: { [weak self] urlString in
                self?.coordinator?.showPokemonImageVC(with: urlString)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.type.asObservable(), viewModel.subtypes.asObservable())
            .subscribe(onNext: { [weak self] type, subtypes in
                self?.viewModel.fetchRecommendedPokemons(types: type, subtypes: subtypes)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func didTapThumbnailImg() {
        viewModel.didTapThumbnailImg()
    }
}

extension PokemonDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: Double = 300
        let width: Double = ((2.0/3.0) * Double(height))
        return CGSize(width: width, height: height)
    }
}
