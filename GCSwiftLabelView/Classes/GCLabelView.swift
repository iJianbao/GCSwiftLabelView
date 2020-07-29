//
//  GCLabelView.swift
//  GCSwiftLabelView
//
//  Created by DaDaDaDaDa on 2020/7/29.
//

import UIKit

public class GCLabelModel {
    public var name = ""
    public var image: UIImage? = nil
    public init(name: String, image: UIImage?) {
        self.name = name
        self.image = image
    }
}

public class GCLabelView: UIScrollView {
    /// 上下左右间距
    public var padding: UIEdgeInsets = UIEdgeInsets.zero
    
    /// item 之间的间距
    public var itemMargin: UIOffset = UIOffset.init(horizontal: 10, vertical: 10)
    
    /// item 高度
    public var itemHeight: CGFloat = 30
    
    /// item 背景图
    public var itemNormalBGImage: UIImage?
    
    /// item 选中的背景图
    public var itemSelectedBGImage: UIImage?
    
    /// item 边框颜色
    public var itemBorderColor: UIColor = .white
    
    /// item 边框宽度
    public var itemBorderWidth: CGFloat = 0.5
    
    /// item 圆角
    public var itemCornerRadius: CGFloat = 12
    
    /// item 文本字体
    public var itemFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    /// 数据列表
    private var itemArray: Array<GCLabelModel> = []
    
    /// 记录上次创建的 labelItem
    private var lastLabelItem: GCLabelItem?
    
    /// 创建的 labelItem
    private var itemLabelArray: Array<GCLabelItem> = []
    
    /// 标题
    lazy var titleLabel: UILabel = UILabel.init()
    
    /// 显示 titleLabel
    public var isShowTitleLabel = false
    
    /// 选中的 labelItem
    private var selectLabelItem: GCLabelItem?
    
    /// 选择 labelItem 回调
    public var labelItemSelected: ((GCLabelItem, GCLabelItem?) -> Void)?
    
    // TODO: getter
    /// 标签最大宽度
    private var itemMaxWidth: CGFloat {
        return self.frame.width - padding.left - padding.right
    }
    
    // TODO: setter
    public var title: String {
        get { return titleLabel.text ?? "" }
        set {
            titleLabel.text = newValue
            isShowTitleLabel = true
            if let _ = titleLabel.superview {
                return
            }
            self.addSubview(titleLabel)
        }
    }
    
    // TODO: method
    /// 设置数据源，并开始布局
    /// - Parameter array: 数据源
    public func layoutForDataArray(array: [GCLabelModel]) {
        itemArray = array
        layoutLabelItems()
    }
    
    @objc
    public func layoutForDataArray(array: NSArray) {
       itemArray = array as? Array<GCLabelModel> ?? []
       layoutLabelItems()
    }
    
    private func layoutLabelItems() {
        itemLabelArray.forEach { (item) in
            item.removeFromSuperview()
        }
        for model in itemArray {
            createLabelItem(model)
        }
    }
    
    private func createLabelItem(_ model: GCLabelModel) {
        let rect = CGRect.init(x: padding.left, y: padding.top,
                               width: itemMaxWidth, height: itemHeight)
        let item = GCLabelItem.init(frame: rect, sIcon: model.image != nil)
        item.label.font = itemFont
        item.label.text = model.name
        item.icon = model.image
        
        item.layer.borderColor = itemBorderColor.cgColor
        item.layer.borderWidth = itemBorderWidth
        item.layer.cornerRadius = itemCornerRadius
        
        item.setBackgroundImage(itemNormalBGImage, for: .normal)
        item.setBackgroundImage(itemSelectedBGImage, for: .normal)
        item.addTarget(self, action: #selector(labelItemAction(_:)), for: .touchUpInside)
        self.addSubview(item)
        itemLabelArray.append(item)
    }
    
    @objc func labelItemAction(_ sender: GCLabelItem) {
        sender.isSelected = !sender.isSelected
        guard let selectBlock = labelItemSelected else {
            return
        }
        selectBlock(sender, selectLabelItem)
        selectLabelItem = sender
    }
    
    // TODO: system method
    public override func layoutSubviews() {
        super.layoutSubviews()
        print("\(#function): GCLabelView")
        if isShowTitleLabel {
            titleLabel.frame = CGRect.init(x: (padding.top - 20)/2, y: padding.left, width: self.frame.width, height: 20)
        }
        lastLabelItem = nil
        for item in itemLabelArray {
            var itemSize = item.sizeThatFits(CGSize.init(width: self.frame.width, height: itemHeight))
            if (itemSize.width > itemMaxWidth) {
                itemSize.width = itemMaxWidth
            }
            var surpWidth = itemMaxWidth
            if let lastItem = lastLabelItem {
                surpWidth -= (lastItem.frame.width + lastItem.frame.origin.x + itemMargin.vertical)
                if itemSize.width <= surpWidth {
                    // 同一行
                    item.frame = CGRect.init(x: lastItem.frame.origin.x + lastItem.frame.width + itemMargin.vertical, y: lastItem.frame.origin.y, width: itemSize.width, height: itemHeight)
               }else {
                    // 换行
                    item.frame = CGRect.init(x: padding.left, y: lastItem.frame.origin.y + lastItem.frame.height + itemMargin.horizontal, width: itemSize.width, height: itemHeight)
               }
            }else {
                // 第一个
                item.frame = CGRect.init(x: padding.left, y: padding.top, width: itemSize.width, height: itemHeight)
            }
            lastLabelItem = item
        }
        if let lastItem = lastLabelItem {
            self.contentSize = CGSize.init(width: self.frame.width, height: lastItem.frame.origin.y + lastItem.frame.height + padding.bottom)
        }else {
            self.contentSize = CGSize.init(width: self.frame.width, height: padding.top + padding.bottom)
        }
    }
    
//    public override func sizeToFit() {
//        if let lastItem = lastLabelItem {
//            self.frame = CGRect.init(origin: self.frame.origin, size: CGSize.init(width: self.frame.width, height: lastItem.frame.origin.y + lastItem.frame.height + padding.bottom))
//        }else {
//            self.frame = CGRect.init(origin: self.frame.origin, size: CGSize.init(width: self.frame.width, height: padding.top + padding.bottom))
//        }
//    }
}
