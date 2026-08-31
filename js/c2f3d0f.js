//Active state
var active = 1;
var activeQuestion = 1;
var totalMark = 0;

//Cicles through every children of the progress-container, and checks if its the i state.
$(document).ready(function () {
    function submitInfo(){
        $(".submit-result .btn-result").removeClass("active");

        var name = $("#fullName").val();
        var phone = $("#phoneNumber").val();
        var email = $("#email").val();
        var address = $("#address").val();
        var data = {mark:totalMark,name:name,phone:phone,email:email,address:address,fbId:fbId,fbLink:fbLink};
        $.ajax({
            url:urlSubmit,
            data:{data:data},
            type:"POST",
            success:function(data){

                $("#quiz1Result").replaceWith(data);
                $("#quiz1step1").modal("hide");
                $("#quiz1step1").on('hidden.bs.modal',function(){
                    $("#quiz1Result").modal("show");
                });


                $("#shareToFb").click(function(){
                    var url = $(this).data("thumbnail");
                    FB.ui({
                        method: 'share',
                        href: fbShare1Url,
                        picture:url,
                        caption: "KHÁM PHÁ SẮC MÀU CÙNG SƠN GALAXY",
                        uri_redirect:fbShare1Url,
                        description:"Bạn là ai trong bảng màu của thiên nhiên? Hãy khám phá ngay sắc màu thiên hà trong bạn."
                    }, function(response){
                        $("#quiz1avatar").attr("src",fbLink);
                        $("#quiz1Result").modal("hide");
                        $("#quiz1Result").on('hidden.bs.modal',function(){
                            $("#quiz1step3").modal("show");
                        });


                        $("#quiz2Play2").click(function(event){
                            event.preventDefault();
                            $("#quiz1step3").modal("hide");
                            $("#quiz2Play").click();
                        });
                    });
                });
            },
            error:function(xhr){
                var errors = $.parseJSON(xhr.responseText);
                for(i=0;i<errors.length;i++){
                    var ele = errors[i];
                    $(ele).addClass("has-error");
                }
//                        alert("Bạn hãy nhập đầy đủ các thông tin nhé");
            }
        })
    }

    function quiz1Check(){
        if (!$("input[name='optionsRadios']:checked").val()) {
            return false;
        }
        else {
            var mark = $("input[name='optionsRadios']:checked").val();
            return mark;
        }
    }

    function loadUserInfo(){
        $.ajax({
            url:urlInfo,
            beforeSend:function(){
                totalMark = 0;
                $(".question-process li").each(function(){
                    var mark = $(this).data("mark");
                    totalMark += parseInt(mark);
                    console.log(totalMark);
                });
            },
            success:function(data){
//                        set active state
                active = 2;
                checkStep();
                $("#step1").replaceWith(data);
                bindToCheck();
//                        $(".submit-result .btn-result").unbind("click");
//                        $(".submit-result .btn-result.active").click(function(){
//                            $(".submit-result .btn-result").removeClass("active");
//                            $(".submit-result .btn-result.active").unbind("click"); //disable tạm thời
//                            submitInfo();
//                        });
            },
            error:function(){

            }
        });
    }
    function bindToCheck(){
        $(".form-control").focus(function(){
            $(this).removeClass("has-error");
        });
        $(".form-control").blur(function(){
            var name = $("#fullName").val();
            console.log(name);
            var phone = $("#phoneNumber").val();
            var email = $("#email").val();
            var address = $("#address").val();

            if( $.trim(name) != ""
                && $.trim(phone)!=""
                && $.trim(email)!=""
                && $.trim(address) != ""){
                $(".submit-result .btn-result").addClass("active");
                $(".submit-result .btn-result").unbind("click");
                active = 3;


                $(".submit-result .btn-result.active").click(function(event){
                    event.preventDefault();
                    $(".submit-result .btn-result").unbind("click");
                    submitInfo();
                });

            }else{
                active = 2;
                $(".submit-result .btn-result").click(function(event) {
                    event.preventDefault();
                });
                $(".submit-result .btn-result").removeClass("active");
            }
            checkStep();

        });

    }
    function checkStep(){
        var i = 1;

        $("#quiz1 ul.step-process > li").each(function () {
            console.log(active);
            if(activeQuestion == 1){
                $(this).find('.number').append('<span>' + i + '</span>');
            }
            if (i < active) {
                $(this).addClass("done");
            } else if (i == active) {
                $(this).addClass("active");
            } else{
                $(this).removeClass("active");
            }
            i++;
        });
        var q = 1;

        $("#step1").find("ul.question-process > li").each(function () {
            $(this).append('<span>' + q + '</span>');
            if (q < activeQuestion) {
                $(this).addClass("done");
            } else if (q == activeQuestion) {
                $(this).addClass("active");
            } else {
                $(this).removeClass("active");
            }
            q++;
        });
    }
    checkStep();
    function bindShareBtn(){
        $(".root-item .radio").unbind("click");
        $(".root-item .radio").click(function(){

//                    disable
//            $(".btn-share-result.min-btn").unbind("click");
            var mark = quiz1Check();
            //if(mark == false){
            //    alert("Bạn chưa chọn câu trả lời");
            //    bindShareBtn();
            //    return;
            //}else{
            //    //totalMark += parseInt(mark);
            //
            //}
            var questionNumber = $(".btn-share-result.min-btn").data("number");
            $("#amz_question_"+questionNumber).data("mark",parseInt(mark));

            if(questionNumber==10){

//                        step 2
                loadUserInfo();
                return;
            }
            var url = $(".btn-share-result.min-btn").data("href");
            loadQuestion(url);
        });
    }
    bindShareBtn();

    function loadQuestion(url){
        $.ajax({

            url:url,
            before:function(){
                $(".root-item .radio").unbind("click");
            },
            success:function(data){
                $(".root-item").replaceWith(data);

                var number = $(".btn-share-result.min-btn").data("number");
                //number = parseInt(number);
                //if(activeQuestion < number){
                    activeQuestion = number;
                //}


                checkStep();
                bindShareBtn();
            },
            error:function(){
                bindShareBtn();
            }
        })
    }
    $(".question-process li").each(function(){
        $(this).unbind("click");
        $(this).click(function(){
            if(!$(this).hasClass("active")){
                return false;
            }else{
                var url = $(this).data("href");
                loadQuestion(url);

            }


        });
    });

});


