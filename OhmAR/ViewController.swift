//
//  ViewController.swift
//  OhmAR
//
//  Created by Lenny Martinez on 4/24/18.
//  Copyright © 2018 Lenny Martinez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ARSCNViewDelegate{

    let currentsArray: [String] = ["1Amp", "2Amp", "4Amp"]
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var selectedItem: String?
    let imageName = "1Amp.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        //show the buttons at the bottom
        self.itemsCollectionView.dataSource = self
        self.itemsCollectionView.delegate = self
        // show the AR sceneView
        self.sceneView.delegate = self
        // recognize touch to bring in an object
        self.registerGestureRecognizers()
        // add some lighting to the object
        self.sceneView.autoenablesDefaultLighting = true
        
        
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 50, y: 50, width: 262, height: 474)
        view.addSubview(imageView)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func tapped(sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            self.addItem(hitTestResult: hitTest.first!)
        }
    }
    
    // dynamically add a 3d model item based off which button is selected
    func addItem(hitTestResult: ARHitTestResult) {
        if let selectedItem = self.selectedItem {
            //let image = UIImage(named:"Assets.xcassets/\(selectedItem).imageset/\(selectedItem).png")
            let image = UIImage(named:"\(selectedItem).png")
            //let image = #imageLiteral(resourceName: "\(sele2Amp.png")
            let node = SCNNode(geometry: SCNPlane(width:0.092, height: 0.167))
            node.geometry?.firstMaterial?.diffuse.contents = image
            let transform = hitTestResult.worldTransform
            let thirdColumn = transform.columns.3
            node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            node.rotation = SCNVector4(x: 1, y: 0, z:0, w:Float(-90.degreesToRadians))
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    //add the functionality of the buttons along the bottom of the screen using a collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! itemCell
        cell.itemLabel.text = self.currentsArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.selectedItem = currentsArray[indexPath.row]
        cell?.backgroundColor = UIColor.gray
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.gray
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
    }
    
    
}
// use this extenstion to use degrees instead of radians in the code
extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
