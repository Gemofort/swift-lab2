
import Foundation

enum TimeError: Error {
    case dateError(String)
}

class TimeIF {
    var seconds: NSInteger;
    var minutes: NSInteger;
    var hours: NSInteger;
    
    init(sec seconds: NSInteger = 0, min minutes: NSInteger = 0, hr hours: NSInteger = 0) throws {
        if (0...59).contains(seconds) && (0...59).contains(minutes) && (0...23).contains(hours) {
            self.seconds = seconds;
            self.minutes = minutes;
            self.hours = hours;
        } else {
            throw TimeError.dateError("Invalid date format passed");
        }
    }
    
    init(date: Date) {
        let calendar = Calendar.current
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))
        self.hours = calendar.component(.hour, from: date)
        self.minutes = calendar.component(.minute, from: date)
        self.seconds = calendar.component(.second, from: date)
    }
    
    func pad(num: NSInteger) -> String {
        return num > 10 ? "\(num)" : "0\(num)"
    }
    
    func toString() -> String {
        return "\(self.hours > 12 ? "\(self.hours - 12)" : pad(num: self.hours)):\(pad(num: self.minutes)):\(pad(num: self.seconds)) \(self.hours > 12 ? "PM" : "AM")";
    }
    
    func sum(inc: TimeIF) throws -> TimeIF {
        let seconds = (self.seconds + inc.seconds) % 60;
        let minutesIncr = (self.seconds + inc.seconds) / 60;
        let minutes = (self.minutes + inc.minutes + minutesIncr) % 60;
        let hoursIncr = (self.minutes + inc.minutes + minutesIncr) / 60;
        let hours = (self.hours + inc.hours + hoursIncr) % 24;
        return try TimeIF(sec: seconds, min: minutes, hr: hours);
    }
    
    func diff(dif: TimeIF) throws -> TimeIF {
        let seconds = self.seconds - dif.seconds < 0 ? 60 + self.seconds - dif.seconds : self.seconds - dif.seconds ;
        let minutesDif = self.seconds - dif.seconds < 0 ? 1 : 0;
        let minutes = (self.minutes - dif.minutes - minutesDif) < 0 ? 60 + self.minutes - dif.minutes - minutesDif : self.minutes - dif.minutes - minutesDif;
        let hoursDif = (self.minutes - dif.minutes - minutesDif) < 0 ? 1 : 0;
        let hours = (self.hours - dif.hours - hoursDif) < 0 ? 24 + self.hours - dif.hours - hoursDif : self.hours - dif.hours - hoursDif;
        return try TimeIF(sec: seconds, min: minutes, hr: hours)
    }
    
    static func sum (inc1: TimeIF, inc2: TimeIF) throws -> TimeIF {
        let seconds = (inc1.seconds + inc2.seconds) % 60;
        let minutesIncr = (inc1.seconds + inc2.seconds) / 60;
        let minutes = (inc1.minutes + inc2.minutes + minutesIncr) % 60;
        let hoursIncr = (inc1.minutes + inc2.minutes + minutesIncr) / 60;
        let hours = (inc1.hours + inc2.hours + hoursIncr) % 24;
        return try TimeIF(sec: seconds, min: minutes, hr: hours)
    }
    
    static func diff(dif1: TimeIF, dif2: TimeIF) throws -> TimeIF {
        let seconds = dif1.seconds - dif2.seconds < 0 ? 60 + dif1.seconds - dif2.seconds : dif1.seconds - dif2.seconds ;
        let minutesDif = dif1.seconds - dif2.seconds < 0 ? 1 : 0;
        let minutes = (dif1.minutes - dif2.minutes - minutesDif) < 0 ? 60 + dif1.minutes - dif2.minutes - minutesDif : dif1.minutes - dif2.minutes - minutesDif;
        let hoursDif = (dif1.minutes - dif2.minutes - minutesDif) < 0 ? 1 : 0;
        let hours = (dif1.hours - dif2.hours - hoursDif) < 0 ? 24 + dif1.hours - dif2.hours - hoursDif : dif1.hours - dif2.hours - hoursDif;
        return try TimeIF(sec: seconds, min: minutes, hr: hours)
    }
}

do {
    let time = try TimeIF(sec: 59, min: 59, hr: 23);
    let time1 = try TimeIF(sec: 1, min: 0, hr: 12);
    let time2 = try TimeIF(sec: 59, min: 12, hr: 12);
    let time3 = try TimeIF(sec: 30, min: 47, hr: 11);
    let time4 = try TimeIF(sec: 0, min: 0, hr: 0);
    let time5 = try TimeIF(sec: 1, min: 0, hr: 0);
    print("time.toString() => \(time.toString())")
    print("time.add(time1) => \((try time.sum(inc: time1)).toString())")
    print("time.diff(time1) => \((try time.diff(dif: time1)).toString())")
    print("time4.diff(time5) => \((try time4.diff(dif: time5)).toString())")

    print("static: time + time1 => \(try TimeIF.sum(inc1: time, inc2: time1).toString())");
    print("static: time2 + time3 => \(try TimeIF.sum(inc1: time2, inc2: time3).toString())");
    let _ = try TimeIF(sec: 60, min: 0, hr: 0);
}
catch TimeError.dateError(let errorMessage) {
    print(errorMessage);
    Thread.callStackSymbols.forEach{print($0)};
}
