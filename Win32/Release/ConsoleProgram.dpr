 program test;

uses System.Net.HttpClientComponent;

procedure MakeChatGPTRestAPICall(const Endpoint: String; const Payload: String);
var
  HTTPRequest: TNetHttpRequest;
  HTTPResponse: TNetHttpResponse;
  JSONData: TJsonObject;
begin
  // Create a new HTTP request
  HTTPRequest := TNetHttpRequest.Create(nil);
  HTTPRequest.Open('POST', Endpoint, False);

  // Set the request headers
  HTTPRequest.AddHeader('Content-Type', 'application/json');

  // Set the request payload
  HTTPRequest.Write(Payload);

  // Send the request
  HTTPResponse := TNetHttpResponse.Create(nil);
  HTTPResponse.StatusCode := HTTPRequest.Send;

  // Check the response status code
  if HTTPResponse.StatusCode = 200 then
  begin
    // Parse the response JSON data
    JSONData := TJsonObject.Parse(HTTPResponse.Content);

    // Return the JSON data as a string
    Result := JSONData.ToString;
  end
  else
  begin
    // Return an error message
    Result := 'Error: ' + HTTPResponse.StatusText;
  end;
end;

end.

// Example usage:

procedure MyProcedure;
begin
  // Call the MakeChatGPTRestAPICall function
  MakeChatGPTRestAPICall('https://api.openai.com/v1/chat/gpt', '{"prompt": "Hello, chatbot! How are you today?"}');
end;

end.