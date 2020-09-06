<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="kr">
	<head>
	<meta charset="UTF-8">
    <title>Welcome to 2048!</title>
    <link href="Homepage_style.css" rel="stylesheet">
</head>
<body>
<script src="https://www.gstatic.com/firebasejs/5.5.9/firebase.js"></script>
<script>
  // Initialize Firebase
  var config = {
    apiKey: "AIzaSyAjg0doqHhzd0-v3f7TaOHG_PRMMNZK-fM",
    authDomain: "internet-programming-7619a.firebaseapp.com",
    databaseURL: "https://internet-programming-7619a.firebaseio.com",
    projectId: "internet-programming-7619a",
    storageBucket: "internet-programming-7619a.appspot.com",
    messagingSenderId: "99018689333"
  };
  firebase.initializeApp(config);
</script>


<div class="form">
  <div class="form-toggle"></div>
  
  <!-- 로그인 폼-->
  <div class="form-panel one">
    <div class="form-header">
      <h1>2048</h1>
    </div>
    <div class="form-content">
     <form id = "form1" method="POST">
        <div class="form-group">
          <label for="username">아이디</label>
          <input type="text" id="userID" name="userID" required="required">
        </div>
        <div class="form-group">
          <label for="password">비밀번호</label>
          <input type="password" id="userPW" name="userPW" required="required"/>
        </div>
        <div class="form-group">
          <label class="form-remember">
            <input type="checkbox"/>아이디 저장
          </label>
          <a href="#" class="form-recovery" onclick = "findPW()">비밀번호를 잊으셨나요?</a>
		  <a href="#" class="form-recovery" onclick = "makeUser()">지금 즉시 회원가입!</a>
        </div>
        <div class="form-group">
          <button type="submit" onclick = "login()">로그인</button>
        </div>
      </form>
    </div>
  </div>

  <!-- 회원가입 폼-->
  <div class="form-panel two">
    <div class="form-header">
      <h1>회원가입</h1>
    </div>
    <div class="form-content">
      <form>
        <div class="form-group">
          <div class = "form-id">
          <label for="username">아이디</label>
          <input type="text" id="makeID" name="userID" required="required"/>
          </div>
          <div class = "check-id">
          <input type="button" value = "중복확인" id = "checkID" onclick = "CheckID()">
          </div>
        </div>
        <div class="form-group">
          <label for="password">비밀번호</label>
          <input type="password" id="makePW" name="makePW" required="required"/>
        </div>
        <div class="form-group">
          <label for="cpassword">비밀번호 확인</label>
          <input type="password" id="confirmPW" name="confirmPW" required="required"/>
        </div>
        <div class="form-group">
          <label for="email">이메일 주소</label>
          <input type="email" id="makeEmail" name="makeEmail" required="required"/>
        </div>
        <div class="form-group">
          <button type="submit" id = "submit" onclick = "notice()">등록하기!</button>
        </div>
      </form>
    </div>
  </div>
  
  <!-- 비밀번호 변경 폼-->
  <div class="form-panel three">
    <div class="form-header">
      <h1>비밀번호 변경</h1>
    </div>
    <div class="form-content">
      <form>
        <div class="form-group">
          <div class = "form-id">
          <label for="username">아이디</label>
          <input type="text" id="confirmID" name="confirmID" required="required"/>
          </div>
        </div>
        <div class="form-group">
          <label for="email">이메일 주소</label>
          <input type="email" id="confirmEmail" name="confirmEmail" required="required"/>
        </div>
        <div class="form-group">
          <label for="cpassword">새로운 비밀번호</label>
          <input type="password" id="newPW" name="newPW" required="required"/>
        </div>
        <div class="form-group">
          <label for="cpassword">비밀번호 확인</label>
          <input type="password" id="confirm-newPW" name="confirm-newPW" required="required"/>
        </div>

        
        <div class="form-group">
          <button type="submit" onclick = "changePW()">비밀번호 바꾸기!</button>
        </div>
      </form>
    </div>
  </div>
  
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script> 
<script type="text/javascript">
var user_data = firebase.database().ref('user_data');
var confirm = new Boolean();
var enable = new Boolean();
var check_equal = new Boolean();
var panelOne = $('.form-panel.two').height(),
    panelTwo = $('.form-panel.two')[0].scrollHeight;
	panelThree = $('.form-panel.three')[0].scrollHeight;

