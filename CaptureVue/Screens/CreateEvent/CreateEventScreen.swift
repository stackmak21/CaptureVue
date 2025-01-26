//
//  CreateEventScreen.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/1/25.
//

import SwiftUI
import SwiftfulRouting
import PhotosUI

struct CreateEventScreen: View {
    
    @StateObject var vm: CreateEventViewModel
    
    @State private var selectedItem: PhotosPickerItem?
    @State var image: Image?
    
    @State var sliderValue: Double = 0
    let sliderSteps: [Double] = [10, 20, 50, 100, 150, 200]
    
    init(router: AnyRouter, dataService: DataService) {
        _vm = StateObject(wrappedValue:CreateEventViewModel(router: router, interactor: CreateEventInteractor(dataService: dataService)))
    }
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.2).ignoresSafeArea()
            GeometryReader{ proxy in
                VStack(spacing: 0){
                    HStack{
                        Text("Paris Birthday")
                            .font(Typography.bold(size: 20))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .overlay(alignment: .trailing) {
                        Button(
                            action: {},
                            label: {
                                Image(systemName: "gear")
                                    .foregroundStyle(Color.black)
                            }
                        )
                        .padding(.horizontal)
                    }
                    .overlay(alignment: .leading) {
                        Button(
                            action: { vm.goBack() },
                            label: {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(Color.black)
                            }
                        )
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack{
                            
                            if let image {
                                image
                                    .resizable()
                                    .frame(height: proxy.size.height/3)
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding()
                                    .shadow(color: .black, radius: 6, x: 2, y: 4)
                            }else{
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(LinearGradient(colors: [.black.opacity(0.8), .black.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(height: proxy.size.height/3)
                                    .shadow(color: .black, radius: 6, x: 2, y: 4)
                                    .padding()
                                    .overlay(alignment: .center){
                                        
                                    }
                            }
                            PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                                .onChange(of: selectedItem) {
                                    Task {
                                        if let image = try? await selectedItem?.loadTransferable(type: Image.self) {
                                            self.image = image
                                        }
                                        
                                    }
                                }
                            
                            
                            
                            
                            Slider(value: $sliderValue, in: 0...Double(sliderSteps.count - 1), step: 1)
                                .onChange(of: sliderValue) { _, newValue in
                                    vm.guestsNum = Int(sliderSteps[Int(sliderValue)])
                                }
                            
                            SectionItem(
                                message: "Up to \(Int(sliderSteps[Int(sliderValue)])) guests",
                                leadingIcon: { LeadingSectionIcon("person.2") }
                            )
                            
                            
                            
                            Divider()
                            
                            SectionItem(
                                message: "Authorize Guest",
                                leadingIcon: { LeadingSectionIcon("person.badge.key") },
                                action: { Toggle(isOn: $vm.authorizeGuests, label: {}) }
                            )
                            
                            Divider()
                            
                            SectionItem(
                                message: "Guests Gallery",
                                leadingIcon: { LeadingSectionIcon("lock.open") },
                                action: { Toggle(isOn: $vm.guestsGallery, label: {}) }
                            )
                            
                            Divider()
                            
                            SectionItem(
                                message: "Start Date",
                                leadingIcon: { LeadingSectionIcon("calendar") },
                                action: {
                                    DatePicker(selection: $vm.startDate) {}
                                        .datePickerStyle(.compact)
                                        .accentColor(Color.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            )
                            
                            Divider()
                            
                            SectionItem(
                                message: "End Date",
                                leadingIcon: { LeadingSectionIcon("calendar") },
                                action: {
                                    DatePicker(selection: $vm.endDate) {}
                                        .datePickerStyle(.compact)
                                        .accentColor(Color.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            )
                            
                            Divider()
                            
                            Text("Event Description")
                                .foregroundStyle(Color.black)
                                .font(Typography.medium(size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                            
                            TextField(text: $vm.eventDescription) {
                                Text("Event Description")
                            }
                            .frame(minHeight: 50)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(style: StrokeStyle(lineWidth: 2))
                                    .foregroundStyle(Color.black)
                            )
                            .padding(.horizontal, 2)
                            
                            
                            
                            Spacer()
                            
                            Button(
                                action: {
                                    vm.publishEvent()
                                },
                                label: {
                                    Text("Publish")
                                        .font(Typography.medium(size: 18))
                                        .foregroundStyle(Color.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 55)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(Color.black)
                                        )
                                }
                            )
                            .buttonStyle(PlainButtonStyle())
                            .padding(.top)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            if vm.isLoading {
                ProgressView()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(LinearGradient(colors: [.white.opacity(0.8), .gray.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 1, y: 2)
                    )
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .controlSize(.regular)
            }
        }
        .navigationBarBackButtonHidden(true)
        //        .sheet(isPresented: .constant(true)) {
        //            Text("sheet")
        //        }
    }
}

extension Double{
    
    func toInt() -> Int {
        return Int(self)
    }
}

#Preview {
    let dataService = DataServiceImpl()
    RouterView{ router in
        CreateEventScreen(router: router, dataService: dataService)
    }
}

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

struct ClickSectionAction: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(Typography.medium(size: 14))
            .foregroundStyle(Color.black)
        
    }
}

struct LeadingSectionIcon: View {
    let systemName: String
    
    init(_ systemName: String) {
        self.systemName = systemName
    }
    
    var body: some View {
        Image(systemName: systemName)
            .font(Typography.medium(size: 16))
            .foregroundStyle(Color.black.opacity(0.8))
        
    }
}


