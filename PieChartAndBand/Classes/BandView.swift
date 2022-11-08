//
//  BandView.swift
//  PieChartAndBand
//
//  Created by Shobhit on 06/11/22.
//

import UIKit

public class BandView: UIView {
    
    /**
     * Specifies the value to be highlighted on the meter.
     */
    public var highlightValue = 0

    /**
     * Defines the font details for band label
     */
    public var bandLabelFont: UIFont = .systemFont(ofSize: 20, weight: .regular)
    
    /**
     * Defines the text color for band label
     */
    public var bandFontColor: UIColor = .white
    
    /**
     * Defines the font details for band label
     */
    public var bandHighlightLabelFont: UIFont = .systemFont(ofSize: 22, weight: .semibold)
    
    /**
     * Defines the text color for band label
     */
    public var bandHighlightFontColor: UIColor = .black
    
    /**
     * Sepcifies the image to be shown with highlighted vale on band.
     */
    public var bandHighlightedValueImage: UIImage? = nil
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0) //Light grey color
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
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * Use this method to create and pass data to band view.
     */
    public func createBands(bandDataArray: [(Int, Int)], bandColorArray: [UIColor], bandPercentCoverage: [String]) {
        createBandView(bandDataArray: bandDataArray,
                       bandColorArray: bandColorArray,
                       bandPercentCoverage: bandPercentCoverage)
    }

}

private typealias ViewDecorator = BandView
private extension ViewDecorator {
    
    func setupView() {
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
    
    func createBandView(bandDataArray: [(Int, Int)], bandColorArray: [UIColor], bandPercentCoverage: [String]) {
        for (index, item) in bandDataArray.enumerated() {
            let verticalContainerView = UIView(frame: CGRect(x: 0, y: 0, width: stackViewItemWidth, height: 0))
            verticalContainerView.backgroundColor = bandColorArray[index]
            verticalContainerView.translatesAutoresizingMaskIntoConstraints = false
            
            //Left side percent view
            let leftContainerView = setupLeftPercentView(withValue: bandPercentCoverage[index])
            verticalContainerView.addSubview(leftContainerView)
            
            // Range label
            let bandRangeLabel = getCustomRangeLabel(color: bandFontColor,
                                                     font: bandLabelFont,
                                                     item: item)
            verticalContainerView.addSubview(bandRangeLabel)
            
            NSLayoutConstraint.activate([
                verticalContainerView.widthAnchor.constraint(equalToConstant: verticalContainerView.frame.size.width),
                
                leftContainerView.topAnchor.constraint(equalTo: verticalContainerView.topAnchor),
                leftContainerView.bottomAnchor.constraint(equalTo: verticalContainerView.bottomAnchor),
                leftContainerView.leadingAnchor.constraint(equalTo: verticalContainerView.leadingAnchor),
                leftContainerView.widthAnchor.constraint(equalToConstant: frame.size.width * 0.12),
                
                bandRangeLabel.centerYAnchor.constraint(equalTo: verticalContainerView.centerYAnchor),
                bandRangeLabel.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor, constant: 8)
            ])
            
            //Add Image, if available
            if highlightValue >= (item.0) && highlightValue <= (item.1) {
                
                let highlightValueLabel = getCustomizedHighlightLabel()
                
                if let bandImage = bandHighlightedValueImage {
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.image = bandImage
                    imageView.contentMode = .scaleAspectFit
                    verticalContainerView.addSubview(imageView)
                    verticalContainerView.addSubview(highlightValueLabel)
                    
                    NSLayoutConstraint.activate([
                        imageView.centerYAnchor.constraint(equalTo: verticalContainerView.centerYAnchor),
                        imageView.trailingAnchor.constraint(equalTo: verticalContainerView.trailingAnchor, constant: -(verticalContainerView.frame.size.width * 0.20)),
                        highlightValueLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -60),
                        highlightValueLabel.centerYAnchor.constraint(equalTo: verticalContainerView.centerYAnchor),
                    ])
                } else {
                    highlightValueLabel.backgroundColor = .white
                    verticalContainerView.addSubview(highlightValueLabel)
                    NSLayoutConstraint.activate([
                        highlightValueLabel.leadingAnchor.constraint(equalTo: verticalContainerView.trailingAnchor, constant: -(verticalContainerView.frame.size.width * 0.20)),
                        highlightValueLabel.centerYAnchor.constraint(equalTo: verticalContainerView.centerYAnchor),
                    ])
                }
            }
            
            verticalStackView.addArrangedSubview(verticalContainerView)
        }
    }
}

private typealias ViewDecoratorHelper = BandView
private extension ViewDecoratorHelper {
    
    func getCustomizedHighlightLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.sizeToFit()
        label.text = "\(highlightValue)"
        label.backgroundColor = .clear
        label.textColor = bandHighlightFontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = bandHighlightLabelFont
        return label
    }
    
    func setupLeftPercentView(withValue value: String?) -> UIView {
        //Left side percent view
        let leftContainerView = UIView(frame: .zero)
        leftContainerView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        leftContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let leftPercentLabel = UILabel(frame: .zero)
        leftPercentLabel.text = value ?? ""
        leftPercentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leftContainerView.addSubview(leftPercentLabel)
        
        NSLayoutConstraint.activate([
            leftPercentLabel.centerXAnchor.constraint(equalTo: leftContainerView.centerXAnchor),
            leftPercentLabel.centerYAnchor.constraint(equalTo: leftContainerView.centerYAnchor),
        ])
        return leftContainerView
    }
    
    func getCustomRangeLabel(color: UIColor, font: UIFont, item: (Int, Int)) -> UILabel {
        let bandRangeLabel = UILabel()
        bandRangeLabel.sizeToFit()
        bandRangeLabel.text = "\(item.0) - \(item.1)"
        bandRangeLabel.textColor = bandFontColor
        bandRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        bandRangeLabel.font = bandLabelFont
        return bandRangeLabel
    }

}
