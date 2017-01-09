//
//  MyBaseViewController
//

#import <UIKit/UIKit.h>

@protocol MYNavigationBarDelegate;
@class MYNavigationBar;

@interface MyBaseViewController : UIViewController <MYNavigationBarDelegate> {
    Class<MYNavigationBarDelegate> MyNavigationBarDelegate; // The type of the analytic class currently used.
}
@property (nonatomic, strong) MYNavigationBar *myNavigationBar;
@property (nonatomic, strong) IBInspectable NSString *titolo;
@property (nonatomic, strong) IBInspectable UIImage *dxIcon;

@end
