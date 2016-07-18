//
//  ViewController.swift
//  Location
//
//  Created by XQ on 16/7/18.
//  Copyright © 2016年 XQ. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

   
    let locateMannage:CLLocationManager = CLLocationManager()
    var btn:UIButton = UIButton(type: .System)
    var mapView:MKMapView = MKMapView()
    var currentCoordinate:CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 添加地图视图
        mapView = MKMapView.init(frame: self.view.frame)
        mapView.mapType = MKMapType.Standard
        
        //mapView.scaleOrigin = CGPointMake(100, mapView.frame.size.height-20)
        
        self.view.addSubview(mapView)
        
        // 按钮
        btn.frame = CGRectMake(10, 30, 100, 50)
        btn.setTitle("定位", forState: .Normal)
        btn.addTarget(self, action: "setLocation:", forControlEvents: .TouchUpInside)
        self.view.addSubview(btn)
        
        self.locateMannage.delegate = self
        // 发送授权
        if self.locateMannage.respondsToSelector(Selector("requestAlwaysAuthorization")) {
            self.locateMannage.requestAlwaysAuthorization()
        }
        // 精度
        self.locateMannage.desiredAccuracy = kCLLocationAccuracyBest
        // 更新距离
        locateMannage.distanceFilter = 100
        // 开启更新位置服务
        //self.locateMannage.startUpdatingHeading()
        
        
    }

    
    // CLLocationManager代理方法
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 获取最后的位置信息
        self.locateMannage.stopUpdatingHeading()
        let newLocation:CLLocation = locations.last!
        // 设置大小(经纬度)1纬度约等于111千米
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.03, 0.03)
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: newLocation.coordinate, span: currentLocationSpan)
        self.mapView.setRegion(currentRegion, animated: true)
                
        
        // 反编码
        CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: { (pms, err) -> Void in
            
                //取得最后一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
                let placemark:CLPlacemark = (pms!.last)!
                self.currentCoordinate = placemark.location?.coordinate
                let location = placemark.location;//位置
                let region = placemark.region;//区域
                let addressDic = placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
//                let name=placemark.name;//地名  广汇花苑
//                let thoroughfare=placemark.thoroughfare;//街道 ---斜土路
//                let subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等   ---1981号
//                let locality=placemark.locality; // 城市   ---上海市
//                let subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑 ----徐汇区
//                let administrativeArea=placemark.administrativeArea; // 行政管理区域   ----上海市
//                let subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息  ---nil(因该是xxx省xxx市)
//                let postalCode=placemark.postalCode; //邮编
//                let ISOcountryCode=placemark.ISOcountryCode; //国家编码   CN
//                let country=placemark.country; //国家
//                let inlandWater=placemark.inlandWater; //水源、湖泊
//                let ocean=placemark.ocean; // 海洋
//                let areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
//                    name =  "中国河南省郑州市管城回族区北下街街道东太康路25号";
//
//                    administrativeArea = "河南省";
//                    country = "中国";
//                    countryCode = CN; -- ISOcountryCode
//                    locality = "郑州市";
//                    subLocality = "管城回族区";
//                    subThoroughfare = "25号";
//                    thoroughfare = "东太康路";
//                    timezone =                             {
//                        identifier = "Asia/Shanghai";
//                    };
            
            print(region)
            print("====\(addressDic)")
            
            // 添加大头针
            //创建一个大头针对象
            let bigPin = MKPointAnnotation()
            //设置大头针的显示位置
            bigPin.coordinate = location!.coordinate
            //设置点击大头针之后显示的标题
            bigPin.title = "\(placemark.locality)--\(placemark.subLocality)"
            //设置点击大头针之后显示的描述
            bigPin.subtitle = "\(placemark.thoroughfare)--\(placemark.subThoroughfare)"

            //添加大头针
            self.mapView.addAnnotation(bigPin)
        })
        print("经纬度\(newLocation.coordinate.longitude)====\(newLocation.coordinate.latitude)")
        
    }
    
    
     func setLocation(sender: UIButton) {
//        if self.currentCoordinate != nil {
//            self.mapView.setCenterCoordinate(self.currentCoordinate!, animated: true)
//        }
        
        self.locateMannage.startUpdatingLocation()
        mapView.showsUserLocation = true
        print("点击定位")
        // 编码
        CLGeocoder().geocodeAddressString("中国河南省郑州市金水区") { (pms, err) -> Void in
            let placemark:CLPlacemark = (pms?.last)!
            print(placemark.location!)
        }
    }
    
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

