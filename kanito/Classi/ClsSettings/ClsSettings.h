//
//  ClsSettings.h
//  K Sport
//
//  Created by Luciano Calderano on 18/02/15.
//  Copyright (c) 2015 Kanito.it. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(unsigned int, userSettings) {
    userSetDogId,
    user001,
    userSetPicAlbumId,
    user003,
    user004,
    userArrayDataForPicsToUpload,
    userArrayListCities,
    user007,
    user008,
    user009,
    user010,
    user011,
    userPhotoLastDownload,
    userPhotoLoc,
    userPhotoAct,
    user015,
    userListDogs,
    userListAlbum,
    userBizNumOfCust,
    userBizNumOfDogs,
    user020,
    user021,
    userPhotoLocLastSelected,
    userPhotoActLastSelected,
    userTourDone,
};

@interface ClsSettings : NSObject

+ (void) setVal:(NSString *)value ForKey:(userSettings) userSet;
+ (NSString *) getValForKey:(userSettings) userSet;

+ (NSDictionary *) getObjForKey:(userSettings) userSet;
+ (void) setObj:(NSObject *)obj ForKey:(userSettings) userSet;

@end
