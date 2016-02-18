//
//  BezGalleryCollectionViewController.swift
//  Bez
//
//  Created by Kei Yasui on 2/15/16.
//  Copyright © 2016 Kei Yasui. All rights reserved.
//

import UIKit

class BezGalleryCollectionViewController: UICollectionViewController, BezProjectEditViewControllerDelegate {
    
    var bezProjects = [BezProject]()

    weak var currentIndexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dummy code to populate bezProjects
        bezProjects = []
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        let toolbar = UIToolbar()
        var barButtonItems = [UIBarButtonItem]()
        
        let editButtonTemplateImage = UIImage(named: "pen")?.imageWithRenderingMode(.AlwaysTemplate)
        let editBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: editButtonTemplateImage, style: .Plain, target: self, action: "editProject:")

        let exportButtonTemplateImage = UIImage(named: "export")?.imageWithRenderingMode(.AlwaysTemplate)
        let exportBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: exportButtonTemplateImage, style: .Plain, target: nil, action: "exportProject:")
        
        let trashButtonTemplateImage = UIImage(named: "trash")?.imageWithRenderingMode(.AlwaysTemplate)
        let trashBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: trashButtonTemplateImage, style: .Plain, target: nil, action: "trashProject:")

        barButtonItems.append(editBarButtonItem)
        barButtonItems.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        barButtonItems.append(exportBarButtonItem)
        barButtonItems.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        barButtonItems.append(trashBarButtonItem)
        
//        toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50)
        toolbar.setItems(barButtonItems, animated: true)
        toolbar.backgroundColor = UIColor.grayColor()
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        let toolbarBottomConstraint = NSLayoutConstraint(item: toolbar, attribute: .Bottom, relatedBy: .Equal, toItem: bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: 0)
        let toolbarHeightConstraint = NSLayoutConstraint(item: toolbar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: 50)
        let toolbarLeadingConstraint = NSLayoutConstraint(item: toolbar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
        let toolbarTrailingConstraint = NSLayoutConstraint(item: toolbar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0)

        self.view.addSubview(toolbar)    
        self.view.addConstraints([toolbarBottomConstraint, toolbarHeightConstraint, toolbarLeadingConstraint, toolbarTrailingConstraint])
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return bezProjects.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BezProjectCell", forIndexPath: indexPath) as! BezProjectCollectionViewCell
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.grayColor().CGColor
        
        cell.bezProjectPreviewImage.image = bezProjects[indexPath.row].savedImage
            
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        self.currentIndexPath = indexPath
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.layer.borderColor = UIColor.grayColor().CGColor
    }

    @IBAction func addProject(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("BezProjectEditViewController") as! BezProjectEditViewController
        
        viewController.delegate = self
        
        self.navigationController?.pushViewController((viewController), animated: true)
    }
    
    func editProject(sender: UIButton!) {
        if let currentIndexPathRow = currentIndexPath?.row where currentIndexPath?.row < bezProjects.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("BezProjectEditViewController") as! BezProjectEditViewController
            
            viewController.currentProject = bezProjects[currentIndexPathRow]
            viewController.delegate = self
            
            self.navigationController?.pushViewController((viewController), animated: true)
        }
    }
    
    func exportProject(sender: UIButton!) {
        if let currentIndexPathRow = currentIndexPath?.row where currentIndexPath?.row < bezProjects.count {
            let img: UIImage = bezProjects[currentIndexPathRow].savedImage
            let shareItems:Array = [img]
            
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    func trashProject(sender: UIButton!) {
        if let currentIndexPathRow = currentIndexPath?.row where currentIndexPath?.row < bezProjects.count {
            bezProjects.removeAtIndex(currentIndexPathRow)
            collectionView?.reloadData()
        }
    }
    
    func didSaveBezProject(bezProject: BezProject) {
        bezProjects.append(bezProject)
        collectionView?.reloadData()        
    }
}

extension BezGalleryCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
        return CGSize(width: 164, height: 208)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            let viewWidth = self.view.bounds.width
            let numCells = floor(viewWidth / 164)
            let leftoverSpace = viewWidth - (164 * numCells)
            let spaceBetween = leftoverSpace / (numCells + 1)
            
            return UIEdgeInsets(top: spaceBetween, left: spaceBetween, bottom: 0, right: spaceBetween)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        let viewWidth = self.view.bounds.width
        let numCells = floor(viewWidth / 164)
        let leftoverSpace = viewWidth - (164 * numCells)
        let spaceBetween = leftoverSpace / (numCells + 1)
        
        return spaceBetween
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView?.reloadData()
    }
}
