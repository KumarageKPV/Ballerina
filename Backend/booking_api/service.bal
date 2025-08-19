import ballerina/http;

// Main listener for all services
service on new http:Listener(8080) {
    
    // Booking service
    service /booking {
        // Create a new booking
        isolated resource function post create(@http:Payload BookingRequest bookingReq) returns BookingResponse|http:BadRequest|http:InternalServerError {
            BookingResponse|error result = createBooking(bookingReq);
            if result is error {
                if result.message().includes("Invalid") {
                    return <http:BadRequest>{body: {message: "Invalid booking request"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to create booking"}};
            }
            return result;
        }
        
        // Get booking by IDimport ballerina/http;

// Main listener for all services
service on new http:Listener(8080) {
    
    // Booking service
    service /booking {
        // Create a new booking
        isolated resource function post create(@http:Payload BookingRequest bookingReq) returns BookingResponse|http:BadRequest|http:InternalServerError {
            BookingResponse|error result = createBooking(bookingReq);
            if result is error {
                if result.message().includes("Invalid") {
                    return <http:BadRequest>{body: {message: "Invalid booking request"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to create booking"}};
            }
            return result;
        }
        
        // Get booking by ID
        isolated resource function get bookings/[int id]() returns Booking|http:NotFound|http:InternalServerError {
            Booking|error result = getBooking(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "Booking not found"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to retrieve booking"}};
            }
            return result;
        }
        
        // Cancel booking
        isolated resource function delete bookings/[int id]() returns record {|string message;|}|http:NotFound|http:InternalServerError {
            string|error result = cancelBooking(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "Booking not found"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to cancel booking"}};
            }
            return {message: result};
        }
    }

    // Passenger service
    service /passengers {
        // Get passenger by ID
        isolated resource function get [int id]() returns Passenger|http:NotFound|http:InternalServerError {
            Passenger|error result = getPassenger(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "Passenger not found"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to retrieve passenger"}};
            }
            return result;
        }
        
        // Get all passengers
        isolated resource function get all() returns Passenger[]|http:InternalServerError {
            Passenger[]|error result = getAllPassengers();
            if result is error {
                return <http:InternalServerError>{body: {message: "Failed to retrieve passengers"}};
            }
            return result;
        }
        
        // Get passenger's booking history
        isolated resource function get [int id]/bookings() returns Booking[]|http:NotFound|http:InternalServerError {
            Booking[]|error result = getBookingsByPassenger(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "No bookings found for passenger"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to retrieve bookings"}};
            }
            return result;
        }
    }

    // Trip service
    service /trips {
        // Search for available trips
        isolated resource function get search(string origin, string destination) returns TripWithDetails[]|http:InternalServerError {
            TripWithDetails[]|error result = getAvailableTrips(origin, destination);
            if result is error {
                return <http:InternalServerError>{body: {message: "Failed to search trips"}};
            }
            return result;
        }
        
        // Get trip by ID
        isolated resource function get [int id]() returns Trip|http:NotFound|http:InternalServerError {
            Trip|error result = getTrip(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "Trip not found"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to retrieve trip"}};
            }
            return result;
        }
        
        // Get seat map for a trip
        isolated resource function get [int id]/seats() returns record {|int seat_no; boolean is_booked; string? passenger_name;|}[]|http:NotFound|http:InternalServerError {
            record {|int seat_no; boolean is_booked; string? passenger_name;|}[]|error seatMap = getTripSeats(id);
            if seatMap is error {
                if seatMap.message().includes("not found") {
                    return <http:NotFound>{body: {message: "Trip or seats not found"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to retrieve seat map"}};
            }
            return seatMap;
        }
    }

    // Payment service
    service /payments {
        // Create payment for a booking
        isolated resource function post create(@http:Payload record {|int booking_id; decimal amount; string method;|} paymentReq) returns record {|int payment_id; string message;|}|http:BadRequest|http:InternalServerError {
            int|error result = createPayment(paymentReq.booking_id, paymentReq.amount, paymentReq.method);
            if result is error {
                if result.message().includes("Invalid") {
                    return <http:BadRequest>{body: {message: "Invalid payment request"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to process payment"}};
            }
            return {
                payment_id: result,
                message: "Payment recorded successfully"
            };
        }
    }
}
        isolated resource function get bookings/[int id]() returns Booking|http:NotFound|http:InternalServerError {
            Booking|error result = getBooking(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "Booking not found"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to retrieve booking"}};
            }
            return result;
        }
        
        // Cancel booking
        isolated resource function delete bookings/[int id]() returns record {|string message;|}|http:NotFound|http:InternalServerError {
            string|error result = cancelBooking(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "Booking not found"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to cancel booking"}};
            }
            return {message: result};
        }
    }

    // Passenger service
    service /passengers {
        // Get passenger by ID
        isolated resource function get [int id]() returns Passenger|http:NotFound|http:InternalServerError {
            Passenger|error result = getPassenger(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "Passenger not found"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to retrieve passenger"}};
            }
            return result;
        }
        
        // Get all passengers
        isolated resource function get all() returns Passenger[]|http:InternalServerError {
            Passenger[]|error result = getAllPassengers();
            if result is error {
                return <http:InternalServerError>{body: {message: "Failed to retrieve passengers"}};
            }
            return result;
        }
        
        // Get passenger's booking history
        isolated resource function get [int id]/bookings() returns Booking[]|http:NotFound|http:InternalServerError {
            Booking[]|error result = getBookingsByPassenger(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "No bookings found for passenger"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to retrieve bookings"}};
            }
            return result;
        }
    }

    // Trip service
    service /trips {
        // Search for available trips
        isolated resource function get search(string origin, string destination) returns TripWithDetails[]|http:InternalServerError {
            TripWithDetails[]|error result = getAvailableTrips(origin, destination);
            if result is error {
                return <http:InternalServerError>{body: {message: "Failed to search trips"}};
            }
            return result;
        }
        
        // Get trip by ID
        isolated resource function get [int id]() returns Trip|http:NotFound|http:InternalServerError {
            Trip|error result = getTrip(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "Trip not found"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to retrieve trip"}};
            }
            return result;
        }
        
        // Get seat map for a trip
        isolated resource function get [int id]/seats() returns record {|int seat_no; boolean is_booked; string? passenger_name;|}[]|http:NotFound|http:InternalServerError {
            record {|int seat_no; boolean is_booked; string? passenger_name;|}[]|error result = getTripSeats(id);
            if result is error {
                if result.message().includes("not found") {
                    return <http:NotFound>{body: {message: "Trip or seats not found"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to retrieve seat map"}};
            }
            return result;
        }
    }

    // Payment service
    service /payments {
        // Create payment for a booking
        isolated resource function post create(@http:Payload record {|int booking_id; decimal amount; string method;|} paymentReq) returns record {|int payment_id; string message;|}|http:BadRequest|http:InternalServerError {
            int|error result = createPayment(paymentReq.booking_id, paymentReq.amount, paymentReq.method);
            if result is error {
                if result.message().includes("Invalid") {
                    return <http:BadRequest>{body: {message: "Invalid payment request"}};
                }
                return <http:InternalServerError>{body: {message: "Failed to process payment"}};
            }
            return {
                payment_id: result,
                message: "Payment recorded successfully"
            };
        }
    }
}