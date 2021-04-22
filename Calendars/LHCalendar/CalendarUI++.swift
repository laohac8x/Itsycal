//
//  CalendarUI++.swift
//  Calendars
//
//  Created by Nguyen Mau Dat on 19/11/2020.
//

import AppKit
import Cocoa
import Foundation
import SnapKit

extension CalendarUI {
  class Cell: BaseView {
    let textField: TextField = TextField()
    var date: Date?
    var isHighlighted: Bool = false { didSet { updateTextColor() } }
    var isHovered: Bool = false { didSet { setNeedsDisplay(bounds) } }
    var isSelected: Bool = false { didSet { setNeedsDisplay(bounds) } }
    var dotColors: [NSColor] = [] { didSet { setNeedsDisplay(bounds) } }
    private var cellTextFieldVerticalSpaceConstraint: Constraint?
    
    override func commonInit() {
      guard textField.superview != self else { return }
      
      let themSizer = Preference.shared.sizer
      frame = NSRect(x: 0, y: 0, width: themSizer.cellSize, height: themSizer.cellSize)
      textField.font = NSFont.systemFont(ofSize: themSizer.fontSize, weight: .medium)
      textField.textColor = .black
      textField.alignment = .center
      textField.translatesAutoresizingMaskIntoConstraints = false
      addSubview(textField)
      textField.snp.makeConstraints { [weak self] maker in
        maker.left.right.bottom.equalToSuperview()
        self?.cellTextFieldVerticalSpaceConstraint = maker.top.equalToSuperview().offset(themSizer.cellTextFieldVerticalSpace).constraint
      }
      
      NotificationCenter.default.addObserver(forName: .preferenceSizeDidChanged, object: nil, queue: .main) { [weak self] _ in
        self?.sizeDidChanged()
      }
    }
    
    private func sizeDidChanged() {
      let themSizer = Preference.shared.sizer
      textField.font = NSFont.systemFont(ofSize: themSizer.fontSize, weight: .medium)
      cellTextFieldVerticalSpaceConstraint?.update(offset: themSizer.cellTextFieldVerticalSpace)
    }
    
    private func updateTextColor() {
      guard let date = date else {
        textField.textColor = .clear
        return
      }
      
      textField.textColor = date.isThisMonth ? Preference.shared.currentMonthTextColor : Preference.shared.noncurrentMonthTextColor
    }
    
    - (void)drawRect:(NSRect)dirtyRect
    {
    CGFloat radius = [[Sizer shared] cellRadius];
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
    CGFloat sz = [[Sizer shared] cellSize];
    CGFloat dotWidth = [[Sizer shared] cellDotWidth];
    CGFloat dotSpacing = 1.5*dotWidth;
    NSRect r = NSMakeRect(0, 0, dotWidth, dotWidth);
    r.origin.y = self.bounds.origin.y + dotWidth + 2;
    if (self.dotColors.count == 0) {
    [self.textField.textColor set];
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
  }
}
