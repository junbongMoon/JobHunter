package com.jobhunter.util;

import java.io.IOException;
import java.io.Reader;
import java.util.Properties;

import org.apache.ibatis.io.Resources;

public class PropertiesTask {

	/**
	 * @author Administrator
	 * @date 2025. 2. 18.
	 * @enclosing_method getPropertiesValue
	 * @todo TODO
	 * @param String propertiesFileName : 읽어낼 프로퍼티스 파일명 (classpath에 존재해야함)
	 * @param String key : 찾을 key 값
	 * @returnType String : key에 대한 value 반환
	 */
	public static String getPropertiesValue(String propertiesFileName, String key) throws IOException {
		Properties prop = new Properties();

		Reader reader = Resources.getResourceAsReader(propertiesFileName);
		prop.load(reader);

		return (String) prop.get(key);
	}
}