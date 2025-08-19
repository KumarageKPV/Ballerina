import ballerina/time;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;

// Type definitions
public type Passenger record {|
    int id?;
    string name;
    string email;
    string phone?;
|};

public type Route record {|
    int id?;
    string origin;
    string destination;
    decimal distance_km?;
    int duration_mins?;
|};

public type Bus record {|
    int id?;
    int route_id;
    string bus_number;
    int total_seats;
|};

public type Trip record {|
    int id?;
    int bus_id;
    time:Civil departure_time;
    time:Civil arrival_time?;
    decimal price;
|};

public type Booking record {|
    int id?;
    int trip_id;
    int passenger_id;
    int seat_no;
    time:Civil booking_time?;
    string status?; // 'CONFIRMED' or 'CANCELLED'
|};

public type Payment record {|
    int id?;
    int booking_id;
    decimal amount;
    string method; // 'CASH', 'CARD', 'ONLINE'
    time:Civil payment_time?;
|};

// Booking request/response types
public type BookingRequest record {|
    int trip_id;
    int passenger_id;
    int seat_no;
|};

public type BookingResponse record {|
    int booking_id;
    string message;
    Booking booking_details;
|};

public type TripWithDetails record {|
    int trip_id;
    int bus_id;
    string bus_number;
    string origin;
    string destination;
    time:Civil departure_time;
    time:Civil arrival_time?;
    decimal price;
    int total_seats;
    int available_seats;
|};

// Database configuration
configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new(
    host=HOST, user=USER, password=PASSWORD, port=PORT, database=DATABASE
);

