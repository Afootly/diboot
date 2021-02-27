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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
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
    <div class="col-md-4 column" style="float: left" >
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
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">书籍添加</h4>
            </div>
            <div class="modal-body">
                <div class="container "   >
<%--                    <div class="row clearfix">--%>
<%--                        <div class="col-md-12 column">--%>
<%--                            <div class="page-header">--%>
<%--                                <h1>--%>
<%--                                    <small>添加书籍</small>--%>
<%--                                </h1>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
                    <div>
                        <form  class="form-horizontal col-md-4"  id="contentForm" >

                            <div class="form-group">
                                <label>书籍名称</label>
                                <input type="text" class="form-control" name="bookName"  placeholder="name" required>
                            </div>
                            <div class="form-group">
                                <label>书籍数量</label>
                                <input type="text" class="form-control" name="bookCounts"   placeholder="quantity" required>
                            </div>
                            <div class="form-group ">
                                <label>书籍描述</label>
                                <input type="text" class="form-control" name="detail"  placeholder="description" required>
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
	var totalRecord,currentPage,globalpages;
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
        //点击某页时，情况已经存在的数据
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
        globalpages= result.extend.pageinfo_list.pages




    }

    //解析分页条
    function build_page_nav(result) {
        //点击某页时，情况已经存在的数据
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
            //给页面按钮添加点击实践
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
            backdrop:"static"
        })


    })
    //保存按钮点击事件
    $("#book_save-btn").click(function () {


        //1.将模态框写入的数据交给服务器保存
        //2.发送ajax请求保存员工
//serialize()方法：将写写入的数据序列化再交给服务器

        $.ajax({
            url:"${APP_PATH}/book/book",
            type: "POST",
            data: $("#bookAddModal  form").serialize(),
            success:function (result) {
                alert(result.msg)
                //关闭模态框
                $("#bookAddModal").modal("hide")
                //返回到添加后的最后一页
                to_page(globalpages);
                //清除弹框后保留的数据
                $('#bookAddModal').on('hidden.bs.modal', function (){
                    document.getElementById("contentForm").reset();
                });
            }

        })


    })

</script>
</html>
