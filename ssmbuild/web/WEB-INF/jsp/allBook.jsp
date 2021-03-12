<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: 30606
  Date: 2021/2/14
  Time: 20:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>booklist</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <%--    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.5.1.js"></script>--%>
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.js"></script>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>
</head>
<body>
<!-- 添加书籍模态框-->
<!-- Modal -->

<div class="container">
    <div class="row clearfix">
        <div class="col-md-12 column">
            <div class="page-header">
                <h1>
                    <small>书籍列表</small>
                </h1>

            </div>
        </div>
    </div>
    <div class="col-md-4 column" style="float: left">
        <button type="button" class="btn btn-success" id="book_add_modal_btn">
            <a style="text-decoration: none;color: azure" href="#">添加书籍</a>
        </button>
    </div>

    <div class="row clearfix">
        <div class="col-md-12 column">
            <table class="table table-hover table-stript" id="books_table">

                <thead>
                <tr>
                    <td>书籍编号</td>
                    <td>书籍名称</td>
                    <td>书籍数量</td>
                    <td>书籍描述</td>
                    <td>编辑</td>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <%--        分页文字信息--%>
        <div class="col-md-6" id="page_info_area">
        </div>
        <%--    分页条信息--%>
        <div class="col-md-6" id="page_nav_area">
        </div>
    </div>
</div>
<%--添加书籍模态框--%>
<div class="modal fade" id="bookAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">书籍添加</h4>
            </div>
            <div class="modal-body">
                <div class="container ">

                    <div>
                        <form class="form-horizontal col-md-4" id="addcontentForm">

                            <div class="form-group">
                                <label>书籍名称</label>
                                <input type="text" class="form-control" id="bookName" name="bookName" placeholder="name"
                                       required="required">
                                <span class="help-block"></span>
                            </div>
                            <div class="form-group">
                                <label>书籍数量</label>
                                <input type="text" class="form-control" id="bookCounts" name="bookCounts"
                                       placeholder="quantity" required="required">
                                <span class="help-block"></span>
                            </div>
                            <div class="form-group ">
                                <label>书籍描述</label>
                                <input type="text" class="form-control" id="detail" name="detail"
                                       placeholder="description" required="required">
                                <span class="help-block"></span>
                            </div>
                            <%--                            <div class="form-group">--%>
                            <%--                                <button type="submit" class="form-control">提交</button>--%>
                            <%--                            </div>--%>
                        </form>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-success" id="book_save-btn">保存</button>
            </div>
        </div>
    </div>
</div>
<%--修改书籍模态框--%>
<div class="modal fade" id="bookUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" >员工修改</h4>
            </div>
            <div class="modal-body">
                <div class="container ">
                    <div>
                        <form class="form-horizontal col-md-4" id="updatecontentForm">
                            <div class="form-group">
                                <label>id</label>
                               <input type="text" class="form-control" id="bookName_update_static" name="bookID" placeholder="name"
                                required="required" readonly>
                                <span class="help-block"></span>
                            </div>
                            <div class="form-group">
                                <label>书籍名称</label>
                                <input type="text" class="form-control" id="bookName_update" name="bookName" placeholder="name"
                                       required="required" >
                                <span class="help-block"></span>
                            </div>
                            <div class="form-group">
                                <label>书籍数量</label>
                                <input type="text" class="form-control" id="bookCounts_update" name="bookCounts"
                                       placeholder="quantity" required="required">
                                <span class="help-block"></span>
                            </div>
                            <div class="form-group ">
                                <label>书籍描述</label>
                                <input type="text" class="form-control" id="detail_update" name="detail"
                                       placeholder="description" required="required">
                                <span class="help-block"></span>
                            </div>
                            <%--                            <div class="form-group">--%>
                            <%--                                <button type="submit" class="form-control">提交</button>--%>
                            <%--                            </div>--%>
                        </form>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-success" id="book_update-btn">修改</button>
            </div>
        </div>
    </div>
</div>
</body>
<style type="text/css" rel="stylesheet">
    form {
        float: left;
    }

    #deletebtn {
        background: transparent; /*按钮背景透明*/
        border-width: 0px; /*边框透明*/
        outline: none; /*点击后没边框*/
        color: #337ab7;
    }

