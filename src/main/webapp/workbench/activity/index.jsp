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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


	<script type="text/javascript">

	$(function(){

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		//为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {

			/*

				关于模态窗口的操作：
					取得需要操作的模态窗口的jquery对象，调用modal方法，为该方法传递参数，show（打开模态窗口），hide（关闭模态窗口）

			 */

			//alert(123);

			//$("#createActivityModal").modal("show");

			//先过后台，取得用户信息列表，将用户信息铺在所有者下拉框中，然后再打开模态窗口
			$.ajax({

				url : "workbench/activity/getUserList.do",
				type : "get",
				dataType : "json",
				success : function (data) {

					/*

						data
							List<User> uList
							[{用户1},{2},{3}]


					 */

					var html = "<option></option>";

					//每一个n就是每一个用户对象
					$.each(data,function (i,n) {

						html += "<option value='"+n.id+"'>"+n.name+"</option>";

					})

					$("#create-owner").html(html);


					//将当前登录的用户作为所有者下拉框默认的选项
					//取得当前登录用户的id
					/*

						在js中，通过el表达式来取值，el表达式一定要套用在字符串中

					 */
					var id = "${user.id}";

					$("#create-owner").val(id);

					//为下拉框赋值之后，我们需要将模态窗口打开
					$("#createActivityModal").modal("show");




				}

			})

		})


		//为保存按钮绑定事件，执行市场活动的添加操作
		$("#saveBtn").click(function () {

			$.ajax({

				url : "workbench/activity/save.do",
				data : {

					"owner" : $.trim($("#create-owner").val()),
					"name" : $.trim($("#create-name").val()),
					"startDate" : $.trim($("#create-startDate").val()),
					"endDate" : $.trim($("#create-endDate").val()),
					"cost" : $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-description").val())


				},
				type : "post",
				dataType : "json",
				success : function (data) {

					/*

						data
							{"success":true/false}

					 */

					if(data.success){

						//添加市场活动成功后

						//刷新市场活动列表
						/*

							参数：$("#activityPage").bs_pagination('getOption', 'currentPage')
								操作之后，回到当前页

							参数：$("#activityPage").bs_pagination('getOption', 'rowsPerPage')
								操作之后，维持每页展现的记录数


						*/
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));



						//清空添加操作模态窗口表单中的数据
						//以重置表单的方式来清空数据
						/*

							form表单的jquery对象，为我们提供了submit方法用来提交表单
							但是没有为我们提供reset方法重置表单

							jquery没有提供重置的机制，原生的dom提供了

							将jquery对象转换为dom对象
								jauery对象[0]

							将dom对象转换为jquery对象
								$(dom)

						 */
						//$("#activitySaveForm")[0].reset();

						//关闭模态窗口
						$("#createActivityModal").modal("hide");



					}else{

						alert("添加市场活动失败");

					}


				}

			})

		})


		//页面加载完毕后，查询并展现市场活动信息列表
		pageList(1,2);

		//为查询按钮绑定事件，根据查询条件，查询市场互动信息列表
		$("#searchBtn").click(function () {


			//将查询框中的信息保存到隐藏域中
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));

			pageList(1,2);

		})

		//为全选的复选框绑定事件，实现全选/全反选的操作
		$("#qx").click(function () {

			/*if($("#qx").prop("checked")){

				//alert("全选");
				$("input[name=xz]").prop("checked",true);

			}else{

				//alert("反选");
				$("input[name=xz]").prop("checked",false);
			}*/

			$("input[name=xz]").prop("checked",this.checked);


		})

		/*

			所有name=xz的input元素，不是页面中原有的元素，而是我们通过js代码动态拼接生成的

			在样的元素，我们不能够通过传统的方式来对元素进行事件的绑定

		 */
		/*$("input[name=xz]").click(function () {

			alert(123);

		})*/

		/*

			动态拼接出来的元素，我们是用的on的方式来进行事件的绑定

			语法：
				$(需要绑定的元素的有效的父级元素).on(绑定事件的方式,需要绑定的元素,定义回调函数)

		 */

		$("#activityBody").on("click",$("input[name=xz]"),function () {

			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);

		})

		//为删除按钮绑定事件，执行市场活动的删除操作
		$("#deleteBtn").click(function () {

			//得到所有挑√的复选框的jquery对象
			var $xz = $("input[name=xz]:checked");

			if($xz.length==0){

				alert("请选择需要删除的记录");


			//肯定对复选框挑√了，但是不一定挑了几个√
			}else{

				if(confirm("删不删？！")){

					//alert("执行删除操作");
					//处理id
					//由于可以执行批量删除的操作，所以最终将参数应该拼接成为
					//id=xxx&id=yyy&id=zzz这种形式
					var param = "";

					for(var i=0;i<$xz.length;i++){

						param += "id="+$($xz[i]).val();

						//如果不是最后一条元素
						if(i<$xz.length-1){

							param += "&";

						}

					}

					$.ajax({

						url : "workbench/activity/delete.do",
						data : param,
						type : "post",
						dataType : "json",
						success : function (data) {

							/*

                                data
                                    {"success":true/false}

                             */
							if(data.success){

								//删除成功后，刷新市场互动信息列表
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

							}else{

								alert("删除市场活动失败");

							}


						}

					})

				}


			}


		})


		//为修改按钮绑定事件，打开修改操作的模态窗口
		$("#editBtn").click(function () {

			var $xz = $("input[name=xz]:checked");

			if($xz.length==0){

				alert("请选择需要修改的记录");


			}else if($xz.length>1){

				alert("只能选择一条记录进行修改");

			//肯定挑√，保证只是一个√
			}else{

				//我们需要修改的记录的id
				var id = $xz.val();

				$.ajax({

					url : "workbench/activity/getUserListAndActivity.do",
					data : {

						"id" : id

					},
					type : "get",
					dataType : "json",
					success : function (data) {

						/*

							data

								我们需要管后台要List<User> uList
												[{用户1},{2},{3}]

								还得要一个市场活动单条 Activity a
												{"a":?}


								{"uList":[{用户1},{2},{3}],"a":{市场活动}}

						 */

						var html = "<option></option>";

						$.each(data.uList,function (i,n) {

							html += "<option value='"+n.id+"'>"+n.name+"</option>";

						})

						//为所有者下拉框赋与可选元素
						$("#edit-owner").html(html);

						//为修改操作模态窗口中的下拉框，文本框，文本域赋值
						$("#edit-owner").val(data.a.owner);
						$("#edit-name").val(data.a.name);
						$("#edit-startDate").val(data.a.startDate);
						$("#edit-endDate").val(data.a.endDate);
						$("#edit-cost").val(data.a.cost);
						$("#edit-description").val(data.a.description);
						$("#edit-id").val(data.a.id);

						//修改操作模态窗口中的所有数据处理完毕后，打开模态窗口
						$("#editActivityModal").modal("show");


					}

				})


			}




		})


		//为更新按钮绑定事件，执行市场活动的修改操作
		$("#updateBtn").click(function () {

			$.ajax({

				url : "workbench/activity/update.do",
				data : {

					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"name" : $.trim($("#edit-name").val()),
					"startDate" : $.trim($("#edit-startDate").val()),
					"endDate" : $.trim($("#edit-endDate").val()),
					"cost" : $.trim($("#edit-cost").val()),
					"description" : $.trim($("#edit-description").val())


				},
				type : "post",
				dataType : "json",
				success : function (data) {

					if(data.success){

						//修改市场活动成功后

						//刷新市场活动列表
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));



						//关闭模态窗口
						$("#editActivityModal").modal("hide");



					}else{

						alert("修改市场活动失败");

					}


				}

			})

		})

	});

	/*

		pageList方法：（局部）刷新市场活动列表的方法

		该方法应该都有哪些入口呢？（我们在执行什么操作的时候，需要执行该方法？）
		（1）点击左边菜单中的"市场活动"，需要调用pageList方法，局部刷新市场活动信息列表
		（2）添加操作后，需要调用pageList方法，局部刷新市场活动信息列表
		（3）修改操作后，需要调用pageList方法，局部刷新市场活动信息列表
		（4）删除操作后，需要调用pageList方法，局部刷新市场活动信息列表
		（5）点击"查询"按钮之后
		（6）点击分页组件的时候


	 */
	/*

		关于参数：

		分页操作相关的参数
		pageNo：当前页的页码（当前是第几页）
		pageSize：每页展现多少条记录
		在所有的分页操作中，pageNo和pageSize是最重要的分页基础参数
						  有了这两个参数，我们就可以操作当前页面中的分页组件了
						  有了这两个参数，其他所有的分页相关的数据我们都可以计算出来

		条件查询相关的参数
		name
		owner
		startDate
		endDate


		我们要为后台传递的参数
		除了分页相关的两个参数pageNo和pageSize之外，还需要哪些参数呢？
		还需要name,owner,startDate,endDate这4个参数

		共为后台传递6个参数


	 */
	function pageList(pageNo,pageSize) {

		//将全选的复选框的√灭掉
		$("#qx").prop("checked",false);

		//将隐藏域中保存的信息，赋值到搜索框中
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));

		//alert("（局部）刷新市场活动列表");

		$.ajax({

			url : "workbench/activity/pageList.do",
			data : {

				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"name" : $.trim($("#search-name").val()),
				"owner" : $.trim($("#search-owner").val()),
				"startDate" : $.trim($("#search-startDate").val()),
				"endDate" : $.trim($("#search-endDate").val())

			},
			type : "get",
			dataType : "json",
			success : function (data) {

				/*

					我们需要后台为我们提供如下两项信息
					List<Activity> dataList   [{市场活动1},{2},{3}]
					int total	{"total":100} 总数 ：

					{"total":100,"dataList":[{市场活动1},{2},{3}]}

				 */

				//alert(data);

				var html = "";
				$.each(data.dataList,function (i,n) {

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.startDate+'</td>';
					html += '<td>'+n.endDate+'</td>';
					html += '</tr>';

				})

				$("#activityBody").html(html);


				//处理总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;


				//数据展现完毕后，使用bootstrap的分页插件帮我们进行前端的分页相关功能的操作
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					//该函数的触发时机为：当点击分页组件的时候，触发该函数
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});


			}

		})

	}

	
