import http.requests.*;

// "?" indecates that parameter section of url is starting. Each parameter is
// separated with a "&".
String baseUrl = "http://api.reittiopas.fi/hsl/prod/?";
String requestType = "request=cycling&";
String[] userAndPassword = loadStrings("reittiopas_user.txt");
String format = ""//"&format=txt";
//String request = "&from=2548196,6678528&to=2549062,6678638"; //Example
String request = "&from=2546562,6675695&to=2546677,6675487&epsg_out=wgs84"; //SMT JMT, output WGS84:ssa
String address = baseUrl + requestType + userAndPassword[0] + format + request;

GetRequest get = new GetRequest(address);
get.send();
String[] content = new String[1];
content[0] = get.getContent();

println("Reponse Content: " + content[0]);
saveStrings("output.txt", content);