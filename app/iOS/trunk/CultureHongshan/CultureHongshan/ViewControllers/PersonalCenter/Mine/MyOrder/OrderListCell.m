//
//  OrderListCell.m
//  CultureHongshan
//
//  Created by ct on 17/2/17.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "OrderListCell.h"

#import "MyOrderModel.h"



@interface OrderListCell ()

@property (nonatomic,strong) UIImageView *picView;//封面图片
@property (nonatomic,strong) UILabel  *typeLabel;//类型：活动 或 场馆
@property (nonatomic,strong) UILabel  *orderNumLabel;//订单号
@property (nonatomic,strong) UILabel  *orderTimeLabel;//订单时间
@property (nonatomic,strong) UILabel  *titleLabel;//标题
@property (nonatomic,strong) UILabel  *addressLabel;//地址:场馆名 或 活动的地址
@property (nonatomic,strong) UILabel  *dateLabel;//日期：
@property (nonatomic,strong) UILabel  *seatOrTimeLabel;//座位 或 时间段
@property (nonatomic,strong) UILabel  *moneyLabel;//总金额
@property (nonatomic,strong) UIButton *button;//订单状态按钮：只有显示“付款”时，才可以点击

@property (nonatomic, strong) MyOrderModel *model;

@end



@implementation OrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 类型
        self.typeLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FontYT(13) color:kWhiteColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByClipping];
        self.typeLabel.radius = 5;
        self.typeLabel.backgroundColor = kThemeDeepColor;
        [self.contentView addSubview:self.typeLabel];
        
        // 订单号
        self.orderNumLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FontYT(13) color:kLightLabelColor lineSpacing:0];
        [self.contentView addSubview:self.orderNumLabel];
        
        // 下单时间
        self.orderTimeLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FontYT(12) color:kLightLabelColor lineSpacing:0 align:NSTextAlignmentRight breakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:self.orderTimeLabel];
        
        //分割线1
        MYMaskView *line1 = [MYMaskView maskViewWithBgColor:RGB(240, 240, 240) frame:CGRectZero radius:0];
        [self.contentView addSubview:line1];
        
        // 封面图
        self.picView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.picView];
        
        // 标题
        self.titleLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FontYT(15) color:kDeepLabelColor lineSpacing:0];
        [self.contentView addSubview:self.titleLabel];
        
        // 地址
        self.addressLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FontYT(13) color:kLightLabelColor lineSpacing:0];
        [self.contentView addSubview:self.addressLabel];
        
        // 日期
        self.dateLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FontYT(13) color:self.addressLabel.textColor lineSpacing:0];
        [self.contentView addSubview:self.dateLabel];
        
        // 座位 或 时间段
        self.seatOrTimeLabel = [MYSmartLabel al_labelWithMaxRow:2 text:@"" font:FontYT(13) color:self.addressLabel.textColor lineSpacing:3 align:NSTextAlignmentLeft breakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:self.seatOrTimeLabel];
        
        //带边框线的视图
        MYMaskView *borderView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
        borderView.layer.borderWidth = 0.5;
        borderView.layer.borderColor = RGB(218, 218, 218).CGColor;
        [self.contentView addSubview:borderView];
        
        // 金额
        self.moneyLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FontYT(15) color:self.addressLabel.textColor lineSpacing:0];
        [borderView addSubview:self.moneyLabel];
        
        // 按钮
        self.button = [UIButton new];
        [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [borderView addSubview:self.button];
        
        // 底部分割线
        MYMaskView *bottomView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectZero radius:0];
        [self.contentView addSubview:bottomView];
        
        
        /********************************* 添加约束 *********************************/
        WS(weakSelf)
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(10);
            make.top.equalTo(weakSelf.contentView).offset(20);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        
        [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.typeLabel.mas_right).offset(5);
            make.centerY.height.equalTo(weakSelf.typeLabel);
        }];
        
        [self.orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(-10);
            make.centerY.height.equalTo(weakSelf.typeLabel);
            make.left.equalTo(weakSelf.orderNumLabel.mas_right).offset(10);
        }];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.typeLabel.mas_bottom).offset(5);
            make.left.equalTo(weakSelf.contentView).offset(6);
            make.right.equalTo(weakSelf.contentView).offset(-6);
            make.height.mas_equalTo(1);
        }];
        
        [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(10);
            make.top.equalTo(line1.mas_bottom).offset(20);
            make.height.mas_equalTo(85);
            make.width.equalTo(weakSelf.picView.mas_height).multipliedBy(1.5);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.picView.mas_right).offset(8);
            make.top.equalTo(weakSelf.picView);
            make.right.equalTo(weakSelf.contentView).offset(-10);
        }];
        
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(weakSelf.titleLabel);
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
        }];
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(weakSelf.titleLabel);
            make.top.equalTo(weakSelf.addressLabel.mas_bottom).offset(11.5);
        }];
        
        [self.seatOrTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(weakSelf.titleLabel);
            make.top.equalTo(weakSelf.dateLabel.mas_bottom).offset(7);
        }];
        
        
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(-2);
            make.right.equalTo(weakSelf.contentView).offset(2);
            make.top.equalTo(weakSelf.picView.mas_bottom).offset(27);
            make.height.mas_equalTo(40);
        }];
        
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(10);
            make.top.bottom.equalTo(borderView);
            make.right.equalTo(weakSelf.button.mas_left).offset(-10);
        }];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView);
            make.width.equalTo(weakSelf.contentView).multipliedBy(0.398); // 299/750
            make.top.bottom.equalTo(borderView);
        }];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf.contentView);
            make.top.equalTo(borderView.mas_bottom);
        }];
    }
    return self;
}



