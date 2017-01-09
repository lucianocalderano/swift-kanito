//
//  ClsUser.m
//  CyberGuide
//
//  Created by Sviluppo IOS on 25/02/14.
//  Copyright (c) 2014 Sviluppo IOS. All rights reserved.
//

#import "ClsPetSrv.h"

@implementation ClsPetSrv

static ClsPetSrv  *cls = nil;
static NSUserDefaults *userDefaultPetSrv;
static NSString *keyPetSrvLangId;
static NSString *keyPetSrvListDate = @"PetSrvLastDownloadDate";
static NSString *keyPetSrvSelected = @"PetSrvSelected";
static NSString *keyPetSrvSelectedCity = @"PetSrvCity";

static NSString *strUseDefaultPetSrv = @"PetServicesSavedData";
static NSString *strPetSrvPathImage = @"Pet.Activities.Images";

#pragma mark Singleton Methods

+ (void) open {
    static dispatch_once_t onceToken;
    if (cls == nil) {
        dispatch_once(&onceToken, ^{
            cls = [[super alloc] init];
            
            userDefaultPetSrv = [[NSUserDefaults alloc] initWithSuiteName:strUseDefaultPetSrv];
            strPetSrvPathImage = [NSTemporaryDirectory() stringByAppendingPathComponent:strPetSrvPathImage];
            NSError *err;
            if ([[NSFileManager defaultManager] fileExistsAtPath:strPetSrvPathImage] == NO) {
                [userDefaultPetSrv removeObjectForKey:keyPetSrvListDate];
                [userDefaultPetSrv synchronize];

                [[NSFileManager defaultManager] createDirectoryAtPath:strPetSrvPathImage withIntermediateDirectories:YES attributes:nil error:&err];
            }
        });
    }
}

+ (id) getClassId {
    return cls;
}

- (NSInteger) dayDiff:(NSDate *) date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    return components.day;
}

#pragma mark - Images Pet Activities

+ (NSDictionary *) getSavedPetServicesList {
    [self open];
    keyPetSrvLangId = [ClsLang langId];
    NSDate *d = [userDefaultPetSrv objectForKey:keyPetSrvListDate];
    if (d == nil)
        return nil;
    if ([cls dayDiff:d] > 30) // > 30 days ago, reload
        return nil;
    NSDictionary *dic = [userDefaultPetSrv objectForKey:keyPetSrvLangId];
    return dic;
}

static NSString *strKeyGrp = @"group_name";

typedef void(^myCompletionSuccess)(NSData *);
typedef void(^myCompletionError)();

- (void) loadImageWithUrl:(NSString *)strImageName
                 PetSrvId:(NSString *)strId
                ImageType:(enumPetActivityImageType)enumImageType
              ErrorAction:(myCompletionError)errorBlock
            SuccessAction:(myCompletionSuccess)successBlock {

    NSData *dat;
    NSString *strFile = [cls getImagePathNameWithId:strId
                                          ImageType:enumImageType];
/*
    dat = [NSData dataWithContentsOfFile:strFile];
    if (dat.length > 0) {
        successBlock (dat);
        return;
    }
*/
    if (strImageName.length == 0)
        dat = UIImagePNGRepresentation([UIImage imageNamed:@"CaneArancio"]);
    else
        dat = [NSData dataWithContentsOfURL:[cls urlWithString:strImageName]];

    if (dat.length > 0) {
        [dat writeToFile:strFile atomically:YES];
        successBlock (dat);
    }
    else {
        [UIImagePNGRepresentation(defImageK) writeToFile:strFile
                                              atomically:YES];
        errorBlock ();
    }
}

+ (void) setPetSrvListAndSaveImages:(NSDictionary *) dicPet {
    [self open];
    __block BOOL perfect = YES;
    NSArray *arr = dicPet[@"activities"];
    for (NSDictionary *dicGrp in arr) {
        for (NSString *s in dicGrp.allKeys) {
            NSDictionary *dic = dicGrp[s];
            if ([s isEqualToString:strKeyGrp])
                continue;
            NSString *strIdActivity = dic[@"id"];
            [cls loadImageWithUrl:dic[@"image_on"]
                         PetSrvId:strIdActivity
                        ImageType:enumPetActivityImageTypeOn
                      ErrorAction:^() {
                          perfect = NO;
                      } SuccessAction:^(NSData *datImg) {
                      }];
        }
    }
    if (perfect) {
        [userDefaultPetSrv setObject:dicPet forKey:keyPetSrvLangId];
        [userDefaultPetSrv setObject:[NSDate date] forKey:keyPetSrvListDate];
    }
    else {
        [userDefaultPetSrv removeObjectForKey:keyPetSrvListDate];
    }
    [userDefaultPetSrv synchronize];
}

+ (UIImage *) getImagePetActivityWithId:(NSString *)strId {
    NSString *strFile = [cls getImagePathNameWithId:strId
                                          ImageType:enumPetActivityImageTypeOn];
    NSData *dat = [NSData dataWithContentsOfFile:strFile];
    UIImage *img;
    if (dat.length > 0)
        img = [UIImage imageWithData:dat];
    else
        img = defImageK;
    return img;
}


