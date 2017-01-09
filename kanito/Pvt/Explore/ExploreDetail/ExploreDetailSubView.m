#import "ExploreDetailSubView.h"
#import "MyButtonRounded.h"
#import "ClsFollowin.h"

@interface ExploreDetailSubView ()  {
    IBOutlet UILabel *lblDogName;
    IBOutlet UILabel *lblDogInfo;
    IBOutlet UILabel *lblDesc;
    IBOutlet UILabel *lblNumLike;
    IBOutlet UILabel *lblInfo;

    IBOutlet MyButtonRounded *btnFoll;
    IBOutlet MyButtonRounded *btnLike;
    IBOutlet UIImageView *imvGender;

    BOOL followed;
    NSString *strDogId;
}
@property (nonatomic, weak) IBOutlet UIImageView *imvFotoCane;

@end

@implementation ExploreDetailSubView

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = self.view.frame;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    self.view.frame = rect;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.imvFotoCane.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *strId = [ClsUser uniqueId];
    if (strId.length == 0) {
        btnLike.alpha = 0.3;
        btnFoll.alpha = 0.3;
        lblNumLike.hidden = NO;
        followed = NO;
    }
    
    NSAttributedString *strAttr;
    strAttr = [ClsUtil attributedStringWithLeftImageName:@"like"
                                                 MaxSize:15
                                               RightText:keyLang(@"explDett.Like")];
    [btnLike setAttributedTitle:strAttr forState:UIControlStateHighlighted];
    strAttr = [ClsUtil attributedStringWithLeftImageName:@"unlike"
                                                 MaxSize:15
                                               RightText:keyLang(@"explDett.Dislike")];
    [btnLike setAttributedTitle:strAttr forState:UIControlStateNormal];

    strAttr = [ClsUtil attributedStringWithLeftImageName:@"plus" MaxSize:15
                                               RightText:keyLang(@"explDett.Follow")];
    [btnFoll setAttributedTitle:strAttr forState:UIControlStateHighlighted];
    strAttr = [ClsUtil attributedStringWithLeftImageName:@"meno"
                                                 MaxSize:15
                                               RightText:keyLang(@"explDett.Unfoll")];
    [btnFoll setAttributedTitle:strAttr forState:UIControlStateNormal];
    
    self.imvFotoCane.image = self.image;

    NSString *s;
    NSMutableString *str = [[NSMutableString alloc] init];
    s = self.dicData[@"DogBreed"];
    if (s.length > 0)
        [str appendFormat:@"%@, ", s];
    else
        [str appendFormat:@"%@, ", keyLang(@"explList.NoBreed")];

    s = self.dicData[@"DogSize"];
    if (s.length > 0)
        [str appendFormat:@"%@, ", s];
    s = self.dicData[@"DogAge"];
    if (s.length > 0)
        [str appendFormat:@"%@, ", s];
    if (str.length > 0)
        [str deleteCharactersInRange:NSMakeRange(str.length - 2, 2)];
    
    strDogId = self.dicData[@"dogId"];
    lblDogName.text = self.dicData[@"dogName"];
    lblDogInfo.text = str;
    NSString *s1 = [NSString stringWithFormat:@"%@: ", keyLang(@"explDett.UplBy")];
    NSString *s2 = self.dicData[@"owner_name"];
    NSString *s3 = [NSString stringWithFormat:@", %@: ", keyLang(@"explDett.Album")];
    NSString *s4 = self.dicData[@"albumName"];
    
    s = [NSString stringWithFormat:@"%@%@%@%@", s1, s2, s3, s4];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:s];
    NSInteger i = 0;
    [string addAttribute:NSForegroundColorAttributeName value:[MyColor myGreyDark] range:NSMakeRange(i, s1.length)];
    i += s1.length;
    [string addAttribute:NSForegroundColorAttributeName value:[MyColor myOrange]  range:NSMakeRange(i, s2.length)];
    i += s2.length;
    [string addAttribute:NSForegroundColorAttributeName value:[MyColor myGreyDark] range:NSMakeRange(i, s3.length)];
    i += s3.length;
    [string addAttribute:NSForegroundColorAttributeName value:[MyColor myOrange]  range:NSMakeRange(i, s4.length)];
    lblDesc.attributedText = string;
    
    followed = [ClsFollowin isIdFollowed:strDogId Type:FollowTypeDog];
    
    [self updateFollowButton];
    [self checkLike];
    NSString *strIcoGender = ([self.dicData[@"dogGender"] integerValue] == 0) ? @"genderMalBlue" : @"genderFemPink";
    imvGender.image = [UIImage imageNamed:strIcoGender];
    [self updateNumLike:self.dicData[@"pats"]];
    
    [str setString:self.dicData[@"location_name"]];
    s = self.dicData[@"action_name"];
    if (s.length > 0) {
        if (str.length > 0)
            [str appendString:@", "];
        [str appendString:s];
    }
    s = self.dicData[@"sport_name"];
    if (s.length > 0) {
        if (str.length > 0)
            [str appendString:@", "];
        [str appendString:s];
    }
    lblInfo.text = str;
}


- (void)setImage:(UIImage *)image {
    if (self.imvFotoCane.image.size.height < image.size.height) {
        _image = image;
        self.imvFotoCane.image = image;
    }
}


#pragma mark - UI update

- (void) updateNumLike:(NSObject *) objLike {
    lblNumLike.text = keyLang(@"explDett.NumLike");
    NSString *s = [NSString stringWithFormat:@"%@", objLike];
    lblNumLike.text = [lblNumLike.text stringByReplacingOccurrencesOfString:@"#" withString:s];
}

- (void) updateLikeButton:(NSString *) strLike {
    btnLike.highlighted = (strLike.integerValue == 0) ? YES : NO;
}

- (void) updateFollowButton {
    btnFoll.highlighted = (followed) ? NO : YES;
}


#pragma mark - Follow update

- (IBAction) tapViewFoll {
    NSString *strId = [ClsUser userId];
    if (strId.length == 0)
        return;
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"follow-function";
    request.json = @{
                     @"action"         : (followed) ? @"unfollow" : @"follow",
                     @"followed_id"    : strDogId,
                     @"followed_type"  : (defTypeDog).uppercaseString,
                     @"follower_id"    : strId,
                     @"follower_type"  : [ClsUser userType],
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 followed = !followed;
                 [ClsFollowin followedIdUpdate:strDogId Add:followed Type:FollowTypeDog];
                 [self updateFollowButton];
             }];
}
#pragma mark - Like section

- (IBAction) tapViewLike {
    NSString *strId = [ClsUser uniqueId];
    if (strId.length == 0)
        return;
    
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"pats-function";
    request.json = @{
                     @"user_id"   : strId,
                     @"file_id"   : [self.dicData getString:@"fileId"],
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 [self updateLikeButton:[resultDict getString:@"File.like"]];
             }];
}


- (void)checkLike {
    NSString *strId = [ClsUser uniqueId];
    if (strId.length == 0)
        return;
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = nil;
    request.page = @"check-pats";
    request.json = @{
                     @"user_id" : strId,
                     @"file_id" : [self.dicData getString:@"fileId"],
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 [self updateLikeButton:[resultDict getString:@"Dog.patted"]];
                 [self updateNumLike:[resultDict getString:@"Dog.pats"]];
             }];
}

@end
