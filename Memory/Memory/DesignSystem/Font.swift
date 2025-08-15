//
//  Font.swift
//  Memory
//
//  Created by 황채웅 on 8/11/25.
//

import SwiftUICore

enum AlloFontName: String, CaseIterable {
    case bold = "Pretendard-Bold"
    case semibold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
}

public enum AlloFontStyle {
    case headline1
    case headline2
    case headline3
    case headline4
    
    case big48
    case big44
    case big40
    case big36
    case big32
    
    case subtitle1
    case subtitle2
    case subtitle3
    case subtitle4
    case subtitle5
    case subtitle6
    case subtitle7
    
    case body1
    case body2
    case body3
    case body4
    case body5
    case body6
    
    case button1
    case button2
    case button3
    
    case caption1
    case caption2
    case caption3
    
    var weight: String {
        switch self {
        case
                .headline1, .headline3,
                .subtitle5,
                .body1, .body2, .body5:
            return "Pretendard-Bold"
        case
                .headline2, .headline4,
                .subtitle1, .subtitle3, .subtitle6,
                .button1, .button2,
                .caption1:
            return "Pretendard-SemiBold"
        case
                .subtitle2, .subtitle4, .subtitle7,
                .body3, .body6,
                .button3:
            return "Pretendard-Medium"
        case
                .body4,
                .caption2,
                .caption3:
            return "Pretendard-Regular"
        case .big48:
            return "Pretendard-Bold"
        case .big44:
            return "Pretendard-Bold"
        case .big40:
            return "Pretendard-SemiBold"
        case .big36:
            return "Pretendard-Medium"
        case .big32:
            return "Pretendard-Regular"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .big32:
            return 32
        case .big36:
            return 36
        case .big40:
            return 40
        case .big44:
            return 44
        case .big48:
            return 48
        case .headline1:
            return 76
        case
                .headline2,
                .subtitle4:
            return 28
        case .headline3, .headline4:
            return 24
        case .subtitle1, .subtitle2:
            return 20
        case .subtitle3, .subtitle5, .subtitle6, .subtitle7:
            return 18
        case
                .body1,
                .button1:
            return 16
        case
                .body2, .body3, .body4,
                .button2,
                .caption1, .caption2:
            return 14
        case
                .body5, .body6,
                .button3:
            return 12
        case .caption3:
            return 11
        }
    }
    
    var lineSpacing: CGFloat {
        switch self {
        case .headline1:
            return 50
        case .headline2:
            return 42
        case .headline3, .headline4:
            return 34
        case .subtitle1, .subtitle2:
            return 30
        case .subtitle3, .subtitle4:
            return 28
        case .subtitle5, .subtitle6:
            return 26
        case
                .body1, .body2, .body3,
                .subtitle7,
                .button1:
            return 24
        case .body5, .body6:
            return 22
        case
                .body4,
                .button2, .button3,
                .caption1, .caption2, .caption3:
            return 20
        case .big32:
            return 32
        case .big36:
            return 36
        case .big40:
            return 40
        case .big44:
            return 44
        case .big48:
            return 48
        }
    }
    
    var kerning: CGFloat {
        switch self {
        case
                .headline1, .headline2, .headline3,
                .subtitle1, .subtitle2, .subtitle3, .subtitle4, .subtitle5, .subtitle6, .subtitle7,
                .body1, .body2, .body3, .body4, .body5, .body6:
            return -(size * 0.02)  // -2% 자간
        case
                .headline4,
                .button1, .button2, .button3,
                .caption1, .caption2, .caption3:
            return 0
        case .big48, .big44, .big40, .big36, .big32:
            return -(size * 0.02)
        }
    }
    var font: Font {
        .custom(weight, size: CGFloat(size))
    }
}

extension Font {
    static let headline1 = AlloFontStyle.headline1.font
    static let headline2 = AlloFontStyle.headline2.font
    static let headline3 = AlloFontStyle.headline3.font
    static let headline4 = AlloFontStyle.headline4.font
    static let subtitle1 = AlloFontStyle.subtitle1.font
    static let subtitle2 = AlloFontStyle.subtitle2.font
    static let subtitle3 = AlloFontStyle.subtitle3.font
    static let subtitle4 = AlloFontStyle.subtitle4.font
    static let subtitle5 = AlloFontStyle.subtitle5.font
    static let subtitle6 = AlloFontStyle.subtitle6.font
    static let subtitle7 = AlloFontStyle.subtitle7.font
    
    static let body1 = AlloFontStyle.body1.font
    static let body2 = AlloFontStyle.body2.font
    static let body3 = AlloFontStyle.body3.font
    static let body4 = AlloFontStyle.body4.font
    static let body5 = AlloFontStyle.body5.font
    static let body6 = AlloFontStyle.body6.font
    
    static let button1 = AlloFontStyle.button1.font
    static let button2 = AlloFontStyle.button2.font
    static let button3 = AlloFontStyle.button3.font
    
    static let caption1 = AlloFontStyle.caption1.font
    static let caption2 = AlloFontStyle.caption2.font
    static let caption3 = AlloFontStyle.caption3.font
    
    static let big32 = AlloFontStyle.big32
    static let big36 = AlloFontStyle.big36
    static let big40 = AlloFontStyle.big40
    static let big44 = AlloFontStyle.big44
    static let big48 = AlloFontStyle.big48
}

extension View {
    func font(_ style: AlloFontStyle) -> some View {
        self
            .font(style.font)
            .lineSpacing(style.lineSpacing - style.size)
            .kerning(style.kerning)
            .frame(minHeight: style.lineSpacing)
    }
}

public struct Fonts {
    public static func registerCustomFonts() {
        AlloFontName.allCases.forEach { font in
            guard let url = Bundle.main.url(forResource: font.rawValue, withExtension: "ttf") else { return }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
