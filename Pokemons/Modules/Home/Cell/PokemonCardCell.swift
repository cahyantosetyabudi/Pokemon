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
    
    func bind(viewModel: PokemonCardViewModel) {
        mainImg.kf.setImage(with: viewModel.thumbnailUrl)
    }
}

struct PokemonCardViewModel {
    private let thumbnailUrlString: String
    
    init(thumbnailUrl: String) {
        self.thumbnailUrlString = thumbnailUrl
    }
    
    var thumbnailUrl: URL? {
        URL(string: thumbnailUrlString)
    }
}
