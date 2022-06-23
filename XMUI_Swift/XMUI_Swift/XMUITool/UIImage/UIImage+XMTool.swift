//
//  UIImage+XMTool.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import Foundation
import UIKit

/// UIImage 相关类目
extension UIImage {
    
    /// 获取本地图片 例如： “home.jpg” - 特点是不放入内存中
    class func getLocalImage_noInCache(named: String) -> UIImage? {
        if let imgPath = Bundle.main.path(forResource: named, ofType: nil) {
            return UIImage(contentsOfFile: imgPath)
        }
        return nil
    }

    /// 根据颜色和尺寸生成一张图片
    class func getImageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: size.width, height: size.height), true, UIScreen.main.scale)
        color.set()
        UIRectFill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 取图片某点像素的颜色 传入：CGPoint
    func getColor(atPixel: CGPoint) -> UIColor? {
        let width = self.size.width;
        let height = self.size.height;
        if !CGRect.init(x: 0, y: 0, width: width, height: height).contains(atPixel) {
            return nil;
        }
        let pointX = trunc(atPixel.x);  // 取整
        let pointY = trunc(atPixel.y);
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let bytesPerPixel = 4;
        let bytesPerRow = bytesPerPixel * 1;
        let bitsPerComponent = 8;
        var pixelData = Array<Int>.init();
        let context = CGContext.init(data: &pixelData, width: 1, height: 1, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: (CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
        context?.setBlendMode(CGBlendMode.copy);
        context?.translateBy(x: pointX, y: (pointY - height));
        context?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: width, height: height));
        let red = CGFloat(pixelData[0]) / 255.0;
        let green = CGFloat(pixelData[1]) / 255.0;
        let blue = CGFloat(pixelData[2]) / 255.0;
        let alpha = CGFloat(pixelData[3]) / 255.0;
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha);
    }

    /// 水平翻转
    func flipHorizontal() -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
        
        let ctx = UIGraphicsGetCurrentContext();
        ctx?.clip(to: rect);
        ctx?.rotate(by: CGFloat(Double.pi));
        ctx?.translateBy(x: -rect.size.width, y: -rect.size.height);
        ctx?.draw(self.cgImage!, in: rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    /// 垂直翻转
    func flipVertical() -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
        
        let ctx = UIGraphicsGetCurrentContext();
        ctx?.clip(to: rect);
        ctx?.draw(self.cgImage!, in: rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }

    /// 将图片旋转弧度radians 例如： π、π/2.0
    func imageRotated(byRadians: CGFloat) -> UIImage? {
        let rotatedViewBox = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height));
        let t = CGAffineTransform.init(rotationAngle: byRadians);
        rotatedViewBox.transform = t;
        let rotatedSize = rotatedViewBox.frame.size;
        
        UIGraphicsBeginImageContext(rotatedSize);
        let bitmap = UIGraphicsGetCurrentContext();
        bitmap?.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2);
        bitmap?.rotate(by: byRadians);
        bitmap?.scaleBy(x: 1.0, y: -1.0);
        bitmap?.draw(self.cgImage!, in: CGRect.init(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height));
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    /// 将图片旋转角度degrees -- 例如： 0 -- 360
    func imageRotated(byDegrees: CGFloat) -> UIImage? {
        return self.imageRotated(byRadians: CGFloat(Double(byDegrees) * Double.pi / 180));
    }
}

// MARK: - 二维码相关
extension UIImage {
    
    /// 生成二维码图片
    class func getQRCodeImage(text: String, size: CGFloat) -> UIImage {
        let stringData = text.description.data(using: String.Encoding.utf8);
        let QRFilter = CIFilter.init(name: "CIQRCodeGenerator");
        QRFilter?.setValue(stringData, forKey: "inputMessage");
        QRFilter?.setValue("M", forKey: "inputCorrectionLevel");
        let extent = QRFilter?.outputImage?.extent;
        
        let scale1 = size / (extent?.size.width)!;
        let scale2 = size / (extent?.size.height)!;
        var scale: CGFloat;
        if scale1 > scale2 {
            scale = scale2;
        }else {
            scale = scale1;
        }
        
        let width = (extent?.size.width)! * scale;
        let height = (extent?.size.height)! * scale;
        
        let cs = CGColorSpaceCreateDeviceGray();
        let bitmapRef = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue);
        
        let context = CIContext.init(options: nil);
        let bitmapImage = context.createCGImage((QRFilter?.outputImage)!, from: extent!);
        bitmapRef?.interpolationQuality = CGInterpolationQuality.none;
        bitmapRef?.scaleBy(x: scale, y: scale);
        bitmapRef?.draw(bitmapImage!, in: extent!);
        
        let scaledImage = bitmapRef?.makeImage();
        let reusult = UIImage.init(cgImage: scaledImage!);
        return reusult;
    }
    
    /// 二维码图片内容信息 字符串
    func getQRCodeImageContextString() -> String? {
        let content = CIContext.init(options: nil);
        let detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: content, options: nil);
        let cimage = CIImage.init(cgImage: self.cgImage!);
        let features = detector?.features(in: cimage);
        let f: CIQRCodeFeature = features?.first as! CIQRCodeFeature;
        return f.messageString!;
    }
}
