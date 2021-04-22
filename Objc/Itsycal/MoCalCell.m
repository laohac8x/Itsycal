//
//  MoCalCell.m
//
//
//  Created by Sanjay Madan on 12/3/14.
//  Copyright (c) 2014 mowglii.com. All rights reserved.
//

#import "MoCalCell.h"
#import "Themer.h"
#import "Sizer.h"
#import "Itsycal-Swift.h"

@implementation MoCalCell
{
	NSTextField *_textField;
	NSLayoutConstraint *_textFieldVerticalSpace;
	NSTextField *_lunarField;
}

- (instancetype)init
{
    CGFloat sz = SizePref.cellSize;
    self = [super initWithFrame:NSMakeRect(0, 0, sz, sz)];
    if (self) {
        _textField = [NSTextField labelWithString:@""];
        [_textField setFont:[NSFont systemFontOfSize:SizePref.fontSize weight:NSFontWeightMedium]];
        [_textField setTextColor:[NSColor blackColor]];
        [_textField setAlignment:NSTextAlignmentCenter];
        [_textField setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self addSubview:_textField];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textField]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField)]];
        
        _textFieldVerticalSpace = [NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:SizePref.cellTextFieldVerticalSpace];
        [self addConstraint:_textFieldVerticalSpace];

			_lunarField = [NSTextField labelWithString:@""];
			_lunarField.font = [NSFont systemFontOfSize:9.5];
			_lunarField.textColor = [NSColor colorNamed:@"LunarColor"];
			[self addSubview:_lunarField];
			_lunarField.backgroundColor = NSColor.brownColor;
        
        REGISTER_FOR_SIZE_CHANGE;
    }
    return self;
}

- (void)sizeChanged:(id)sender
{
    [_textField setFont:[NSFont systemFontOfSize:SizePref.fontSize weight:NSFontWeightMedium]];
    _textFieldVerticalSpace.constant = SizePref.cellTextFieldVerticalSpace;
}

- (void)setIsToday:(BOOL)isToday {
    _isToday = isToday;
    [self setNeedsDisplay:YES];
}

- (void)setIsHighlighted:(BOOL)isHighlighted {
    _isHighlighted = isHighlighted;
    [self updateTextColor];
}

- (void)setIsInCurrentMonth:(BOOL)isInCurrentMonth {
    _isInCurrentMonth = isInCurrentMonth;
    [self updateTextColor];
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected != _isSelected) {
        _isSelected = isSelected;
        [self setNeedsDisplay:YES];
    }
}

- (void)setIsHovered:(BOOL)isHovered
{
    if (isHovered != _isHovered) {
        _isHovered = isHovered;
        [self setNeedsDisplay:YES];
    }
}

- (void)setDotColors:(NSArray<NSColor *> *)dotColors
{
    _dotColors = dotColors;
    [self setNeedsDisplay:YES];
}

- (void)updateTextColor {
	_textField.textColor = self.isInCurrentMonth ? Theme.currentMonthTextColor : Theme.noncurrentMonthTextColor;
}

- (void)setTextColor:(NSColor*)color {
	_textField.textColor = color;
}

- (void)setFont:(NSFont*)font {
	_textField.font = font;
}

- (void)setString:(NSString*)string {
	_textField.stringValue = string;
}

- (void)setInteger:(NSInteger)value {
	_textField.integerValue = value;
}

- (void)setDisplayDate:(MoDate)date {
	[self setInteger:date.day];
	VNCalendar.lu
	_lunarField.integerValue = [VNCalendar];
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGFloat radius = SizePref.cellRadius;
    if (self.isToday) {
        [Theme.todayCellColor set];
        NSRect r = NSInsetRect(self.bounds, 3, 3);
        NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:r xRadius:radius yRadius:radius];
        [p setLineWidth:2];
        [p stroke];
    }
    else if (self.isSelected) {
        [Theme.selectedCellColor set];
        NSRect r = NSInsetRect(self.bounds, 3, 3);
        NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:r xRadius:radius yRadius:radius];
        [p setLineWidth:2];
        [p stroke];
    }
    else if (self.isHovered) {
        [Theme.hoveredCellColor set];
        NSRect r = NSInsetRect(self.bounds, 3, 3);
        NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:r xRadius:radius yRadius:radius];
        [p setLineWidth:2];
        [p stroke];
    }
    if (self.dotColors) {
        CGFloat sz = SizePref.cellSize;
        CGFloat dotWidth = SizePref.cellDotWidth;
        CGFloat dotSpacing = 1.5*dotWidth;
        NSRect r = NSMakeRect(0, 0, dotWidth, dotWidth);
        r.origin.y = self.bounds.origin.y + dotWidth + 2;
        if (self.dotColors.count == 0) {
            [_textField.textColor set];
            r.origin.x = self.bounds.origin.x + sz/2.0 - dotWidth/2.0;
            [[NSBezierPath bezierPathWithOvalInRect:r] fill];
        }
        else if (self.dotColors.count == 1) {
            [self.dotColors[0] set];
            r.origin.x = self.bounds.origin.x + sz/2.0 - dotWidth/2.0;
            [[NSBezierPath bezierPathWithOvalInRect:r] fill];
        }
        else if (self.dotColors.count == 2) {
            [self.dotColors[0] set];
            r.origin.x = self.bounds.origin.x + sz/2.0 - dotSpacing/2 - dotWidth/2.0;
            [[NSBezierPath bezierPathWithOvalInRect:r] fill];
            
            [self.dotColors[1] set];
            r.origin.x = self.bounds.origin.x + sz/2.0 + dotSpacing/2 - dotWidth/2.0;
            [[NSBezierPath bezierPathWithOvalInRect:r] fill];
        }
        else if (self.dotColors.count == 3) {
            [self.dotColors[0] set];
            r.origin.x = self.bounds.origin.x + sz/2.0 - dotSpacing - dotWidth/2.0;
            [[NSBezierPath bezierPathWithOvalInRect:r] fill];
            
            [self.dotColors[1] set];
            r.origin.x = self.bounds.origin.x + sz/2.0 - dotWidth/2.0;
            [[NSBezierPath bezierPathWithOvalInRect:r] fill];
            
            [self.dotColors[2] set];
            r.origin.x = self.bounds.origin.x + sz/2.0 + dotSpacing - dotWidth/2.0;
            [[NSBezierPath bezierPathWithOvalInRect:r] fill];
        }
    }
}

@end