// Booking operations
isolated function createBooking(BookingRequest bookingReq) returns BookingResponse|error {
    // First check if the seat is available
    boolean seatAvailable = check isSeatAvailable(bookingReq.trip_id, bookingReq.seat_no);
    if (!seatAvailable) {
        return error("Seat " + bookingReq.seat_no.toString() + " is already booked for this trip");
    }
    
    // Check if passenger exists
    Passenger|error passenger = getPassenger(bookingReq.passenger_id);
    if passenger is error {
        return error("Passenger not found");
    }
    
    // Create the booking
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO Booking (trip_id, passenger_id, seat_no, booking_time, status)
        VALUES (${bookingReq.trip_id}, ${bookingReq.passenger_id}, ${bookingReq.seat_no}, 
                NOW(), 'CONFIRMED')
    `);
    
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        Booking bookingDetails = check getBooking(lastInsertId);
        return {
            booking_id: lastInsertId,
            message: "Booking confirmed successfully",
            booking_details: bookingDetails
        };
    } else {
        return error("Unable to create booking");
    }
}

isolated function isSeatAvailable(int tripId, int seatNo) returns boolean|error {
    sql:ParameterizedQuery query = `
        SELECT COUNT(*) as count 
        FROM Booking 
        WHERE trip_id = ${tripId} AND seat_no = ${seatNo} AND status = 'CONFIRMED'
    `;
    
    record {int count;} result = check dbClient->queryRow(query);
    return result.count == 0;
}

isolated function getBooking(int id) returns Booking|error {
    Booking booking = check dbClient->queryRow(
        `SELECT * FROM Booking WHERE id = ${id}`
    );
    return booking;
}

isolated function getBookingsByPassenger(int passengerId) returns Booking[]|error {
    Booking[] bookings = [];
    stream<Booking, error?> resultStream = dbClient->query(
        `SELECT * FROM Booking WHERE passenger_id = ${passengerId} ORDER BY booking_time DESC`
    );
    check from Booking booking in resultStream
        do {
            bookings.push(booking);
        };
    check resultStream.close();
    return bookings;
}

isolated function cancelBooking(int bookingId) returns string|error {
    sql:ExecutionResult result = check dbClient->execute(`
        UPDATE Booking SET status = 'CANCELLED' WHERE id = ${bookingId}
    `);
    
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int && affectedRowCount > 0 {
        return "Booking cancelled successfully";
    } else {
        return error("Booking not found or already cancelled");
    }
}

// Passenger operations
isolated function getPassenger(int id) returns Passenger|error {
    Passenger passenger = check dbClient->queryRow(
        `SELECT * FROM Passenger WHERE id = ${id}`
    );
    return passenger;
}

isolated function getAllPassengers() returns Passenger[]|error {
    Passenger[] passengers = [];
    stream<Passenger, error?> resultStream = dbClient->query(
        `SELECT * FROM Passenger`
    );
    check from Passenger passenger in resultStream
        do {
            passengers.push(passenger);
        };
    check resultStream.close();
    return passengers;
}

// Trip operations
isolated function getTrip(int id) returns Trip|error {
    Trip trip = check dbClient->queryRow(
        `SELECT * FROM Trip WHERE id = ${id}`
    );
    return trip;
}

isolated function getAvailableTrips(string origin, string destination) returns TripWithDetails[]|error {
    TripWithDetails[] trips = [];
    
    sql:ParameterizedQuery query = `
        SELECT 
            t.id as trip_id,
            t.bus_id,
            b.bus_number,
            r.origin,
            r.destination,
            t.departure_time,
            t.arrival_time,
            t.price,
            b.total_seats,
            (b.total_seats - COALESCE(booked.booked_count, 0)) as available_seats
        FROM Trip t
        JOIN Bus b ON t.bus_id = b.id
        JOIN Route r ON b.route_id = r.id
        LEFT JOIN (
            SELECT trip_id, COUNT(*) as booked_count 
            FROM Booking 
            WHERE status = 'CONFIRMED' 
            GROUP BY trip_id
        ) booked ON t.id = booked.trip_id
        WHERE r.origin = ${origin} AND r.destination = ${destination}
        AND t.departure_time > NOW()
        ORDER BY t.departure_time
    `;
    
    stream<TripWithDetails, error?> resultStream = dbClient->query(query);
    check from TripWithDetails trip in resultStream
        do {
            trips.push(trip);
        };
    check resultStream.close();
    return trips;
}

// // Assume this function exists to fetch trip details
// isolated function getTrip(int tripId) returns Trip|error {
//     return dbClient->queryRow(`SELECT id, bus_id FROM Trip WHERE id = ${tripId}`);
// }

isolated function getTripSeats(int tripId) returns record {|int seat_no; boolean is_booked; string? passenger_name;|}[]|error {
    // Get the trip details
    Trip trip = check getTrip(tripId);

    // Get bus details to know total seats
    record {|int total_seats;|} busInfo = check dbClient->queryRow(
        `SELECT total_seats FROM Bus WHERE id = ${trip.bus_id}`
    );

    // Get booked seats
    map<string?> bookedSeats = {};
    stream<record {|int seat_no; string passenger_name;|}, error?> bookedStream = dbClient->query(
        `SELECT b.seat_no, p.name AS passenger_name
         FROM Booking b
         JOIN Passenger p ON b.passenger_id = p.id
         WHERE b.trip_id = ${tripId} AND b.status = 'CONFIRMED'`
    );

    // Process the stream
    error? streamErr = from var booked in bookedStream
        do {
            bookedSeats[booked.seat_no.toString()] = booked.passenger_name;
        };

    if streamErr is error {
        return error("Failed to process booked seats", streamErr);
    }

    // Create seat map
    record {|int seat_no; boolean is_booked; string? passenger_name;|}[] seatMap = [];
    int totalSeats = busInfo.total_seats;

    foreach int i in 1..<totalSeats+1 {
        string? passengerName = bookedSeats.hasKey(i.toString()) ? bookedSeats[i.toString()] : null;
        seatMap.push({
            seat_no: i,
            is_booked: bookedSeats.hasKey(i.toString()),
            passenger_name: passengerName
        });
    }

    return seatMap;
}

// Payment operations
isolated function createPayment(int bookingId, decimal amount, string method) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO Payment (booking_id, amount, method, payment_time)
        VALUES (${bookingId}, ${amount}, ${method}, NOW())
    `);
    
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to create payment record");
    }
}