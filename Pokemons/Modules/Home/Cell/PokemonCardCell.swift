//
//  PokemonCardCell.swift
//  Pokemons
//
//  Created by Cahyanto Setya Budi on 30/05/23.
//

import UIKit
import Kingfisher

final class PokemonCardCell: UICollectionViewCell {
    @IBOutlet weak var mainImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(viewModel: PokemonCardViewModelProtocol) {
        mainImg.kf.setImage(with: viewModel.thumbnailUrl)
    }
}