var fbId = 0;
var fbLink = "";
$(document).ready(function(){
    $.ajaxSetup({ cache: true });
    $.getScript('http://connect.facebook.net/en_US/sdk.js', function(){
        FB.init({
            appId: fbAppId,
//                    appId: '548725855288972', //real
            version: 'v2.5' // or v2.0, v2.1, v2.2, v2.3
        });
        $('#loginbutton,#feedbutton').removeAttr('disabled');


    });

    $("#quiz1Play, #discover-now .quiz-1").click(function(event){
        event.preventDefault();
        FB.getLoginStatus(function(auth){
            console.log(auth);
            if(auth.status == "not_authorized" || auth.status=="unknown"){
                FB.login(function(response){

                },{
                    return_scopes: true
                });
            }else if(auth.status =="connected") {
                console.log(auth.authResponse.userID);
                fbId = auth.authResponse.userID;
                FB.api(
                    "/"+fbId+"/picture",
                    {type:"large"},
                    function (response) {
                        if (response && !response.error) {
                            console.log(response.data.url);
                            fbLink = response.data.url;
                        }
                    }
                );
//                        show modal
                $("#quiz1step1").modal("show");
            }
        });


    });



    $("#shareToFb").click(function(){
        var url = $(this).data("thumbnail");
        FB.ui({
            method: 'feed',
            link: url,
            picture:url,
            caption: 'KHÁM PHÁ SẮC MÀU CÙNG SƠN GALAXY',
        }, function(response){});
    });

    function quiz2Play(){
        FB.getLoginStatus(function(auth){
            console.log(auth);
            if(auth.status == "not_authorized" || auth.status=="unknown"){
                FB.login(function(){

                },{
                    return_scopes: true
                });
            }else if(auth.status =="connected") {
                console.log(auth.authResponse.userID);
                fbId = auth.authResponse.userID;
                $("#quiz2FbId").val(fbId);
                FB.api(
                    "/"+fbId+"/picture",
                    {type:"large"},
                    function (response) {
                        if (response && !response.error) {
                            console.log(response.data.url);
                            fbLink = response.data.url;
                            $("#quiz2FbUrl").val(fbLink);
                        }
                    }
                );
//                        show modal
                $("#quiz2step1").modal("show");
            }
        });
    }
    $("#quiz2Play, #discover-now .quiz-2").click(function(event){
        event.preventDefault();
        quiz2Play();
    });

//            form quiz2 submit
    $("#quiz2step1form").submit(function(event){
        event.preventDefault();
        $("#quiz2step1form").ajaxSubmit({
            success:function(data){
                $("#quiz2step2").replaceWith(data);
                $("#quiz2step1").modal("hide");
                $("#quiz2step1").on("hidden.bs.modal",function(){
                    $("#quiz2step2").modal("show");
                });


                $("#shareFbQuiz2").click(function(){
//                             share facebook quiz2
                    var url = $(this).data("thumbnail");
                    FB.ui({
                        method: 'share',
                        href: fbShare2Url,
                        picture:url,
                        caption: "SẮC MÀU PHONG THUỶ HỌC",
                        uri_redirect:fbShare2Url,
                        description:"Màu sắc nào phù hợp với tính cách, mang lại cho bạn nhiều may mắn theo phong thuỷ? Cùng sơn Galaxy tìm ra sắc màu thành công trong cuộc sống..."
                    }, function(response){
                        console.log(response);
                        $("#quiz2step2").modal("hide");
                        $("#quiz2step2").on("hidden.bs.modal",function(){
                            $("#quiz2step3").modal("show");
                        });

                    });
                });

            },
            error:function(xhr){
                var errors = $.parseJSON(xhr.responseText);
                for(i=0;i<errors.length;i++){
                    var ele = errors[i];
                    $(ele).addClass("has-error");
                }
//                        alert("Bạn hãy kiểm tra lại thông tin nhé!");
            }
        })
    });
    $("#quiz2step1 .form-control").each(function(){
        var val = $(this).val();
        if($.trim(val)==""){
            $(this).removeClass("isValue");
        }else{
            $(this).addClass("isValue");
        }
    });
    $("#quiz2step1 .form-control").focus(function(){
                $(this).removeClass("has-error");
        $(this).addClass("isValue");
    });
    $("#quiz2step1 .form-control").blur(function(){
        var val = $(this).val();
        if($.trim(val)==""){
            $(this).removeClass("isValue");
        }

        var email = $("#fullInputEmail").val();
        var name = $("#fullInputName").val();
        var phone = $("#phoneNumber").val();
        var address = $("#fullInputAddress").val();
        var job = $("#jobInput").val();
        var dob = $("#dobInput").val();

        if($.trim("email")!= ""
            && $.trim("name")!= ""
            && $.trim("phone")!= ""
            && $.trim("address")!= ""
            && $.trim("job")!= ""
            && $.trim("dob")!= ""
        ){


        }
    });
});