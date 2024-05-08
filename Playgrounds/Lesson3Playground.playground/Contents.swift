import UIKit

protocol EventType {
    var EventTypeName: String {get}
}

protocol AnalyticEvent {
    associatedtype TypeOfEvent:EventType
    
    var type: EventType {get}
    
    var parameters: [String:Any] {get}
}

extension AnalyticEvent{
    var  name:String {
        return type.EventTypeName
    }
}

struct ScreenEventType:EventType{
    
    var EventTypeName: String
    
}

struct ScreenViewEvent:AnalyticEvent{

    typealias TypeOfEvent = ScreenEventType
    
    var type: any EventType
    
    var parameters: [String : Any]
    
}


struct UserActionEventType:EventType{
    
    var EventTypeName: String
    
}


struct UserActionEvent:AnalyticEvent{
    
    typealias TypeOfEvent = UserActionEventType
    
    var type: any EventType
    
    var parameters: [String : Any]
    
}

protocol AnalyticsService{
    mutating func logEvent<Event:AnalyticEvent>(_ event: Event)
}

struct RandomAnalyticsService:AnalyticsService{
    var logs:[String] = []
    
    mutating func logEvent<Event>(_ event: Event) where Event : AnalyticEvent {
        print(event.name)
        print(event.parameters)
        logs.append(event.name)
    }
    
}


//implementation part

var randomAnalyticsService = RandomAnalyticsService()

let leftSwipeEvent = ScreenViewEvent(
    type: ScreenEventType(EventTypeName:"swipedLeft"),
    parameters: ["action" : "swipeLeft", "User" : "Mustafa"]
)

randomAnalyticsService.logEvent(leftSwipeEvent)


let rightSwipeEvent = ScreenViewEvent(
    type: ScreenEventType(EventTypeName:"swipedRight"),
    parameters: ["action" : "swipeRigth", "User" : "Cicciolina"]
)

randomAnalyticsService.logEvent(rightSwipeEvent)

let userUploadPhoto = UserActionEvent(
    type: UserActionEventType(EventTypeName: "Photo Upload"),
    parameters:["action" : "Photo Upload", "User" : "Cicciolina"])

randomAnalyticsService.logEvent(userUploadPhoto)


print("All logs: \(randomAnalyticsService.logs)")










