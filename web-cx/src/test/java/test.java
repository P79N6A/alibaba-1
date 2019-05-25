import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class test {
	
	public static boolean isMobileNO(String mobiles){
		Pattern p = Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$");
		Matcher m = p.matcher(mobiles);
		return m.matches();
	}
	
	public static void main(String[] args) {
		/*Random ra = new Random();
		int r = ra.nextInt(100000000);
		 
		 * 0 指前面补充零 
		 * formatLength 字符总长度为 formatLength 
		 * d 代表为正数。 
		   
		String newString = String.format("%08d", r);
		System.out.println(newString);*/
		
		/*File base = new File("J:/100个上海最美城市空间（图片、文字、二维码）/100个上海最美城市空间（图片、文字、二维码）");

		if (base.isDirectory()) {
			File[] files = base.listFiles();
			for (File file : files) {
				System.out.println(file.getName().substring(file.getName().indexOf(" ")).replaceAll(" ", ""));
			}
		}*/
		
		/*try {
			File src = new File("F:/bigData.json");
			if(!src.exists()){
				src.createNewFile();
			}
			
			FileWriter fw = new FileWriter(src.getAbsoluteFile());
		    BufferedWriter bw = new BufferedWriter(fw);
		    bw.write("{\"page\":\"1\"}");
		    bw.close();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
		

	}
}
