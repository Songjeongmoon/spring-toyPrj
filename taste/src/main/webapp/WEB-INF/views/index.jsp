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
    <span id = "btn">
        <button id = "backBtn" class = "anotherBtn">&lt</button>
        <span id = "btnBlock"></span>
        <button id = "frontBtn" class = "anotherBtn">&gt</button>
    </span>    

    

</body>
<script>
    let pageNo = 1;
    let numOfRows = 300;
    let key = "";
    const url = 'http://apis.data.go.kr/6260000/FoodService/getFoodKr';
    let queryParams;
    let maxPage;

    let updateParams = (page) => {
        queryParams = '?serviceKey=' + key; /*Service Key*/
        queryParams += '&pageNo=' + page; /**/
        queryParams += '&numOfRows=' + numOfRows; /**/
        queryParams += '&resultType=json'; /**/
    }
    updateParams(pageNo);
    
    let getDataList = () => {
        let result;
        $.ajax({
            url : url + queryParams,
            method : "GET",
            async : false,
            dataType : "json",
            success : (data) => {
                console.log(data.getFoodKr.item.length);
                getData(data);
                result = data;
            },
            error : (error) => {
                alert("fail");
            }
        });
        return result;
    };

    $("#list").click( (event) => {
        if(event.target.className == "dataTitle"){
            alert(event.target.nextElementSibling.nextElementSibling.textContent);
        }
    });

    let getData = (data) => {
        $("#list").empty();
        for(var i = 0; i < 10; i++){
            if(data.getFoodKr.item[i] == null){
                break;
            }
            $("#list").append(`<tr><td class = dataTitle>` + data.getFoodKr.item[i].MAIN_TITLE + `</td>
                            <td><img src =` + data.getFoodKr.item[i].MAIN_IMG_THUMB + ` width = 100 height = 80></td>
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
</script>
</html>