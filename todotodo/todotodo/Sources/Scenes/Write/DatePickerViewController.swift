//
//  DatePickerViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/19.
//

import UIKit
import SnapKit

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
protocol DateDelegate {
    func sendDate(_ date: Date)
}

//func item(_ viewController: PageViewController, itemidentifier: ToDo) {
protocol UISheetPresentationDelegate {
    func vc(_ viewController: DatePickerViewController)
}
class DatePickerViewController: BaseViewController {
    
    var randomColor = UIColor.random.cgColor
    
    var delegate: DateDelegate?
    var datePickerDelegate: UISheetPresentationDelegate?
    var date: Date!
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = NSTimeZone.local
        picker.tintColor = .link
        picker.backgroundColor = UIColor.green
        picker.preferredDatePickerStyle = .inline
        picker.addTarget(self, action: #selector(changedDate), for: .valueChanged)
        return picker
    }()
    var imageView : UIImageView?
    

    
    override func configure() {
        
        imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height));
        let bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        imageView!.image = UIImage.gradientImage(bounds: bounds,colors: [ ColorType.backgroundColorSet.cgColor, UIColor.blue.cgColor])
        self.view.addSubview(imageView!)
        
        //applyImageBackgroundToTheNavigationBar()
        
        view.addSubview(datePicker)
        view.backgroundColor = .white

        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(self.datePicker.snp.width)
        }
        configureNavigationBarButtonItem()
    }
    
    @objc
    func changedDate() {
        date = self.datePicker.date
        print("🆗")
        delegate?.sendDate(date)
    }
    
    func configureNavigationBarButtonItem() {
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tappedDoneButton))
        navigationItem.rightBarButtonItem = doneButton
        let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(tappedCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func tappedDoneButton() {
        date = self.datePicker.date
        print("🍖🍖🍖🍖🍖")
        delegate?.sendDate(date)
        self.dismiss(animated: true)
    }
    @objc func tappedCancelButton() {
        self.dismiss(animated: true)
    }

}






extension DatePickerViewController {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("사라짐")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("♥️♥️♥️\(self.isBeingPresented)")
    }
}


