<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js" integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g=" crossorigin="anonymous"></script>
</head>
<style>
    #now{
        color : skyblue;
    }
</style>
<body>
    <button id = "btn">날씨확인</button>
    <div id = "weather">
        <h1 id = now>현재 날씨</h1>
    </div>
    
    <script>
            $("#btn").click( () => {
                $.ajax({
                    url : "/api2",
                    method : "GET",
                    success : (data)=> {
                        let obj = JSON.parse(data);
                        const items = obj.response.body.items.item;
                        let rain = items[0].obsrValue;
                        let temperature = items[3].obsrValue;
                        $("#weather").append("<div>기온 : " + rain + "도</div>");
                        if(rain != 0){
                            let rain1h = items[2].obsrValue;
                            $("#weather").append("<div>비</div>");
                            $("#weather").append("<div>시간당 강수량 : " + rain1h + "</div>");
                        }
                    }
                })
            });
    </script>

</body>
</html>