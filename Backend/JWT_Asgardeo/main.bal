import ballerina/http;
import ballerina/jwt;
import ballerina/url;

// Asgardeo OIDC configuration
configurable string ASGARDEO_ISSUER = ?;
configurable string ASGARDEO_AUTH_URL = ?;
configurable string ASGARDEO_TOKEN_URL = ?;
configurable string ASGARDEO_JWKS_URL = ?;

configurable string CLIENT_ID = ?;
configurable string CLIENT_SECRET = ?;
configurable string REDIRECT_URI = ?;
configurable string BASE_URL=?;

// JWT Validator configuration
jwt:ValidatorConfig validatorConfig = {
    issuer: ASGARDEO_ISSUER,
    audience: CLIENT_ID,
    signatureConfig: {
        jwksConfig: {
            url: ASGARDEO_JWKS_URL
        }
    }
};

// HTTP service
service /api on new http:Listener(9090) {
    
    // Login endpoint to redirect to Asgardeo
    resource function get login(http:Caller caller) returns error? {
        // Build authorization URL with proper URL encoding for individual parameters
        string baseUrl = ASGARDEO_AUTH_URL;
        string responseType = "response_type=code";
        string clientId = "client_id=" + check url:encode(CLIENT_ID, "UTF-8");
        string redirectUri = "redirect_uri=" + check url:encode(REDIRECT_URI, "UTF-8");
        string scope = "scope=" + check url:encode("openid profile email", "UTF-8");
        
        string authUrl = baseUrl + "?" + responseType + "&" + clientId + "&" + redirectUri + "&" + scope;
        
        http:Response res = new;
        res.setHeader("Location", authUrl);
        res.statusCode = 302;
        check caller->respond(res);
    }
    
    // Callback endpoint to handle Asgardeo response
    resource function get callback(http:Caller caller, http:Request req) returns error? {
        string? code = req.getQueryParamValue("code");
        string? errorParam = req.getQueryParamValue("error");
        
        // Check for authorization errors
        if errorParam is string {
            http:Response res = new;
            res.statusCode = 400;
            res.setPayload({ 
                "error": "Authorization failed", 
                "error_description": req.getQueryParamValue("error_description") 
            });
            check caller->respond(res);
            return;
        }
        
        if code is () {
            http:Response res = new;
            res.statusCode = 400;
            res.setPayload({ "error": "Missing authorization code" });
            check caller->respond(res);
            return;
        }
        
        // Exchange code for tokens
        http:Client tokenClient = check new("BASE_URL");
        
        // Prepare form data for token request
        string formData = "grant_type=authorization_code" +
                         "&code=" + check url:encode(code, "UTF-8") +
                         "&redirect_uri=" + check url:encode(REDIRECT_URI, "UTF-8") +
                         "&client_id=" + check url:encode(CLIENT_ID, "UTF-8") +
                         "&client_secret=" + check url:encode(CLIENT_SECRET, "UTF-8");
        
        http:Response tokenResponse = check tokenClient->post(
            "/t/busidea/oauth2/token",
            formData,
            {
                "Content-Type": "application/x-www-form-urlencoded"
            }
        );
        
        if tokenResponse.statusCode != 200 {
            // Get error details for debugging
            string|error errorBody = tokenResponse.getTextPayload();
            http:Response res = new;
            res.statusCode = 400;
            res.setPayload({ 
                "error": "Failed to exchange authorization code for tokens",
                "status": tokenResponse.statusCode,
                "details": errorBody is string ? errorBody : "Unable to read error response"
            });
            check caller->respond(res);
            return;
        }
        
        json tokenResponsePayload = check tokenResponse.getJsonPayload();
        
        // Extract tokens
        string? accessToken = (check tokenResponsePayload.access_token).toString();
        string? idToken = (check tokenResponsePayload.id_token).toString();
        string? refreshToken = (check tokenResponsePayload.refresh_token).toString();
        int? expiresIn = check int:fromString((check tokenResponsePayload.expires_in).toString());
        
        // Respond with tokens (in practice, store securely or send to frontend)
        json response = { 
            "access_token": accessToken, 
            "id_token": idToken,
            "refresh_token": refreshToken,
            "expires_in": expiresIn,
            "token_type": "Bearer"
        };
        check caller->respond(response);
    }
    
    // Protected endpoint that validates JWT tokens
    resource function get protected(http:Caller caller, http:Request req) returns error? {
        string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
        
        if authHeader is string {
            // Check if header starts with "Bearer "
            if !authHeader.startsWith("Bearer ") {
                http:Response res = new;
                res.statusCode = 401;
                res.setPayload({ "error": "Invalid Authorization header format" });
                check caller->respond(res);
                return;
            }
            
            string jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
            jwt:Payload|error jwtResult = jwt:validate(jwtToken, validatorConfig);
            
            if jwtResult is jwt:Payload {
                // JWT is valid, return protected data
                json response = { 
                    "message": "Hello, " + jwtResult.sub.toString() + "!",
                    "user_id": jwtResult.sub,
                    "issued_at": jwtResult.iat,
                    "expires_at": jwtResult.exp
                };
                check caller->respond(response);
            } else {
                // Invalid JWT
                http:Response res = new;
                res.statusCode = 401;
                res.setPayload({ "error": "Invalid or expired JWT" });
                check caller->respond(res);
            }
        } else {
            // No Authorization header
            http:Response res = new;
            res.statusCode = 401;
            res.setPayload({ "error": "Authorization header missing" });
            check caller->respond(res);
        }
    }
    
    // Optional: Token refresh endpoint
    resource function post refresh(http:Caller caller, http:Request req) returns error? {
        json|error payload = req.getJsonPayload();
        
        if payload is error {
            http:Response res = new;
            res.statusCode = 400;
            res.setPayload({ "error": "Invalid request payload" });
            check caller->respond(res);
            return;
        }
        
        string? refreshToken = (check payload.refresh_token).toString();
        
        if refreshToken is () {
            http:Response res = new;
            res.statusCode = 400;
            res.setPayload({ "error": "Missing refresh token" });
            check caller->respond(res);
            return;
        }
        
        // Exchange refresh token for new access token
        http:Client tokenClient = check new("BASE_URL");
        
        string formData = "grant_type=refresh_token" +
                         "&refresh_token=" + check url:encode(refreshToken, "UTF-8") +
                         "&client_id=" + check url:encode(CLIENT_ID, "UTF-8") +
                         "&client_secret=" + check url:encode(CLIENT_SECRET, "UTF-8");
        
        http:Response tokenResponse = check tokenClient->post(
            "/t/busidea/oauth2/token",
            formData,
            {
                "Content-Type": "application/x-www-form-urlencoded"
            }
        );
        
        if tokenResponse.statusCode != 200 {
            http:Response res = new;
            res.statusCode = 400;
            res.setPayload({ "error": "Failed to refresh token" });
            check caller->respond(res);
            return;
        }
        
        json tokenResponsePayload = check tokenResponse.getJsonPayload();
        check caller->respond(tokenResponsePayload);
    }
}