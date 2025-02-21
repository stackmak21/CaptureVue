//
//  SectionItem.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import SwiftUI

struct SectionItem<LeadingIcon, Action>: View where LeadingIcon: View, Action: View {
    
    let label: String?
    let title: String?
    let message: String
    let description: String?
    let leadingIcon: () -> LeadingIcon
    let action: () -> Action
    
    init(
        label: String? = nil,
        title: String? = nil,
        message: String,
        description: String? = nil,
        leadingIcon: @escaping () -> LeadingIcon,
        action: @escaping () -> Action
    ) {
        self.label = label
        self.title = title
        self.message = message
        self.description = description
        self.leadingIcon = leadingIcon
        self.action = action
    }
    
    init(
        label: String? = nil,
        title: String? = nil,
        message: String,
        description: String? = nil,
        action: @escaping () -> Action
    )where LeadingIcon == EmptyView{
        self.init(
            label: label,
            title: title,
            message: message,
            description: description,
            leadingIcon: { EmptyView() },
            action: action
        )
    }
    
    init(
        label: String? = nil,
        title: String? = nil,
        message: String,
        description: String? = nil,
        leadingIcon: @escaping () -> LeadingIcon
    )where Action == EmptyView{
        self.init(
            label: label,
            title: title,
            message: message,
            description: description,
            leadingIcon: leadingIcon,
            action: { EmptyView() }
        )
    }
    
    var body: some View {
        VStack{
            if let labelValue = label{
                Text(labelValue)
                    .foregroundStyle(Color.black)
                    .font(Typography.medium(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack{
                leadingIcon()
                VStack{
                    Group{
                        if let titleValue = title{
                            Text(titleValue)
                                .foregroundStyle(Color.black)
                                .font(Typography.regular(size: 12))
                        }
                        Text(message)
                            .foregroundStyle(Color.black)
                            .font(Typography.medium(size: 14))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                action()
            }
        }
        .padding(.vertical, 4)
    }
}


#Preview {
    SectionItem(label: "Label", title: "Title", message: "Message", description: "Description", action: { ClickSectionAction() })
        .padding()
}
