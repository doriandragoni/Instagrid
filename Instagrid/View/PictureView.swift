//
//  PictureView.swift
//  Instagrid
//
//  Created by Dorian Dragoni on 29/05/2022.
//

import UIKit

@IBDesignable
class PictureView: UIView {
    @IBOutlet weak var delegate: DidTapOnPictureDelegate?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var plusIcon: UIImageView!
    
    let nibName = "PictureView"
    var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
        
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.didTapOnPicture(picture: self)
    }
}
