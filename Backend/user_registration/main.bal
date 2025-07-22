import ballerinax/mysql;
import ballerinax/mysql.driver as _; // This bundles the driver to the project so that you don't need to bundle it via the `Ballerina.toml` file.
import ballerina/sql;

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new(
    host=HOST, user=USER, password=PASSWORD, port=PORT, database="UserDB"
);

isolated function addUsers(User user)returns int|error{
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO Users (user_id, first_name,last_name, 
                           email,phone_number,password)
        VALUES(${user.user_id},${user.first_name},${user.last_name},${user.email},${user.phone_number},${user.password})
    
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    }else {
        return error("Unable to obtain last insert ID");
    }

}