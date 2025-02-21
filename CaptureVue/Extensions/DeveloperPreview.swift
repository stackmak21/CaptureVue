//
//  DeveloperPreview.swift
//  CaptureVue
//
//  Created by Paris Makris on 16/11/24.
//

import Foundation
import SwiftUI
import SwiftfulRouting


class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    
    private init() {
        
        let creatorInstance: CustomerDto = CustomerDto(id: "vdskkoskfowubuyydw8i", email: "parhsmakrhs@gmail.com", firstName: "Paris", lastName: "Makris", createdAt: 1730197765000, isVerified: true)
        
        eventDto = EventDto(
            id: "cp-12345",
            eventName: "Test event 1",
            mainImage: "https://picsum.photos/804/1009",
            eventDescription: "Test description 1",
            expires: 1735467926000,
            createdAt: 1730197768000,
//            dateStart: 0,
            dateEnd: 0,
            guests: 18,
            creator: creatorInstance,
            storiesList: [
                StoryItemDto(id: "075e147b-a701-4eaa-a1a6-b5167a857516", url: "https://picsum.photos/800/1000", previewUrl: "", type: .photo, creator: creatorInstance),
                StoryItemDto(id: "25b859ef-efd5-42f3-953f-a8a0d963c6fda3", url: "https://stream.mux.com/YiPdTw2SBszeSHknXe015bb00VLnkCbFiqXPK329h00MH4.m3u8", previewUrl: "", type: .photo, creator: creatorInstance),
                StoryItemDto(id: "672b239c-900e-49cf-9ed4-54f26b073eae", url: "https://picsum.photos/804/1000", previewUrl: "", type: .photo, creator: creatorInstance),
                StoryItemDto(id: "9371ef4e-2bab-49d5-a35e-7ec1e809e809", url: "https://picsum.photos/806/1000", previewUrl: "", type: .photo, creator: creatorInstance),
                StoryItemDto(id: "dd2393db-0eba-4dc1-afb9-b6755dc8b90c", url: "https://picsum.photos/803/1000", previewUrl: "", type: .photo, creator: creatorInstance),
                StoryItemDto(id: "ec3af1c2-0bf3-4eee-be7e-9407695d373d", url: "https://picsum.photos/805/1000", previewUrl: "", type: .photo, creator: creatorInstance),
            ],
            galleryList: [
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f5332c27f827", publicUrl: "https://stream.mux.com/YiPdTw2SBszeSHknXe015bb00VLnkCbFiqXPK329h00MH4.m3u8", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f5hgjc27f827", publicUrl: "https://picsum.photos/802/1002", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f5qw3c27f827", publicUrl: "https://picsum.photos/802/1003", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f589kc27f827", publicUrl: "https://picsum.photos/802/1004", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f53dbc27f827", publicUrl: "https://picsum.photos/802/1005", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f56hqcg27f827", publicUrl: "https://picsum.photos/802/1006", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f5hkycd8gjf27f827", publicUrl: "https://picsum.photos/802/1007", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a8678-f5hkys864ac27f827", publicUrl: "https://picsum.photos/803/1007", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12867a-f5hkyce5yy27f827", publicUrl: "https://picsum.photos/804/1007", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b87812a-f5hkygscoyh27f827", publicUrl: "https://picsum.photos/805/1007", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-4334661f-b12a-f5hkycsfdcb27f827", publicUrl: "https://picsum.photos/806/1007", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-556431f-b12a-f5hkycsfdcb27f827", publicUrl: "https://picsum.photos/807/1007", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431990-b12a-f5hkycsfdcb27f827", publicUrl: "https://picsum.photos/808/1007", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-4831f-b12a-f5hkycsfdcb27f827", publicUrl: "https://picsum.photos/809/1007", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f59hkycsfdcb27f827", publicUrl: "https://picsum.photos/803/1012", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f75hkycsfdcb27f827", publicUrl: "https://picsum.photos/802/1013", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f65hkycsfdcb27f827", publicUrl: "https://picsum.photos/802/1014", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a-f55hkycsfdcb27f827", publicUrl: "https://picsum.photos/802/1015", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b12a4-f5hkycsfdcb27f827", publicUrl: "https://picsum.photos/802/1016", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b122a-f5hkycsfdcb27f827", publicUrl: "https://picsum.photos/802/1018", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
                GalleryItemDto(id: "4637ef9d-a3bc-431f-b112a-f5hkycsfdcb27f827", publicUrl: "https://picsum.photos/802/1019", creatorId: "cpu-12345", createdAt: 1731422089000, eventId: "cp-12345", dataType: .photo, previewUrl: "", customer: creatorInstance),
            ]
        )
    }
    
   let eventDto: EventDto
    
    var event: Event {
        return eventDto.toEvent()
    }
    
    var galleryList: [GalleryItem] {
        return event.galleryList
    }
    var storiesList: [StoryItem] {
        return event.storiesList
    }
    var galleryItem: GalleryItem {
        return event.galleryList[0]
    }
    
    var storyItem: StoryItem {
        return event.storiesList[0]
    }
    
    
    
}


//"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"
