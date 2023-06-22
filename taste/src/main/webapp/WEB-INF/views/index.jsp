<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js" integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g=" crossorigin="anonymous"></script>
    <style>
        .dataTitle {
            cursor : pointer;
        }
        .dataTitle:hover {
            color : powderblue;
        }
        button {
            cursor : pointer;
        }
        #table {
            border : 1px solid black;
            text-align : center;
        }
        td {
            border : 1px solid black;
        }
        .no {
            display : none;
        }
        #btn {
            display : inline-block;
        }
        .anotherBtn {
            display : none;
        }
        #container {
            width : 500px;
            height : 600px;
            border : 1px solid black;
            border-radius : 15px;
            display : none;
            position : absolute;
            top : 50%;
            left : 50%;
            transform : translate(-50%, -50%);
            overflow : auto;
        }
        .detailList {
            list-style-type: none;
            display : inline-block;
            border-radius: 6px;
            margin-bottom : 10px;
            padding : 5px;
            background-color : rgba(0, 102, 255, 0.48);
            border : 1px solid black;
        }
        #detailDesc {
            max-width: 400px;
        }
        #containerClose {
            text-align: center;
            width : 20px;
            height : 20px;
            margin-top : 6px;
            margin-left : 6px;
            border-radius : 50%;
            border : none;
            background-color : red;
            font-size: 6px;
            transition-duration : 0.2s;
        }
        #containerClose:hover {
            font-size : 12px;
            font-weight : bolder;
            
        }
        #nextBtnBlock{
            text-align : center;
            display : inline-block;
            margin-left : 50%;
            transform: translate(-50%);
        }
        .nextBtn {
            margin-right : 1px;
            color : white;
            background-color : black;
            border-radius : 3px;
        }
        #detailImg {
            background-color : transparent;
            border : none;
        }
    </style>
</head>
<body>
    <table id = "table">
        <thead>
            <tr>
                <th>상호명</th><th>&nbsp</th>
            </tr>
        </thead>
        <tbody id = "list">
        </tbody>
    </table>
    <input type = "text" name = "title" value = "" placeholder="정확한 상호명을 입력해주세요">
    <input type = "button" name = "titleSearch" value = "검색"> <br>
    <span id = "btn">
        <button id = "backBtn" class = "anotherBtn">&lt</button>
        <span id = "btnBlock"></span>
        <button id = "frontBtn" class = "anotherBtn">&gt</button>
    </span>

    <div id = container>
        <div><button id = "containerClose">X</button></div>
        <ul>
            <li class = detailList id = "detailTitle">상호명 : </li>
            <li class = detailList id = "detailAddress">주소 : </li>
            <li class = detailList id = "detailTel">TEL : </li>
            <li class = detailList id = "detailTime">영업 시간 : </li>
            <li class = detailList id = "detailDesc">DESCRIPTION : </li>
            <li class = detailList id = "detailImg"><img id = "detailImage" width = 300 height = 250></li>
        </ul>
        <div id = "nextBtnBlock"></div>
    </div>
    

</body>
<script>
    let total;
    let pageNo = 1;
    let numOfRows = 300;
    let API_KEY = '<%= System.getenv("APIKEY") %>'; // .env파일의 변수명을 사용하여야 함.
    const url = 'http://apis.data.go.kr/6260000/FoodService/getFoodKr';
    let queryParams;
    let maxPage;

    let updateParams = (page) => {
        queryParams = '?serviceKey=' + API_KEY;
        queryParams += '&pageNo=' + page;
        queryParams += '&numOfRows=' + numOfRows;
        queryParams += '&resultType=json';
    }
    updateParams(pageNo);
    


    let getDataList = () => {
        
        $.ajax({
            url : url + queryParams,
            method : "GET",
            async : false,
            dataType : "json",
            success : (data) => {
                getData(data);
                total = data;
            },
            error : (error) => {
                alert("fail");
            }
        });
        return total;
    };

    let openDetail = (detail) => {
        $("#nextBtnBlock").empty();
        showDetail(detail[0]);
        
        for(let i = 0; i < detail.length; i++){
            $("#nextBtnBlock").append("<button class = nextBtn>" + (i + 1) + "</button>");
        }

        $("#container").css("display", "inline-block");

        $("#nextBtnBlock").click( (event) => {
            if(event.target.className == "nextBtn"){
                showDetail(detail[event.target.textContent - 1]);
            }
        }) 
    }

    let showDetail = (data) => {
        $("#detailTitle").text("상호명 : " + data.MAIN_TITLE);
        $("#detailAddress").text("주소 : " + data.ADDR1);
        $("#detailTel").text("TEL : " + data.CNTCT_TEL);
        $("#detailTime").text("영업 시간 : " + data.USAGE_DAY_WEEK_AND_TIME);
        $("#detailDesc").text("DESCRIPTION" + data.ITEMCNTNTS);
        $("#detailImage").attr("src", data.MAIN_IMG_THUMB);
    }


    

    $("#list").click( (event) => {
        if(event.target.className == "dataTitle"){
            let no = event.target.nextElementSibling.nextElementSibling.textContent
            let detail = total.getFoodKr.item.filter( (e) => {
                return e.UC_SEQ == no;
            });
            openDetail(detail);
        }
    });

    $("#containerClose").click( () => {
        $("#container").css("display", "none");
    })

    

    let getData = (data) => {
        $("#list").empty();
        for(var i = 0; i < 10; i++){
            if(data.getFoodKr.item[i] == null){
                break;
            }
            $("#list").append(`<tr><td class = dataTitle>` + data.getFoodKr.item[i].MAIN_TITLE + `</td>
                            <td><img src =` + data.getFoodKr.item[i].MAIN_IMG_THUMB + ` width = 100 height = 75></td>
                            <td class = no>` + data.getFoodKr.item[i].UC_SEQ + `</td></tr>`);
        };
    };

    let getDetailData = (data) => {

    };

    $("#btn").click( (event) => {
        if(event.target.className == "btnNo"){
            let selectNo = event.target.textContent;
            updateParams(selectNo);
            getDataList();
        } else {
            $("#btnBlock").empty();
            pageNo += event.target.textContent == ">" ? 10 : -10;
            pageUpdate();
            updateParams(pageNo);
            getDataList();
        }
    });

    let pageUpdate = () => {
        if(pageNo == 1){
            $("#backBtn").css("display", "none");
        } else {
            $("#backBtn").css("display", "inline-block");
        }
        for(let i = pageNo; i < pageNo + 10; i++){
            if(i <= maxPage) {
                $("#btnBlock").append("<button class = btnNo>" + i + "</button>");
            } else {
                $("#frontBtn").css("display", "none");
                return;
            }
        }
        $("#frontBtn").css("display", "inline-block");
    }

    let initData = () => {
        numOfRows = 10;
        let data = getDataList();
        maxNo = data.getFoodKr.item.length;
        maxPage = Math.floor(maxNo / 10);
        maxPage = maxNo % 10 == 0 ? maxPage : maxPage + 1;
        for(let i = 0; i < 10; i++){
            $("#btnBlock").append("<button class = btnNo>" + (i + 1) + "</button>");
        }
        $("#frontBtn").css("display", "inline-block");
    };
    initData();

    $("input[name=titleSearch]").click( () => {
        let searchData = total.getFoodKr.item.filter( (e) => {
            return e.MAIN_TITLE.includes($("input[name=title]").val());
        });
        if(searchData == "" || $("input[name=title]").val() == ""){
            alert("찾으시는 가게가 없습니다.");
            return;
        }
        $("input[name=title]").val("");
        openDetail(searchData);
    });
</script>
</html>