//두개의 폼이 동시에 보여지는 걸 방지하기 위한 변수
var activePanel1 = new Boolean();
var activePanel2 = new Boolean();
activePanel1 = true
activePanel2 = true;

check_equal = false;
enable = false;
confirm = false;

//data 배열에 모든 유저의 id를 불러옵니다.
var data = new Array();
user_data.on('value', function(snapshot) {
  data.splice(0, data.length);
  snapshot.forEach(function(childSnapshot) {
    var childData = childSnapshot.val();
    data.push(childData.user_id);
  });
});


document.onkeydown = function (event) {
    if(event.keyCode === 13) {
    	if(activePanel1 == false){
			changePW();
    	}
    	else if(activePanel2 == false){
    		notice();
    	}
    	else{
    		login();
    	}
    }
}

//회원가입 폼이 뜨게 하는 jquery문입니다.
function makeUser(){
	  $(document).ready(function() {
	    $('.form-toggle').addClass('visible');
	    $('.form-panel.one').addClass('hidden');
	    $('.form-panel.two').addClass('active');
	    $('.form').animate({
	      'height': panelTwo
	    }, 200);
	    activePanel2 = false;
	  });
	}

//비밀번호 변경 폼이 뜨게 하는 jquery문입니다.
function findPW(){
	  $(document).ready(function() {
	    $('.form-toggle').addClass('visible');
	    $('.form-panel.one').addClass('hidden');
	    $('.form-panel.three').addClass('active');
	    $('.form').animate({
	      'height': panelThree
	    }, 200);
	    activePanel1 = false;
	  });
	}



$(document).ready(function() {

//회원가입 폼으로 가고자 할 때
  $('.form-panel.two').not('.form-panel.two.active').on('click', function(e) {
	if(activePanel1){
		makeUser();
	}
  });
  
//비밀번호 변경 폼으로 가고자 할 때
  $('.form-panel.three').not('.form-panel.three.active').on('click', function(e) {
	  if(activePanel2){
	    findPW();
	  }
  });
  
//회원가입 폼에서 로그인 폼으로 돌아가고자 할 때
  $('.form-toggle').on('click', function(e) {
    e.preventDefault();
    $(this).removeClass('visible');
    $('.form-panel.one').removeClass('hidden');
    $('.form-panel.two').removeClass('active');
    $('.form').animate({
      'height': panelOne
    }, 200);
    activePanel2= true;
  });
  
//비밀번호 변경 폼에서 로그인 폼으로 돌아가고자 할 때
  $('.form-toggle').on('click', function(e) {
    e.preventDefault();
    $(this).removeClass('visible');
    $('.form-panel.one').removeClass('hidden');
    $('.form-panel.three').removeClass('active');
    $('.form').animate({
      'height': panelOne
    }, 200);
    activePanel1 = true;
  });
});






//회원가입시 아이디 중복확인
function CheckID(){
	var id = $('#makeID').val();
	for(var i =0; i<data.length; i++){
		if(id.trim() == data[i]){
			enable = false;
			alert("이미 사용중인 아이디입니다.");
			break;
		}
		else if(id.trim() == ""){
			enable = false;
			alert("아이디를 먼저 입력하세요.");
			break;
		}
		else{
			enable = true;
		}
	}
	if(enable){
		alert("사용 가능한 아이디입니다.");
	}
	
}

