//
//  BandView.swift
//  PieChartAndBand
//
//  Created by Shobhit on 06/11/22.
//

import UIKit

public class BandView: UIView {
    
    public var highlightValue = 0

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let verticalStackView: UIStackView = {
       let view = UIStackView()
        view.distribution = .fillProportionally
        view.axis = .vertical
        view.spacing = 5
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackViewItemWidth: CGFloat = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        stackViewItemWidth = frame.size.width - 40
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView() {
        addSubview(containerView)
        containerView.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            verticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            verticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            verticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            verticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])

    }
    
    public func createBands(bandDataArray: [(Int, Int)], bandColorArray: [UIColor]) {
        createBandView(bandDataArray: bandDataArray,
                       bandColorArray: bandColorArray)
    }
    
    private func createBandView(bandDataArray: [(Int, Int)], bandColorArray: [UIColor]) {
        for (index, item) in bandDataArray.enumerated() {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: stackViewItemWidth, height: 0))
            view.backgroundColor = bandColorArray[index]
            view.translatesAutoresizingMaskIntoConstraints = false
            
            // LABEL
            let label = UILabel()
            label.sizeToFit()
            label.text = "\(item.0) - \(item.1)"
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 25, weight: .medium)
            
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: view.frame.size.width),
                
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
            ])
            
            
            //IMAGE
            if highlightValue >= (item.0) && highlightValue <= (item.1) {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.image = UIImage(named: "arrow_left_thick_small")
                imageView.contentMode = .scaleAspectFit
                
                
                let stopValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                stopValueLabel.sizeToFit()
                stopValueLabel.text = "\(Int(highlightValue))"
                stopValueLabel.backgroundColor = .clear
                stopValueLabel.textColor = .black
                stopValueLabel.translatesAutoresizingMaskIntoConstraints = false
                stopValueLabel.font = .systemFont(ofSize: 25, weight: .bold)
                
                view.addSubview(imageView)
                view.addSubview(stopValueLabel)
                NSLayoutConstraint.activate([
                    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),

                    stopValueLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -60),
                    stopValueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    ])
            }
            
            verticalStackView.addArrangedSubview(view)
        }
    }

}