+ (UIImage *) toGrayscale:(UIImage *) img {
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    CGRect imageRect = CGRectMake(0, 0, img.size.width * img.scale, img.size.height * img.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    memset(pixels, 0, width * height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), img.CGImage);
    
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            uint8_t gray = (uint8_t) ((166 * rgbaPixel[RED] + 166 * rgbaPixel[GREEN] + 166 * rgbaPixel[BLUE]) / 100);
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:img.scale
                                           orientation:UIImageOrientationUp];
    CGImageRelease(image);
    return resultUIImage;
}


static NSString *strHttp = @"http://";

- (NSURL *) urlWithString:(NSString *) strUrl {
    NSURL *url;
    if ([[strUrl substringToIndex:strHttp.length] isEqualToString:strHttp] == NO)
        strUrl = [strHttp stringByAppendingString:strUrl];
    url = [NSURL URLWithString:strUrl];
    return url;
}

- (NSString *) getImagePathNameWithId:(NSString *) strId
                            ImageType:(enumPetActivityImageType) enumImageType {
    NSString *strFile = [NSString stringWithFormat:@"%@/%@.%02d.png", strPetSrvPathImage, strId, enumImageType];
    return strFile;
}

- (void) saveIconWithId:(NSString *)strId Image:(UIImage *)img {
    img = [ClsUtil imageResize:img MaxSize:20];
    NSString *strFile = [cls getImagePathNameWithId:strId
                                          ImageType:enumPetActivityImageTypeIco];
    [UIImagePNGRepresentation(img) writeToFile:strFile atomically:YES];
}

+ (UIImage *) getIconPetActivityWithId:(NSString *)strId MaxSize:(CGFloat) maxSize {
    NSString *strFile = [cls getImagePathNameWithId:strId
                                          ImageType:enumPetActivityImageTypeOn];
    NSData *dat = [NSData dataWithContentsOfFile:strFile];
    UIImage *img;
    if (dat.length > 0)
        img = [UIImage imageWithData:dat];
    else
        img = defImageK;
    img = [ClsUtil imageResize:img MaxSize:maxSize];
    return img;
}

+ (UIImage *) getImagePetActivityWithId:(NSString *)strId
                              ImageType:(enumPetActivityImageType) imageType {
    NSString *strFile = [cls getImagePathNameWithId:strId
                                          ImageType:imageType];
    NSData *dat = [NSData dataWithContentsOfFile:strFile];
    UIImage *img;
    if (dat.length > 0)
        img = [UIImage imageWithData:dat];
    else
        img = defImageK;
    return img;
}

#pragma mark - Pet Activities Selection

+ (NSArray *) getPetServicesIdSelected {
    [self open];
    NSArray *arr = [userDefaultPetSrv objectForKey:keyPetSrvSelected];
    return arr;
}

+ (void) setPetSrvSelected:(NSArray *) arrSel {
    [self open];
    [userDefaultPetSrv setObject:arrSel forKey:keyPetSrvSelected];
    [userDefaultPetSrv synchronize];
}

+ (NSString *) getPetServicesIdSelectedCityId {
    [self open];
    NSDictionary *dic = [userDefaultPetSrv objectForKey:keyPetSrvSelectedCity];
    if (dic == nil)
        return @"";
    NSString *s = dic[@"id"];
    return s;
}

+ (void) setPetSrvSelectedCity:(NSDictionary *) dicCity {
    [self open];
    [userDefaultPetSrv setObject:dicCity forKey:keyPetSrvSelectedCity];
    [userDefaultPetSrv synchronize];
}

#pragma mark - Download Pet Services

+ (void)loadPetSrvListPagNum:(NSInteger) pagNum
                    mainView:(UIView *) mainView
                   MaxRecord:(NSInteger) maxRec
                       Complete:(void (^)(NSString *strNumRec))completionBlock {
    CGRect rect = [UIScreen mainScreen].bounds;
    NSString *strMyId = [ClsUser userId];
    NSString *strType = @"";
    if (strMyId.length > 0)
        strType = [ClsUser userType];
    else
        strMyId = @"";
    
    NSString *strCityId = cls.dicSelectedCity[@"id"];
    if (strCityId.length == 0) {
        strCityId = @"";
    }
    else {
        cls.coordinateStart = CLLocationCoordinate2DMake(41, 22);
    }
    if (cls.fltMaxDistance == 0)
        cls.fltMaxDistance = 20;
    cls.arrPetServices = nil;

    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = mainView;
    request.page = @"biz/retrieve-list";
    request.json = @{
                     @"lang_id"       : [ClsLang langId],
                     @"page"          : @(pagNum),
                     @"maxrecords"    : @(maxRec),
                     @"img_width"     : @(rect.size.width),
                     @"img_height"    : @(160),
                     @"img_crop"      : @(1),
                     @"img_bg"        : @"e7edef",
                     @"user_id"       : strMyId,
                     @"user_type"     : strType,
                     @"filters[activities]"   : [ClsPetSrv getPetServicesIdSelected],
                     @"filters[province]"     : strCityId,
                     @"point[max_distance]"   : @(cls.fltMaxDistance),
                     @"point[lat]"            : @(cls.coordinateStart.latitude),
                     @"point[lng]"            : @(cls.coordinateStart.longitude),
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 NSInteger status = [resultDict getString:@"status"].integerValue;
                 if (status > 0) {
                     cls.arrPetServices = resultDict[@"biz_list"];
                 }
                 completionBlock ([NSString stringWithFormat:@"%@", resultDict[@"total_records"]]);
             }];
}

@end