</script>
</head>
<body>

	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id"/>

						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">



								</select>
							</div>
							<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startDate">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endDate">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<!--

									关于textarea
										从元素的本身标签对来讲，操作值就相当于是操作标签对中的内容

										textarea虽然是标签对，虽然没有value属性，我们仍然要将textarea当做表单元素来处理

										只要是表单元素，我们统一使用val()方法（注意：不是html()方法）来进行存取值得操作


								-->
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activitySaveForm" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">




								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<!--

						data-dismiss="modal"
							关闭模态窗口

					-->
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	

	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--

						通过 模态窗口（模态框） 的形式 来打开添加操作的表单

						data-toggle="modal"
							该属性表示要通过触发模态窗口的形式来进行相关操作
							modal（模态窗口）

						data-target="#createActivityModal"
							该属性是指定我们需要打开的模态窗口
							对于模态窗口一般情况下，仅仅只是存在在当前页面下的一个div
							只不过这个div已ui框架操控的形式进行展现或是隐藏
							以上属性是通过#id的形式来找到指定的div，并展现该div

						需求：

							我们现在需要在展现模态窗口之前，要弹出一个alert(123)
							现在是做不到的，因为触发模态窗口是以固定写好的属性和属性值的形式存在的

							在实际项目开发中，我们不应该以在元素中写成固定的属性和属性值的形式来触发元素的行为
							元素的行为应该由我们自己去写，自己去决定

					-->
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称123</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">

				<div id="activityPage"></div>

			</div>
			
		</div>
		
	</div>
</body>
</html>