import http.requests.*;

String from = "2546507,6675396";
String to = "2546536,6675399";
// separate coordinates with |
String via = "2545865,6675403|2546800,6675525|2546363,6674498|2545880,6674735";

//http://pk.reittiopas.fi/fi/#from%28point*2546507*6675396%29to%28point*2546536*6675399%29mapcenter%28point*2546184*6675375%29mapzoom%282%29via%28%28point*2545865*6675403%29%28point*2546800*6675525%29%28point*2546363*6674498%29%28point*2545880*6674735%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%28%29%29
String baseUrl = "http://api.reittiopas.fi/hsl/prod/?";
String requestType = "request=cycling&";
String[] userAndPassword = loadStrings("reittiopas_user.txt");
String format = "";//"&format=txt";
String request = "&from=" + from + "&to=" + to + "&via=" + via + "&epsg_out=wgs84&elevation=1"; //SMT, otsolahti, westend output WGS84:ssa
String address = baseUrl + requestType + userAndPassword[0] + format + request;

GetRequest get = new GetRequest(address);
get.send();
String[] content = new String[1];
content[0] = get.getContent();
println(address);
println("Reponse Content: " + content[0]);
saveStrings("output.txt", content);