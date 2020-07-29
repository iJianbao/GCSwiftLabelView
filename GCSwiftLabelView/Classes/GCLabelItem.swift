//
//  GCLabelItem.swift
//  GCSwiftLabelView
//
//  Created by DaDaDaDaDa on 2020/7/29.
//

import UIKit

enum GCLabelIconIndex {
    case left, right
}

public class GCLabelItem: UIButton {
    /// 上下左右间距
    var padding: UIOffset = UIOffset.init(horizontal: 10, vertical: 10)
    
    /// 标签 icon 的位置
    var iconIndex: GCLabelIconIndex = .left
    
    /// 显示 icon
    var isShowIcon: Bool = false
    
    /// 记录 所在行
    var indexLine: Int = 0
    
    /// 记录 所在行 的位置
    var indexCount: Int = 0
    
    /// 标签的文本显示
    let label = UILabel.init()
    
    /// 标签的 icon
    private lazy var iconImage = UIImageView.init()
    
    // TODO: getter
    @objc
    var labelText: String {
        return label.text ?? ""
    }
    
    // TODO: setter
    var icon: UIImage? {
        get { iconImage.image }
        set {
            guard let image = newValue else {
                return
            }
            iconImage.image = image
        }
    }
    
    // TODO: system method
    init(frame: CGRect, sIcon: Bool) {
        super.init(frame: frame)
        print("\(#function): init frame")
        isShowIcon = sIcon
        self.addSubview(label)
        if (isShowIcon) {
            self.addSubview(iconImage)
        }
        self.clipsToBounds = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        print("\(#function): GCLabelItem")
        let labelSize = label.sizeThatFits(CGSize.init(width: self.frame.width,
                                                       height: self.frame.height))
        if (isShowIcon) {
            var imageSize = CGSize.init(width: self.frame.height - padding.vertical * 2,
                                        height: self.frame.height - padding.vertical * 2)
            if let image = iconImage.image {
                imageSize = CGSize.init(width: image.size.width,
                                        height: image.size.height)
            }
            iconImage.frame = CGRect.init(x: padding.horizontal,
                                          y: (self.frame.height - imageSize.height)/2,
                                          width: imageSize.width,
                                          height: imageSize.height)
            label.frame = CGRect.init(x: iconImage.frame.origin.x + iconImage.frame.width + 5,
                                      y: 0,
                                      width: labelSize.width,
                                      height: self.frame.height)
        }else {
            label.frame = CGRect.init(x: padding.horizontal,
                                      y: 0,
                                      width: labelSize.width,
                                      height: self.frame.height)
        }
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: label.frame.origin.x + label.frame.width + padding.horizontal, height: self.frame.height)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(#function): init coder")
    }
    
    
}
