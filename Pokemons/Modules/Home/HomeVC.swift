//
//  HomeVC.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 30/05/23.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokemonsCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel: HomeViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init hasnot been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        searchBar.delegate = self
        searchBar.rx.text
            .compactMap({ $0 })
            .filter({ !$0.isEmpty })
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyword in
                self?.viewModel.search(keyword)
            })
            .disposed(by: disposeBag)
        
        setupCollectionView()
        bindCollectionView()
        bindActivityIndicator()
        
        viewModel.search("")
    }
    
    private func setupCollectionView() {
        pokemonsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        pokemonsCollectionView.register(UINib(nibName: "PokemonCardCell", bundle: nil), forCellWithReuseIdentifier: "PokemonCardCell")
    }
    
    private func bindCollectionView() {
        viewModel.pokemons
            .asObservable()
            .bind(to: pokemonsCollectionView.rx.items(cellIdentifier: "PokemonCardCell", cellType: PokemonCardCell.self)) { row, pokemon, cell in
                let viewModel = PokemonCardViewModel(thumbnailUrl: pokemon.images.large)
                cell.bind(viewModel: viewModel)
            }
            .disposed(by: disposeBag)
        
        pokemonsCollectionView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self else { return }
                let currentPage = Int((self.pokemonsCollectionView.contentOffset.y / self.pokemonsCollectionView.frame.size.width).rounded())
                self.viewModel.loadMore(page: currentPage, indexPath: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindActivityIndicator() {
        viewModel.isFetching
            .asObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

extension HomeVC: UISearchBarDelegate {
    
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 48) / 2
        let height = 3/2 * width
        return CGSize(width: width, height: height)
    }
}
