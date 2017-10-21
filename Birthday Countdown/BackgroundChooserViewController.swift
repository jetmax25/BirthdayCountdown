//
//  BackgroundChooserViewController.swift
//  Birthday Countdown
//
//  Created by Michael Isasi on 10/17/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit

class BackgroundChooserViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout {

    let reuseIdentifier = "ImageCell"
    let imagePicker = UIImagePickerController()
    var viewModel : DateCountdownViewModel?
    
    fileprivate let itemsPerRow: CGFloat = 1
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 50.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : BackgroundImages.count()
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)
        let image = indexPath.section == 0 ? UIImage(named : "photoIcon.png") : BackgroundImages.getImage(indexPath.row)
        let imageView = UIImageView.init(image: image)
        imageView.frame = cell.bounds

        cell.addSubview(imageView)
        // Configure the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as UICollectionReusableView
            
            let label = headerView.viewWithTag(12) as! UILabel
            label.text = indexPath.section == 0 ? "Choose one of your photos to use" : "Or Choose One Of Ours"
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            viewModel?.setStoredPhoto(imageInt: indexPath.row)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            viewModel?.setPhotoAsBackground(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
