//
//  ViewController.swift
//  faceFind
//
//  Created by www on 16/9/9.
//  Copyright © 2016年 www. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
    
    //视频捕捉会话
    var session:AVCaptureSession?
    //视频画面预览层
    var videolayer:AVCaptureVideoPreviewLayer?
    var camera:AVCaptureDevice?
    
    //自动锁定小方框
    var autoview:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCamera(.Front)
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initCamera(position:AVCaptureDevicePosition) {
        //初始化视频捕捉的会话
        session = AVCaptureSession()
        
        let videoDevice = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for item in videoDevice as! [AVCaptureDevice] {
            if item.position == position {
                camera = item
            }
        }
        
        //输入
        if let input = try? AVCaptureDeviceInput(device: self.camera) {
            session?.addInput(input)
        }
        else {
            print("无法使用摄像头")
            return
        }
        
        //元数据输出
        let output = AVCaptureMetadataOutput()
        session?.addOutput(output)
        
        //添加元数据对象输出代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        //输出类型
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeFace]
        
        //视频预览层 与 视频捕捉会话关联
        videolayer = AVCaptureVideoPreviewLayer(session: session)
        videolayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videolayer?.frame = view.layer.bounds
        view.layer.addSublayer(videolayer!)
        
        //启动会话
        session?.startRunning()
    }
    
    func initUI() {
        //把标签放置在最顶的图层
        //view.bringSubviewToFront(addimagebutton!)
        autoview = UIView()
        autoview.layer.borderColor = UIColor.redColor().CGColor
        autoview.layer.borderWidth = 2
        view.addSubview(autoview!)
        view.bringSubviewToFront(autoview!)
    }
}

extension ViewController:AVCaptureMetadataOutputObjectsDelegate {
    //一旦视频有输出，就调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        autoview.frame = CGRectMake(0, 0, 0, 0)
        
        if let obj = metadataObjects.first as? AVMetadataFaceObject {
            if obj.type == AVMetadataObjectTypeFace {
                //把人脸图像转化为图层的坐标
                let faceobj = videolayer?.transformedMetadataObjectForMetadataObject(obj) as! AVMetadataFaceObject
                autoview!.frame = faceobj.bounds
            }
        }
    }
}