//회원가입 확인 함수
function notice(){
	var id = $('#makeID').val();
	var pw = $('#makePW').val();
	var em = $('#makeEmail').val();
	var user_profile = firebase.database().ref('user_profile/'+id);
	var user_data = firebase.database().ref('user_data/'+id);
	
    if(pw != $('#confirmPW').val()){
      alert("비밀번호 확인이 완료되지 않았습니다.\n다시 입력해주십시오.");
    }
    else if(id.trim() == ""){
      alert("아이디를 입력해주십시오.");
    }
    else if(pw.trim() == "" || $('#confirmPW').val().trim() == ""){
      alert("비밀번호를 입력해주십시오.");
    }
    else if(em.trim() == ""){
      alert("이메일를 입력해주십시오.");
    }
    else if(enable == false){
    	alert(id + "는(은) 사용 불가능한 아이디입니다.");
    }
    else{
      user_data.set({
           user_id: id,
           user_pwd: pw,
           user_email: em
      });
      user_profile.set({
    	   user_id: id,
           user_rank: "no rank",
           user_score: "0"
      });
         
     alert(id + "님의 회원가입이 완료되었습니다.");
    }
}

//로그인 확인 함수
function login(){
	var id = $('#userID').val();
	var pw = $('#userPW').val();
	var user_data = firebase.database().ref('user_data');
	var admin_data = firebase.database().ref('Administrator');
	if(id == "admin"){
		if(pw == "admin"){
			var form = document.getElementById("form1");
    		form.setAttribute("action", "./LoginServlet");
        	form.submit();
        	confirm = true;
		}
		//원래는 아래 코드로 admin의 비밀번호 값을 데이터베이스와 비교하려 했으나 
		//이상하게도 다음 페이지로 진행되지 않는 버그가 발생하여(이유불명) 위 코드로 대체합니다.
		/*
		admin_data.once('value',function(snapshot){
			var tmp = snapshot.val();
			if(pw == tmp.admin_pwd){
        		var form = document.getElementById("form1");
        		form.setAttribute("action", "./LoginServlet");
            	form.submit();
            	confirm = true;
			}
		});
		 */
		
	}
	else{
		//로그인 시 입력한 id와 비밀번호가 데이터베이스의 id와 비밀번호와 일치하는지 확인합니다. 
		user_data.once('value', function(snapshot) {
        	snapshot.forEach(function(childSnapshot) {
          	var tmp = childSnapshot.val();
          	if(tmp.user_id==id){
            	if(tmp.user_pwd==pw){
            		var form = document.getElementById("form1");
            		form.setAttribute("action", "./LoginServlet");
                	form.submit();
                	confirm = true;
            	}
          	}
          
        	});
      	});
		if(confirm == false){
			alert("아이디 혹은 비밀번호가 잘못되었습니다.");
		}
	}
}

//비밀번호 변경 확인 함수
function changePW(){
	var id = $('#confirmID').val();
	var em = $('#confirmEmail').val();
	var pw = $('#newPW').val();
	var conpw = $('#confirm-newPW').val();
	var user_data = firebase.database().ref('user_data');
	var user_id = firebase.database().ref('user_data/'+id);
	
	if(id.trim() == ""){
		alert("아이디를 입력해주십시오.");
	}
	else if(em.trim() == ""){
		alert("이메일을 입력해주십시오.");
	}
	else if(pw.trim() == "" || conpw.trim() == ""){
		alert("비밀번호를 입력해주십시오.");
	}
	else if(pw.trim() != conpw.trim()){
		alert("비밀번호가 서로 일치하지 않습니다. 다시 입력해주세요.");
	}
	// 모든 입력이 원활하게 진행되었다면
	else{
		//입력한 id와 email이 데이터베이스의 id와 email과 일치하는지 확인합니다.
		user_data.once('value', function(snapshot) {
        	snapshot.forEach(function(childSnapshot) {
          		var tmp = childSnapshot.val();
          		if(tmp.user_id==id){
            		if(tmp.user_email==em){
                		check_equal = true;
            		}
          		}
          
        	});
      	});
		// 모두 같을 시 비밀번호를 변경합니다.
		if(check_equal){
			user_id.update({
		        user_pwd: pw
		    });
		}
		else{
			alert("아이디 혹은 이메일 주소가 잘못되었습니다.");
		}
	}
}

</script>
</body>
</html>
