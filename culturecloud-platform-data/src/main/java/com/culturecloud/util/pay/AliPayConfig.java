package com.culturecloud.util.pay;

import com.culturecloud.kafka.PpsConfig;

public class AliPayConfig {

	public static String partner="2088011084538743";
	
	public static String privateKey="MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCnEvxUnNyvoMhYX7dnYU"
			+ "RVE2PHQYeQn6MMIGLShMGF5AeloW43LeJXcjw9vLD+3ZO4jH3kqO+1QeQWuLtoMa6j7J4rJ+TiIsjYdqTKfZBZuphK"
			+ "fgggwU94LMTnidIYJt45mqcXNbyb5BTJH/pP/vdzyroLO1iNPDuSwMH0EeL09bjaxtQhaP8j9G1v1SPs3M6ClRYmflU3J"
			+ "diVBRFkjS9ZvK1JTf5BD3nNFLZiBFzKpeS/cqb/T/l/QKOzitkj/o6WP8l9Iby3yg4y7vO7lb3YrWyCrAEX33cjB7neHIQqfns"
			+ "DqYBfY2Mh4bkjsOFIBQaZfisz8570sek0Ymm7RRlHAgMBAAECggEAMsjpnIql5ljYLUzDAhCl5bpkHQBFRefQdvItN9KUxK8gx+7/ApT"
			+ "W9T/LIfUGVCJkMbe62NOlMZKa03FJvg1ECZ32IiYZQ8fRB0NhKg/q3euDOTmAHPzFvEDXhY32J9NAv3/MBJkYAMberpgizUgyTac00A81BpF"
			+ "lhmFDU35QX6cHUTrUlscS0qX/59dxF8HRoogMMwkOa1T5O/LY3vcidQcEg543pbbuKTxZ2y0BxNpuvhEyIRwA2GvjPQA4AKfYui5NVCSNYOMB655NZM"
			+ "yz+eItdfUNYhn+i09MBuqGZtLdAS+ckkA7sVsuW0poRndV9lS0Now/SL/8h8Q9AkligQKBgQDiUP6l19djVmOv+K54np6isWjztwFM0hIwqCnbPPM9KNACBTY"
			+ "b5e4wVMUcgT5/QYrA2SMpeLSsC44hZF/LItxM6GajOgzoIpBvF+sLHIaebC115HIsFvcQFUP8brZ/4oe+UYx8dvQ2pclkOH979FBD/poUa9ojGQswq/XXAvolBwKBgQC8/NHv1nS88"
			+ "txO7NwLrwx8LmVZfLIZwE/n6QABbjDFHxTfQILqLtbBEeJAtnG7bnNxaLU9eUQPLz6mo8jZYdZ1NdWpDSX0KhifjBleieE5A9deqz/+/Ck58ZW+Ju0MZfeJOlLPyXqznaMcW0Eun"
			+ "3dhIuUVmJwtn2P7tP5XmYKZwQKBgFmRNobKGns9CGzvXZVtKVk4H1I8/i26Aerx0sbqo1V0HoZ+K4D1CcRk+DGk0OgqN1DFXs4d8Fsao6CBigvp+wgQ/fXhlpQUgdcFv0cBfiGarI"
			+ "843xql6BecYvC3nFCWhaSDv7bOmS47hK2+Um3rLg0K6U3ltUoosi4MEFqM2hTnAoGBAKfVOjdtU6TNZPsufEhf/410worTI3OdBxlkIZ4jlmoorSeKqfiA+jThxfVEUQJsF1ea7oGW"
			+ "ZOu7QD9K6r6qlYLn+UQ1KgSJMe7Ww1ziw8IXeDdZi+7NT2tm8V26QgAlucwDoLFpM2+5ybYQEHXwJlt8WsdwDRqzF17coJd4+7PBAoGBAILtqmkR/gSckr8U1mgpCm+V6fTVnfqakT0"
			+ "effo6pTb3URb0aiYbZHoziD7X6H/l77Rgku4kKkIWT+FJr6o1p34B6Afv5/hae6yxvBW54rvVs5WIhDcTchbpuxDSSax6uhybvD4Dh06RvshiEIrhNASBIC+xslFA9c+VnoFtytts";
	
	public static String publicKey="MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApxL8VJzcr6DIWF+3Z2FEVRNjx0GHkJ+jDCBi0oTBheQHpaFuNy3iV3I8Pbyw/t2TuIx95KjvtUH"
			+ "kFri7aDGuo+yeKyfk4iLI2Hakyn2QWbqYSn4IIMFPeCzE54nSGCbeOZqnFzW8m+QUyR/6T/73c8q6CztYjTw7ksDB9BHi9PW42sbUIWj/I/Rtb9Uj7NzOgpUWJn5VNyXYlQURZI0vWby"
			+ "tSU3+QQ95zRS2YgRcyqXkv3Km/0/5f0Cjs4rZI/6Olj/JfSG8t8oOMu7zu5W92K1sgqwBF993Iwe53hyEKn57A6mAX2NjIeG5I7DhSAUGmX4rM/Oe9LHpNGJpu0UZRwIDAQAB";
	
	public static String singType="RSA";
	
	public static String inputCharset="";
	
	public static String callback=PpsConfig.getString("alicallback").toString();
//	public static String callback="http://www.wenhuayun.cn";
	
	public static String appId="2017030606070570";
}
