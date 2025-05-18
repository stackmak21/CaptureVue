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
    @State private var selectedItems: [PhotosPickerItem] = []
    @State var image: UIImage?
    
    @State var videoURL: URL?
    
    @State var sliderValue: Double = 0
    let sliderSteps: [Double] = [10, 20, 50, 100, 150, 200]
    
    init(router: AnyRouter, client: NetworkClient, eventRepositoryMock: EventRepositoryContract? = nil) {
        _vm = StateObject(wrappedValue: CreateEventViewModel(router: router, client: client, eventRepositoryMock: eventRepositoryMock))
    }
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.2).ignoresSafeArea()
            GeometryReader{ proxy in
                VStack(spacing: 0){
                    HStack{
                        TextField(text: $vm.eventName) {
                            Text("Paris Birthday")
                                .font(Typography.bold(size: 20))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                        }
                        .font(Typography.bold(size: 20))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
//                        Text("Paris Birthday")
//                            .font(Typography.bold(size: 20))
//                            .frame(maxWidth: .infinity, alignment: .center)
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
                            
                            if let image = vm.eventImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(height: proxy.size.height/3)
                                    .scaledToFill()
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
//                            
//                            PhotosPicker("Select a video", selection: $selectedItem, matching: .videos)
//                                .onChange(of: selectedItem) { _ in
//                                    Task {
//                                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
//                                            // Save the video data to a local file
//                                            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("selectedVideo.mp4")
//                                            do {
//                                                try data.write(to: tempURL)
//                                                print("Video saved to: \(tempURL)")
//                                                vm.startUpload(fileUrl: tempURL)
//                                            } catch {
//                                                print("Failed to save video: \(error)")
//                                            }
//                                            
//                                            // Use the file URL with Mux
//                                            
//                                        }
//                                    }
//                                }
                            
                            PhotosPicker("Select a Photo", selection: $selectedItem, matching: .images)
                                .onChange(of: selectedItem) { oldImage, newImage in
                                    Task {
                                        if let data = try? await newImage?.loadTransferable(type: Data.self) {
                                            if let selectedImage = UIImage(data: data) {
                                                vm.eventImage = selectedImage
                                            }
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
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(style: StrokeStyle(lineWidth: 2))
                                    .foregroundStyle(Color.black)
                            )

                            
                            
                            
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
    }
    
    private func loadVideo() async {
        guard let selectedItem else { return }
        
        do {
            // Attempt to get the local URL directly
            if let url = try await selectedItem.loadTransferable(type: URL.self) {
                vm.videoURL = url
                print("Video Local URL: \(url)")
            } else {
                // Fallback: Load as Data and save to a temporary file
                if let data = try await selectedItem.loadTransferable(type: Data.self) {
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mov")
                    try data.write(to: tempURL)
                    vm.videoURL = tempURL
                    print("Video saved to temporary URL: \(tempURL)")
                } else {
                    print("Failed to load video as URL or Data.")
                }
            }
        } catch {
            print("Error loading video: \(error)")
        }
    }
}



#Preview {
    
    RouterView{ router in
        CreateEventScreen(router: router, client: NetworkClient(), eventRepositoryMock: EventRepositoryMock())
    }
}
