package com.moon.song.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.time.ZoneId;
import java.time.ZonedDateTime;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/")
public class SongController {

    @GetMapping("/")
    public String index(Model model){
        return "index";
    };
    
    @ResponseBody
    @GetMapping("/api2")
    public String weather2() throws Exception{

        String time = ZonedDateTime.now(ZoneId.of("Asia/Seoul")).toString();
        String[] tmp = time.split("T");
        String now = tmp[0].replaceAll("-", ""); // 오늘날짜

        time = tmp[1].substring(0, 5).replaceAll(":", ""); // 현재 시간 구하기 - 1시간 빼기
        int t = Integer.parseInt(time) - 100;
        time = String.format("%4s", Integer.toString(t)).replaceAll(" ", "0"); // 4자릿수를 맞춰야 한다.
        System.out.println(now);
        System.out.println(time);

        //좌표값은 통상적인 위도 경도값과 다르기 떄문에 기상청 홈페이지를 참조해야한다.
        StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=UndgUNBxiL5%2F3xSAfHJRspwTbCRi3sKPwVMc80TVDpEmlbHSmLbuwpbojuqIMKElMvvqqLIEQ%2F9iQJrB1vVtSA%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1000", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON) Default: XML*/
        urlBuilder.append("&" + URLEncoder.encode("base_date","UTF-8") + "=" + URLEncoder.encode(now, "UTF-8")); /*‘21년 6월 28일 발표*/
        urlBuilder.append("&" + URLEncoder.encode("base_time","UTF-8") + "=" + URLEncoder.encode(time, "UTF-8")); /*06시 발표(정시단위) */
        urlBuilder.append("&" + URLEncoder.encode("nx","UTF-8") + "=" + URLEncoder.encode("38", "UTF-8")); /*예보지점의 X 좌표값*/
        urlBuilder.append("&" + URLEncoder.encode("ny","UTF-8") + "=" + URLEncoder.encode("127", "UTF-8")); /*예보지점의 Y 좌표값*/
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        BufferedReader rd;

        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        };

        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = rd.readLine()) != null) {
            sb.append(line);
        };

        rd.close();
        conn.disconnect();
        return sb.toString();
        
    };
}