</style>
<script type="text/javascript">
    //定义一个全局的总数据条数totalRecord，currentPage：当前页方便使用
        var totalRecord, currentPage, globalpages;
    //1、页面加载完成以后，直接去发送ajax请求,要到分页数据
    $(function () {
        //去首页
        to_page(1);

    });

    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/book/books",
            data: "pn=" + pn,
            type: "GET",
            success: function (result) {
                //console.log(result);
                //1、解析并显示员工数据
                build_books_table(result);
                //2、解析并显示分页信息
                build_page_info(result);
                //3、解析显示分页条数据
                build_page_nav(result);
            }
        });
    }

    function build_books_table(result) {
        //点击某页时，清空0已经存在的数据
        $("#books_table tbody").empty();
        // 拿到书籍列表
        var books = result.extend.pageinfo_list.list;
        console.log(books)
        //遍历书籍
        $.each(books, function (index, item) {
            //构建元素
            var bookID = $("<td></td>").append(item.bookID);
            var bookName = $("<td></td>").append(item.bookName);
            var bookCounts = $("<td></td>").append(item.bookCounts);
            var detail = $("<td></td>").append(item.detail);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            //为编辑按钮添加一个自定义的属性，来表示当前员工id
            editBtn.attr("edit-id", item.bookID);
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            //为删除按钮添加一个自定义的属性来表示当前删除的员工id
            delBtn.attr("del-id", item.bookID);
            var btnTd = $("<td></td>").append(editBtn).append("   ").append(delBtn);
            $("<tr></tr>").append(bookID)
                .append(bookName)
                .append(bookCounts)
                .append(detail)
                .append(btnTd)

                //添加到那个元素
                .appendTo("#books_table tbody");

        })

    }

    //解析显示分页信息
    function build_page_info(result) {

        $("#page_info_area").empty();
        $("#page_info_area").append("当前" + result.extend.pageinfo_list.pageNum + "页,总" +
            result.extend.pageinfo_list.pages + "页,共" +
            result.extend.pageinfo_list.total + "条记录");
        currentPage = result.extend.pageinfo_list.pageNum;
        totalRecord = result.extend.pageinfo_list.total;
        globalpages = result.extend.pageinfo_list.pages


    }

    //解析分页条
    function build_page_nav(result) {
        //点击某页时，清空已经存在的数据
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");
        //构建元素
        //首页
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        //前一页
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        //判断是否还有前一页和首页，没有则不能点击
        if (result.extend.pageinfo_list.hasPreviousPage == false) {
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        } else {
            //给跳转添加点击事件
            firstPageLi.click(function () {
                to_page(1);
            })
            if (result.extend.pageinfo_list.pageNum > result.extend.pageinfo_list.firstPage) {
                prePageLi.click(function () {
                    to_page(result.extend.pageinfo_list.pageNum - 1)
                })
            }
        }


        //下一页
        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        // 末页
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
        //判断是否还有下一页
        if (result.extend.pageinfo_list.hasNextPage == false) {
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        } else {
            if (result.extend.pageinfo_list.pageNum < result.extend.pageinfo_list.pages) {
                nextPageLi.click(function () {
                    to_page(result.extend.pageinfo_list.pageNum + 1)

                })
            }
            lastPageLi.click(function () {
                to_page(result.extend.pageinfo_list.pages)

            })

        }

        //ul添加首页和前一页
        ul.append(firstPageLi).append(prePageLi)
        //1，2，3 遍历给ul添加页码提示
        $.each(result.extend.pageinfo_list.navigatepageNums, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));

            if (result.extend.pageinfo_list.pageNum == item) {
                numLi.addClass("active")
            }
            //给页面按钮添加点击事件
            numLi.click(function () {
                to_page(item);

            })
            ul.append(numLi);
        })
        ul.append(nextPageLi).append(lastPageLi)
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    //点击添加书籍，弹出模态框
    $("#book_add_modal_btn").click(function () {

        $("#bookAddModal").modal({
            backdrop: "static"
        })
    });
   //校验用户名是否存在
    $("bookName").change(function () {
        //发送ajax请求验证用户是否可用
        var BookName=this.value();
        $.ajax({
            url:"${APP_PATH}/checkbook",
            data:"BookName="+BookName,
            type:"GET",
            success:function (result) {
                if (result.code==100){
                    show_validate_msg($("#bookName"),"seccess","");
                }else {
                    show_validate_msg($("#bookName"),"error","用户名已存在");
                }

            }
        })

    })

    //保存按钮点击事件
    $("#book_save-btn").click(function () {
        //1.将模态框写入的数据交给服务器保存
        //2.发送ajax请求保存员工
//serialize()方法：将写写入的数据序列化再交给服务器//
// 3、先对要提交给服务器的数据进行校验
        if (!validate_add_form()) {
            return false;
        };
        $.ajax({
            url: "${APP_PATH}/book/book",
            type: "POST",
            data: $("#bookAddModal  form").serialize(),
            success: function (result) {
                //后端校验成功
             if (result.code==100){
                 console.log(result)
                 //关闭模态框
                 $("#bookAddModal").modal("hide")
                 //返回到添加后的最后一页
                 to_page(globalpages);
                 //清除弹框后保留的数据
                 $('#bookAddModal').on('hidden.bs.modal', function () {
                     document.getElementById("contentForm").reset();
                 });
             }else {
                 console.log(result)
             }


            }
        })
    });




    //拿到校验的数据，使用正则表达式

    function validate_add_form(){
        //校验名称
        var bookName = $("#bookName").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;

        //每次进入应该清除表单的样式和数据
        if (!regName.test(bookName)) {
            // $("#bookName").parent().addClass("has-error")
            // $("#bookName").next("span").text("用户格式有误")
            show_validate_msg($("#bookName"),"error","用户名格式有误");
            return false;
        }else {
            // $("#bookName").parent().addClass("has-success");
            show_validate_msg($("#bookName"),"seccess","");
            return true;
        }
        //校验邮箱
        var detail = $("#detail").val();
        var regdetail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regdetail.test(detail)){
            // $("#bookCounts").parent().addClass("has-error");
            // $("#bookCounts").next("span").text("邮箱格式有误")
            show_validate_msg($("#detail"),"error","邮箱格式有误");
            return false;
        }else {
            // $("#bookCounts").parent().addClass("hsa-error");
            show_validate_msg($("#bookCounts"),"success","");
            return  true;
    }}
    //显示校验结果的提示信息
    function show_validate_msg(ele,status,msg){
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if("success"==status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if("error" == status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
        // $("#bookName").mouseleave(function(){
        //     alert("再见，您的鼠标离开了该段落。");
        // });
    }
    //在创建按钮之前就绑定了click,所以绑定不上
    //可以在创建按钮的时候绑定。=》绑定点击live（）
    //juery新版没有live.可以用 on进行 代替
 $(document).on("click",".edit_btn",function () {
     //1.查出书籍信息回显
     getBook($(this).attr("edit-id"))
     //把员工的id传递给模态框的更新按钮
     $("#book_update-btn").attr("edit-id",$(this).attr("edit-id"))
     //2弹出模态框
     $("#bookUpdateModal").modal({
         backdrop: "static"
     })

 })
    function getBook(id) {
        $.ajax({
            url:"${APP_PATH}/book/book/"+id,
            type:"GET",
            success:function (result) {
                var bookDate=result.extend.book;
                $("#bookName_update_static").val(bookDate.bookID);
                $("#bookName_update").val(bookDate.bookName);
                $("#bookCounts_update").val(bookDate.bookCounts);
                $("#detail_update").val(bookDate.detail);

            }

        })
    }
    //给修改按钮绑定事件

    $("#book_update-btn").click(function () {
        // //验证书籍名称是否合法
        // //校验名称
        // var bookName = $("#bookName_update").val();
        // var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        //
        // //每次进入应该清除表单的样式和数据
        // if (!regName.test(bookName)) {
        //     // $("#bookName").parent().addClass("has-error")
        //     // $("#bookName").next("span").text("用户格式有误")
        //     show_validate_msg($("#bookName_update"),"error","用户名格式有误");
        //     return false;
        // }else {
        //     // $("#bookName").parent().addClass("has-success");
        //     show_validate_msg($("#bookName_update"),"seccess","");
        // }
        //
        // //发送请求修改书籍
        alert("点击了")
        console.log($("#updatecontentForm").serialize())
        $.ajax({
            url:"${APP_PATH}/book/book",
            type:"PUT",
            data: $("#bookUpdateModal form ").serialize(),
            success:function (result) {
                console.log(result)
                //1.关闭模态框
                $("#bookUpdateModal").modal("hide");
                //2.回到本页面
                to_page(currentPage)


            }
        })



    })

</script>
</html>
