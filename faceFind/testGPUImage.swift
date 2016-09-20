//
//  testGPUImage.swift
//  faceFind
//
//  Created by www on 16/9/9.
//  Copyright © 2016年 www. All rights reserved.
//

import UIKit
import GPUImage

class testGPUImage:UIViewController {
    
    @IBOutlet var bg: GPUImageView!
    var videoCamera:GPUImageVideoCamera?
    var filter:GPUImagePixellateFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset640x480, cameraPosition: .Back)
        videoCamera!.outputImageOrientation = .Portrait;
        filter = GPUImagePixellateFilter()
        videoCamera?.addTarget(filter)
        filter?.addTarget(self.view as! GPUImageView)
        videoCamera?.startCameraCapture()
    }
    
}
