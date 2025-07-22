import ballerina/http;

service /api/user on new http:Listener(8080){

    isolated resource function post .(@http:Payload User user) returns int|error?{
      return addUsers(user);
    }
    
}
