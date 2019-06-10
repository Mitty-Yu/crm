<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script>

		$(function () {

			/*

				如果顶层窗口不是当前窗口，需要将顶层窗口设置为当前窗口

			*/
			if(window.top!=window){
				window.top.location=window.location;
			}


			//页面加载完毕后，将用户名文本框中的信息清空
			$("#loginAct").val("");


			//页面加载完毕后，将焦点定位在用户名文本框中
			$("#loginAct").focus();


			//为登录按钮绑定事件，执行登录操作
			$("#submitBtn").click(function () {

				login();

			})

			//为窗口绑定 敲键盘事件 ，如果一旦敲的是回车，我们需要执行登录操作
			/*

				通过event参数，可以取得敲的键位的码值，如果码值为13，说明敲的是回车键

			 */
			$(window).keydown(function (event) {

				//如果是回车键
				if(event.keyCode==13){

					login();

				}

			})



		})

		/*

			注意：
				我们自己创建的function方法，一定要写在$(function(){})的外面
		 */

		function login() {

			//alert("执行登录操作123456");

			//验证账号密码不能为空
			//$.trim(内容)
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());

			if(loginAct=="" || loginPwd==""){

				$("#msg").html("账号密码不能为空");

				//如果程序执行到了该行，说明账号密码为空了，需要及时强制终止方法
				return false;

			}

			/*

				如果以上if不走，说明账号密码是正确的

				需要将请求发送到后台，验证账号密码是否正确

				需要发出ajax请求，局部刷新错误消息


			 */

			$.ajax({

				url : "settings/user/login.do",
				data : {

					"loginAct" : loginAct,
					"loginPwd" : loginPwd

				},
				type : "post",
				dataType : "json",
				success : function (data) {

					/*

						data
							{"success":true/false,"msg":?}

					 */

					//如果登录成功
					if(data.success){

						//登录成功后，需要跳转到工作台初始页（项目的欢迎页）
						window.location.href = "workbench/index.jsp";

					//如果登录失败
					}else{

						$("#msg").html(data.msg);

					}



				}

			})


		}

	</script>


</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red;"></span>
						
					</div>
					<!--

						type="submit":提交表单 执行action="workbench/index.jsp"路径

						一定要将type设置为button，按钮的行为由我们自己来决定

					-->
					<button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录123</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>