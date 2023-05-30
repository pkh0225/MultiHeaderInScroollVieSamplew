//
//  ViewController.swift
//  headerViewScrollView
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 2022/06/16.
//

import UIKit

class TestViewController: UIViewController {

    var headerView: TestHeaderView!
    var scrollView: UIScrollView!
    var collectionViews = [UICollectionView]()
    var hitTestViews = [HitTestView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = UIApplication.shared.windows.first
        let top: CGFloat = window?.safeAreaInsets.top ?? 0
        
        self.headerView = TestHeaderView(frame: CGRect(x: 0, y: top, width: self.view.frame.width, height: 500))
        self.view.addSubview(self.headerView)

        let pageCount: CGFloat = 5
        
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: top, width: self.view.frame.width, height: self.view.frame.height))
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * pageCount, height: self.view.frame.height)
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.backgroundColor = .clear
        self.view.addSubview(self.scrollView)

        for i in 0..<Int(pageCount) {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.itemSize = CGSize(width: self.view.frame.width , height: 100)
            
            let cv = UICollectionView(frame: CGRect(x: self.view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: flowLayout)
            cv.dataSource = self
            cv.delegate = self
            cv.register(TestCell.self, forCellWithReuseIdentifier: "TestCell")
            cv.contentInset = UIEdgeInsets(top: self.headerView.frame.height, left: 0, bottom: 0, right: 0)
            cv.backgroundColor = .clear
            
            self.scrollView.addSubview(cv)
            self.collectionViews.append(cv)
            
            
            let htv = HitTestView(frame: CGRect(x: 0, y: -self.headerView.frame.height, width: self.view.frame.width, height: 500))
            htv.tag = 9999
            htv.touchTagetView = self.headerView
            htv.scrollView.contentSize = self.headerView.scrollView.contentSize
            cv.addSubview(htv)
            self.hitTestViews.append(htv)
        }
    }


}

extension TestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCell
        
        var tab = 0
        for (idx,cv) in self.collectionViews.enumerated() {
            if cv == collectionView {
                tab = idx
                break
            }
        }
        cell.configuration(text: "   \(tab) : \(indexPath.row)")
        return cell
    }
    
    
}


extension TestViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let v = scrollView.viewWithTag(9999) else { return }
//        guard self.hitTestViews.count > 0 else { return }
//        var index: Int = 0
//        for (idx,cv) in self.collectionViews.enumerated() {
//            if cv == scrollView {
//                index = idx
//                break
//            }
//        }
        
        
        
        
        let y = scrollView.contentOffset.y
        if y >= -self.headerView.frame.height, scrollView.contentOffset.y <= 0 {
            v.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1 - (abs(scrollView.contentOffset.y) / self.headerView.frame.height))
        }
        else if y < -self.headerView.frame.height {
            v.backgroundColor = .clear
        }
        else {
            v.backgroundColor = .white
        }
    }
}


class TestCell: UICollectionViewCell {
    var label: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.label = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 40))
        self.label.textColor = .yellow
        self.label.font = UIFont.systemFont(ofSize: 25)
        self.contentView.addSubview(self.label)
        
        self.contentView.backgroundColor = .systemGray3
        let lineView = UIView(frame: CGRect(x: 0, y: frame.size.height-1, width: frame.size.width, height: 1))
        lineView.backgroundColor = .gray
        lineView.autoresizingMask = [.flexibleWidth]
        self.addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuration(text: String) {
        self.label.text = text
        self.label.sizeToFit()
    }
}

class TestHeaderView: UIView {
    
    var button1: UIButton!
    var button2: UIButton!
    var scrollView: UIScrollView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.scrollView = UIScrollView(frame: self.bounds)
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize(width: self.frame.width * 5, height: self.frame.height)
        for i in 0..<5 {
            let v = UIView(frame: CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height))
            v.backgroundColor = .random
            let btn = UIButton(frame: CGRect(x: 100, y:  100, width: 180, height: 100))
            btn.tag = i
            btn.setTitle("header in button\(i+1)", for: .normal)
            btn.titleLabel?.textColor = .black
            btn.backgroundColor = .random
            btn.addTarget(self, action: #selector(onButton(btn:)) , for: .touchUpInside)
            v.addSubview(btn)
            self.scrollView.addSubview(v)
        }
        self.addSubview(self.scrollView)
        
        
        self.button1 = UIButton(frame: CGRect(x: 10, y: self.frame.height - 110, width: 100, height: 100))
        self.button1.tag = 1
        self.button1.setTitle("out button\(self.button1.tag)", for: .normal)
        self.button1.setTitleColor(.black, for: .normal)
        self.button1.backgroundColor = .yellow
        self.button1.addTarget(self, action: #selector(onButton(btn:)) , for: .touchUpInside)
        self.addSubview(self.button1)
        
        self.button2 = UIButton(frame: CGRect(x: 210, y: self.frame.height - 110, width: 100, height: 100))
        self.button2.tag = 2
        self.button2.setTitle("out button\(self.button2.tag)", for: .normal)
        self.button2.setTitleColor(.black, for: .normal)
        self.button2.backgroundColor = .orange
        self.button2.addTarget(self, action: #selector(onButton(btn:)) , for: .touchUpInside)
        self.addSubview(self.button2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onButton(btn: UIButton) {
        let message = "\(btn.titleLabel?.text ?? "") click"

        let sheet = UIAlertController(title: "알림", message: message, preferredStyle: .alert)

        sheet.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in print(message) }))

//            sheet.addAction(UIAlertAction(title: "No!", style: .cancel, handler: { _ in print("yes 클릭") }))

        parentViewController?.present(sheet, animated: true)
    }
    
}


class HitTestView: UIView, UIScrollViewDelegate {
    
    weak var touchTagetView: TestHeaderView?
    var scrollView: UIScrollView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        isUserInteractionEnabled = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTabGesture(gesture:)))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
        
        self.scrollView = UIScrollView(frame: self.bounds)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    @objc func onTabGesture(gesture: UITapGestureRecognizer) {
        
        if gesture.state == .ended {
            let pointInView = gesture.location(in: self.touchTagetView)
            
//            print("onTabGesture     touchTagetView posion: \(pointInView)")
            
            let v = self.touchTagetView?.hitTest(pointInView, with: nil)
            if let btn = v as? UIButton {
                btn.sendActions(for: .touchUpInside)
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.touchTagetView?.scrollView.contentOffset = scrollView.contentOffset
    }
}


extension UIColor {
    public class var random: UIColor {
        let r: CGFloat = CGFloat(arc4random() % 11) / 10.0
        let g: CGFloat = CGFloat(arc4random() % 11) / 10.0
        let b: CGFloat = CGFloat(arc4random() % 11) / 10.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
