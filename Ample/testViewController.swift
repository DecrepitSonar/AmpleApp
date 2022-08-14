//
//  testViewController.swift
//  Ample
//
//  Created by bajo on 2022-07-08.
//

import UIKit

class testViewController: UIViewController {

    // Container
    var heightAnchor: CGFloat = 70
    var widhAnchor: CGFloat = UIScreen.main.bounds.width - 40
    var bottomAnchor: CGFloat = -20
    
    var boxHeight: NSLayoutConstraint?
    var boxWidth: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    
    //image
    var imageHeight: CGFloat = 50
    var imageWidth: CGFloat = 50
    var imageLeadingConstraint: CGFloat = 10
    var imageTopConstraint: CGFloat = 10
    
    var imageLeadingAnchor: NSLayoutConstraint?
    var imageHeightAnchor: NSLayoutConstraint?
    var imageWidthAnchor: NSLayoutConstraint?
    var imageTopAnchor: NSLayoutConstraint?
    
    // Labels
    var labelStack: UIStackView!
    
    var leadingAnchor: CGFloat = 70
    var bottonAnchor: CGFloat = -15
    var leadingConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?

    var isOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(Toggle))
        box.addGestureRecognizer(gesture)
        
        labelStack = UIStackView(arrangedSubviews: [nameLabel, trackLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.distribution = .equalSpacing
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(box)
        box.addSubview(image)
        box.addSubview(labelStack)
        
        setupPreConstraints()
        
    }
    
    func setupPreConstraints(){
        
        NSLayoutConstraint.activate([
            box.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // Container
        boxHeight = box.heightAnchor.constraint(equalToConstant: heightAnchor)
        boxHeight?.isActive = true

        boxWidth = box.widthAnchor.constraint(equalToConstant: widhAnchor)
        boxWidth?.isActive = true
        
        bottom = box.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomAnchor)
        bottom?.isActive = true
        
        //Image
        imageLeadingAnchor  = image.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: imageLeadingConstraint)
        imageLeadingAnchor?.isActive = true
        
        imageHeightAnchor = image.heightAnchor.constraint(equalToConstant: imageHeight)
        imageHeightAnchor?.isActive = true
        
        imageWidthAnchor = image.widthAnchor.constraint(equalToConstant: imageWidth)
        imageWidthAnchor?.isActive = true
        
        imageTopAnchor = image.topAnchor.constraint(equalTo: box.topAnchor, constant: imageTopConstraint)
        imageTopAnchor?.isActive = true
        
        // Label Stack
        leadingConstraint = labelStack.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: leadingAnchor)
        leadingConstraint?.isActive = true
        
        bottomConstraint = labelStack.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: bottonAnchor)
        bottomConstraint?.isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    @objc func Toggle(){
        
        guard isOpen else {
            isOpen = true
            print("open")
            animateOpen()
            return
        }
        
        isOpen = false
        print("closed")
        animateClose()
        return
        
    }
    
    func animateClose(){
        
        let containerAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.boxHeight!.constant = 70
            self.boxWidth!.constant = UIScreen.main.bounds.width - 40
            self.bottom?.constant = -20
            
            self.view.layoutIfNeeded()
            
        }
        
        containerAnimation.startAnimation()
        
        let imageAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.imageLeadingAnchor?.constant = 10
            self.imageWidthAnchor?.constant = 50
            self.imageHeightAnchor?.constant = 50
            self.imageTopAnchor?.constant = 10
            self.view.layoutIfNeeded()
        }
        
        imageAnimation.startAnimation()
        
        let labelStackAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            
            self.leadingConstraint?.constant = 70
            self.bottomConstraint?.constant = -15
            self.view.layoutIfNeeded()
            
        }
        
        labelStackAnimation.startAnimation()
        
    }

    func animateOpen(){

        let containerAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            
            // Containe Animation
            self.boxHeight!.constant = UIScreen.main.bounds.height
            self.boxWidth!.constant = UIScreen.main.bounds.width
            self.bottom?.constant = 0

            self.view.layoutIfNeeded()
            
        }

        containerAnimation.startAnimation()
        
        let imageAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            
            self.imageLeadingAnchor?.constant = 20
            self.imageWidthAnchor?.constant = UIScreen.main.bounds.width - 40
            self.imageHeightAnchor?.constant = 350
            self.imageTopAnchor?.constant = 200
            self.view.layoutIfNeeded()
            
        }
        
        imageAnimation.startAnimation()
        
        let labelStackAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn ) {
            
            self.leadingConstraint?.constant = 20
            self.bottomConstraint?.constant = -200
            self.view.layoutIfNeeded()
            
        }
        
        labelStackAnimation.startAnimation()
    }
    
    let closeBtn: UIButton = {
        let btn = UIButton()
        
        return btn
    }()
    
    let optionsBtn: UIButton = {
        let btn = UIButton()
        
        return btn
    }()

    let box: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.backgroundColor = .red
        _view.layer.cornerRadius = 5
        return _view
    }()
    let image: UIView = {
        let img = UIView()
        img.backgroundColor = .white
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 5
        return img
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    let trackLabel: UILabel = {
        let label = UILabel()
        label.text = "No Track Playing..."
        return label
    }()
    let progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.backgroundColor = .orange
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
}


//
//func translateBox(){
//    let animation = CABasicAnimation()
//    animation.keyPath = "position.x"
//    animation.fromValue = 100
//    animation.toValue = 300
//    animation.duration = 1
//
//    box.layer.add(animation, forKey: "basic")
//    box.layer.position = CGPoint(x: 300, y: 100)
//
//}
//
//func scaleBox(){
//    let animation = CABasicAnimation()
//    animation.keyPath = "transform.scale"
//    animation.fromValue = 1
//    animation.toValue = 2
//    animation.duration = 0.4
//
//    box.layer.add(animation, forKey: "basic")
//    box.layer.transform = CATransform3DMakeScale(2, 2, 1) // update
//}
//
//func transforomBox(){
//
//}
//
//func rotateBox(){
//    let animation = CABasicAnimation()
//    animation.keyPath = "transform.rotation.z" // Note: z-axis
//    animation.fromValue = 0
//    animation.toValue = CGFloat.pi / 4
//    animation.duration = 1
//
//    box.layer.add(animation, forKey: "basic")
//    box.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 4, 0, 0, 1)
//}
//
//func animateBoxProperties(){
//
//}
//