- (void)setModel:(MyOrderModel *)model listType:(NSInteger)listType {
    if (model)
    {
        if (_model) {
            _model = nil;
        }
        _model = model;
        
        _typeLabel.text = (_model.type == DataTypeActivity) ? @"活动" : @"场馆";
        _orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",_model.orderNumber];
        
        _orderTimeLabel.text = [DateTool dateStringForTimeSp:_model.orderCreatTime formatter:@"yyyy.MM.dd HH:mm" millisecond:NO];
        
        UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:_picView.viewSize centerSize:CGSizeMake(25, 25) isBorder:YES];
        [_picView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(_model.imageUrl, kImageSize_300_300)] placeholderImage:placeImg];
        
        _titleLabel.text = _model.titleStr;
        _addressLabel.text = _model.addressStr;
        
        
        if (_model.type == DataTypeActivity) {
            _dateLabel.text = _model.dateStr;
            if (_model.isSalesOnline) {
                _seatOrTimeLabel.attributedText = [UIToolClass getAttributedStr:[ToolClass getComponentString:_model.showedSeatArray combinedBy:@", "] font:_seatOrTimeLabel.font lineSpacing:4];
            }else{
                _seatOrTimeLabel.attributedText = nil;
                _seatOrTimeLabel.text = [NSString stringWithFormat:@"%d 人",(int)_model.peopleCount];
            }
        }else{
            _dateLabel.text = _model.dateStr;
            _seatOrTimeLabel.attributedText = nil;
            _seatOrTimeLabel.text = _model.timeStr;
        }
        
        //总金额
        if (_model.priceStr.length==0 || [_model.priceStr isEqualToString:@"免费"]) {
            _moneyLabel.attributedText = nil;
            _moneyLabel.text = [NSString stringWithFormat:@"总金额：免费"];
        }else if ([DataValidate isPureFloat:_model.priceStr]) {
            _moneyLabel.text = nil;
            NSString *price = [NSString stringWithFormat:@"总金额：￥%@", _model.priceStr];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price attributes:@{NSForegroundColorAttributeName:kDeepLabelColor, NSFontAttributeName:FontYT(15)}];
            [attributedString addAttribute:NSForegroundColorAttributeName value:kDarkRedColor range:NSMakeRange(4, _model.priceStr.length+1)];
            _moneyLabel.attributedText = attributedString;
        }else {
            _moneyLabel.attributedText = nil;
            _moneyLabel.text = [NSString stringWithFormat:@"总金额：收费"];
        }
        

        //按钮
        if (_model.type == DataTypeActivity) {
// 活动订单
            // 订单支付状态：0-无需支付  1-未支付  2-支付成功  3-退款中  4-退款成功
            // 订单状态  0.未定义  1.预订成功 2.已取消 3.已出票 4.已验票 5.已过期 6.已删除
            
            [self setButtonUserInteractionEnable:NO];
            
            switch (_model.orderStatus) {
                case 0:
                    [_button setTitle:@"未知状态" forState:UIControlStateNormal];
                    break;
                case 1: // 预订成功
                {
                    if (_model.orderPayStatus == 0) { // 无需支付
                        [_button setTitle:@"待使用" forState:UIControlStateNormal];
                    }else if (_model.orderPayStatus == 1) { // 未支付
                        _button.tag = 2;
                        [_button setTitle:@"去付款" forState:UIControlStateNormal];
                        [self setButtonUserInteractionEnable:YES];
                    }else if (_model.orderPayStatus == 2) { // 支付成功
                        [_button setTitle:@"待使用" forState:UIControlStateNormal];
                    }else if (_model.orderPayStatus == 3) { // 退款中
                        [_button setTitle:@"正在退款" forState:UIControlStateNormal];
                    }else if (_model.orderPayStatus == 4) { // 退款成功
                        [_button setTitle:@"退款成功" forState:UIControlStateNormal];
                    }else {
                        [_button setTitle:@"未知状态" forState:UIControlStateNormal];
                    }
                }
                    break;
                case 2:
                {
                    if (listType == 4 && _model.checkStatus == 2) {
                        [_button setTitle:@"审核未通过" forState:UIControlStateNormal];
                    }else {
                        if (_model.orderPayStatus == 3) { // 退款中
                            [_button setTitle:@"正在退款" forState:UIControlStateNormal];
                        }else if (_model.orderPayStatus == 4) { // 退款成功
                            [_button setTitle:@"退款成功" forState:UIControlStateNormal];
                        }else {
                            [_button setTitle:@"已取消" forState:UIControlStateNormal];
                        }
                    }
                }
                    break;
                case 3:
                    [_button setTitle:@"待使用" forState:UIControlStateNormal];
                    break;
                case 4:
                    [_button setTitle:@"已使用" forState:UIControlStateNormal];
                    break;
                case 5:
                    [_button setTitle:@"已过期" forState:UIControlStateNormal];
                    break;
                case 6:
                    [_button setTitle:@"已删除" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            
        }else {
// 活动室订单
            /*
             
             订单预订状态：
             0-需考虑认证状态 1-预订成功  2-已取消  3-已出票  4-已验票  5-已过期  6-已删除 7-订单审核未通过
             订单认证状态：
             -1.未定义的认证状态  0-未实名认证  1-实名认证中  2-实名认证未通过  3-未资质认证  4-资质认证中  5-资质认证未通过  6-资质认证已通过 7-使用者被冻结 (3-7表明实名认证已通过)
             
             */
            
            if (_model.orderStatus > 0)
            {
                [self setButtonUserInteractionEnable:NO];//右侧按钮不可点击
                
                switch (_model.orderStatus) {
                    case 1:
                        if (_model.tUserIsFreeze) {
                            [_button setTitle:@"" forState:UIControlStateNormal];
                        }else {
                            [_button setTitle:@"待使用" forState:UIControlStateNormal];
                        }
                        break;
                    case 2:
                        [_button setTitle:@"已取消" forState:UIControlStateNormal]; break;
                    case 3:
                        if (_model.tUserIsFreeze) {
                            [_button setTitle:@"" forState:UIControlStateNormal];
                        }else{
                            [_button setTitle:@"待使用" forState:UIControlStateNormal];
                        }
                        break;
                    case 4:
                        [_button setTitle:@"已使用" forState:UIControlStateNormal]; break;
                    case 5:
                        [_button setTitle:@"已过期" forState:UIControlStateNormal]; break;
                    case 6:
                        [_button setTitle:@"已删除" forState:UIControlStateNormal]; break;
                    case 7:
                        [_button setTitle:@"审核未通过" forState:UIControlStateNormal]; break;
                    default:
                        break;
                }
            }
            else if (_model.orderStatus == 0)
            {
                if (_model.tUserIsFreeze) {
                    [_button setTitle:@"" forState:UIControlStateNormal];//使用者被冻结
                    [self setButtonUserInteractionEnable:NO];//右侧按钮不可点击
                }else{
                    if (_model.certifyStatus == 6) {
                        [_button setTitle:@"待审核" forState:UIControlStateNormal];//实名和资质认证均通过，但订单未通过
                        [self setButtonUserInteractionEnable:NO];//右侧按钮不可点击
                    }
                    else
                    {
                        self.button.tag = 1;
                        [self setButtonUserInteractionEnable:YES];//右侧按钮可点击
                        if (_model.certifyStatus == 1 || _model.certifyStatus == 4) {
                            [_button setTitle:@"认证中" forState:UIControlStateNormal];
                        }else{
                            [_button setTitle:@"前往认证" forState:UIControlStateNormal];
                        }
                    }
                }
            }
        }
    }
}


- (void)setButtonUserInteractionEnable:(BOOL)isEnable {
    if (isEnable) {
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.titleEdgeInsets = UIEdgeInsetsZero;
        _button.userInteractionEnabled = YES;
        _button.titleLabel.font = FontYT(18);
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.backgroundColor = kThemeDeepColor;
    }else{
        _button.backgroundColor = [UIColor clearColor];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _button.userInteractionEnabled = NO;
        _button.titleLabel.font = FontYT(12);
        [_button setTitleColor:kLightLabelColor forState:UIControlStateNormal];
    }
}



- (void)buttonClick:(UIButton *)sender {
    if (self.actionHandler) {
        self.actionHandler(_model, sender.tag);
    }
}

@end
