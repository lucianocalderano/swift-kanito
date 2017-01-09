//
//  SubPetSrvDetail.h
//  kanito
//
//  Created by Luciano Calderano on 18/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, enumPetSrvDetailAction) {
    enumPetSrvDetailAction_Tel,
    enumPetSrvDetailAction_Eml,
    enumPetSrvDetailAction_Msg,
};

@protocol protocolSubPetServiceDett <NSObject>

- (void) delegateBtnClickedOnPetServiceDett:(enumPetSrvDetailAction)btnNum;

@end

@interface SubPetSrvDetail : UIView

@property (nonatomic, strong) NSDictionary *dicPetService;
@property (nonatomic, weak)   id delegate;

+ (instancetype)Instance;

@property (NS_NONATOMIC_IOSONLY, readonly) CGSize subResize;

@end
