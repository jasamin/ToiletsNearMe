//
//  CVMapVC.m
//  ToiletNearMe
//
//  Created by Hanrun on 2018/9/13.
//  Copyright © 2018年 Carvin. All rights reserved.
//

#import "CVMapVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Masonry.h>
#import "CVRegisterLoginVC.h"

@interface CVMapVC ()<MAMapViewDelegate,AMapSearchDelegate>
@property(strong,nonatomic) MAMapView *mapView;
@property(strong,nonatomic) AMapSearchAPI *search;
@property(assign,nonatomic) BOOL firstUpdateUserLocation;
@property (nonatomic, strong) NSArray<AMapPOI *> *pois;
@end

@implementation CVMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    [self presentViewController:[[CVRegisterLoginVC alloc]init] animated:YES completion:nil];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (!_firstUpdateUserLocation) {
        _firstUpdateUserLocation = !_firstUpdateUserLocation;
        [self poiListInfo];
    }
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout = YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0) {
        return;
    }
    
    //解析response获取POI信息，具体解析见 Demo
    __block CVMapVC *blockSelf = self;
    _pois = response.pois;
    [_pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
        pointAnnotation.title = obj.name;
        pointAnnotation.subtitle = obj.type;
        [blockSelf.mapView addAnnotation:pointAnnotation];
    }];
    [_mapView showAnnotations:_mapView.annotations animated:YES];
}

- (void)poiListInfo {
    
    if (!self.search) {
        [AMapServices sharedServices].apiKey = Mapkey;
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.keywords            = @"厕所|公厕|KFC|麦当劳|网吧";
    /*  搜索服务 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.location            = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude];
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:request];
}

- (MAMapView *)mapView {
    if (!_mapView) {
        [AMapServices sharedServices].apiKey = Mapkey;
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.zoomLevel = 18;
    }
    return _mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
