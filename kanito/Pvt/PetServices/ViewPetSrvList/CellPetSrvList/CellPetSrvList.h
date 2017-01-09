//
//  CellPetSrvList.h
//  kanito
//
//  Created by Luciano Calderano on 21/09/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellPetSrvListDelegate;

@interface CellPetSrvList : UITableViewCell

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL followStatus;
@property (nonatomic, strong) NSDictionary *dicPetSrv;
@property (nonatomic, strong) IBOutlet UIButton *btnFollow;

+ (NSString *) cellId;

@end

@protocol CellPetSrvListDelegate <NSObject>

- (void) followTapped:(CellPetSrvList *)cell;

@end
