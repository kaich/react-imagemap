//
//  CKImageMapManager.m
//  ReactImageMap
//
//  Created by mk on 2017/12/4.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "CKRNImageMapManager.h"
#import "ReactImageMapExample-Swift.h"
#import <React/RCTUIManager.h>

@implementation CKRNImageMapManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(mapName, NSString)
RCT_EXPORT_VIEW_PROPERTY(imageURLString, NSString)
RCT_EXPORT_VIEW_PROPERTY(markers, NSArray)
RCT_EXPORT_VIEW_PROPERTY(showDefaultPopView, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onClickAnnotation, RCTBubblingEventBlock)


- (UIView *)view
{
  return [[CKReactImageMapView alloc] init];
}

RCT_EXPORT_METHOD(addMarker:(nonnull NSNumber *)reactTag
                  marker:(NSDictionary *) marker)
{
  [self.bridge.uiManager addUIBlock:
   ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, CKReactImageMapView *> *viewRegistry) {
     
     CKReactImageMapView *view = viewRegistry[reactTag];
     if (!view || ![view isKindOfClass:[CKReactImageMapView class]]) {
       RCTLogError(@"Cannot find RCTScrollView with tag #%@", reactTag);
       return;
     }
     
     [view addMarker:marker];
   }];
}

RCT_EXPORT_METHOD(mark:(nonnull NSNumber *)reactTag
                  marker:(NSDictionary *) marker)
{
  [self.bridge.uiManager addUIBlock:
   ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, CKReactImageMapView *> *viewRegistry) {
     
     CKReactImageMapView *view = viewRegistry[reactTag];
     if (!view || ![view isKindOfClass:[CKReactImageMapView class]]) {
       RCTLogError(@"Cannot find RCTScrollView with tag #%@", reactTag);
       return;
     }
     
     [view mark:marker];
   }];
}


RCT_EXPORT_METHOD(unmark:(nonnull NSNumber *)reactTag
                  marker:(NSDictionary *) marker)
{
  [self.bridge.uiManager addUIBlock:
   ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, CKReactImageMapView *> *viewRegistry) {
     
     CKReactImageMapView *view = viewRegistry[reactTag];
     if (!view || ![view isKindOfClass:[CKReactImageMapView class]]) {
       RCTLogError(@"Cannot find RCTScrollView with tag #%@", reactTag);
       return;
     }
     
     [view unmark:marker];
   }];
}


RCT_EXPORT_METHOD(checkMarked:(nonnull NSNumber *)reactTag
                  marker:(NSDictionary *) marker
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [self.bridge.uiManager addUIBlock:
   ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, CKReactImageMapView *> *viewRegistry) {
     
     CKReactImageMapView *view = viewRegistry[reactTag];
     if (!view || ![view isKindOfClass:[CKReactImageMapView class]]) {
       RCTLogError(@"Cannot find RCTScrollView with tag #%@", reactTag);
       return;
     }
     
     resolve([NSNumber numberWithBool:[view checkMarked:marker]]);
   }];
}

@end

