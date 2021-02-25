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

    <link href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
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
        <button type="button" class="btn btn-success">
            <a style="text-decoration: none;color: azure" href="${pageContext.request.contextPath}/book/toaddbookpage">添加书籍</a>
        </button>
    </div>
    <div class="col-md-4 column">
        <form action="${pageContext.request.contextPath}/book/booklike" class="form-inline" method="post">
            <div class="form-group">
                <%--                <label for="exampleInputName2">Name</label>--%>
                <input type="text" class="form-control" name="queryBookName" id="exampleInputName2"
                       placeholder="请输入要要查询书籍的名称">
            </div>
            <button type="submit" class="btn btn-default">查询</button>
        </form>
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
                <%--                <div  class="alert alert-danger" role="alert">...</div>--%>
                </thead>
                <tbody>
                <%--                <c:forEach var="books" items="${pageinfo_list.list}">--%>
                <%--                    <tr>--%>
                <%--                        <td>${books.bookID}</td>--%>
                <%--                        <td>${books.bookName}</td>--%>
                <%--                        <td>${books.bookCounts}</td>--%>
                <%--                        <td>${books.detail}</td>--%>
                <%--                        <td>--%>
                <%--                            <form action="/book/book/${books.bookID }" method="post">--%>
                <%--                                <input type="hidden" name="_method" value="DELETE">--%>
                <%--                                <input id="deletebtn" type="submit" class="" value="删除">--%>
                <%--                                    &lt;%&ndash;                                使用restful风格&ndash;%&gt;--%>
                <%--                            </form>--%>
                <%--                            &nbsp;|&nbsp; <a href="/book/book/${books.bookID}">修改</a>--%>


                <%--                        </td>--%>

                <%--                    </tr>--%>
                <%--                </c:forEach>--%>
                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <%--        分页文字信息--%>
        <div class="col-md-6" id="page_info_area">


            <%--            当前${pageinfo_list.pageNum}页，共${pageinfo_list.pages}页，共${pageinfo_list.total}条记录--%>
        </div>
        <%--    分页条信息--%>
        <div class="col-md-6" id="page_nav_area">
            <%--            <nav aria-label="Page navigation">--%>
            <%--                <ul class="pagination">--%>
            <%--                    <li><a href="${pageContext.request.contextPath}/book/books?pn=1">首页</a></li>--%>
            <%--                    <c:if test="${pageinfo_list.hasPreviousPage}">--%>
            <%--                        <li>--%>
            <%--                            <a href="${pageContext.request.contextPath}/book/books?pn=${pageinfo_list.pageNum-1}"--%>
            <%--                               aria-label="Previous">--%>
            <%--                                <span aria-hidden="true">&laquo;</span>--%>
            <%--                            </a>--%>
            <%--                        </li>--%>
            <%--                    </c:if>--%>

            <%--                    <c:forEach items="${pageinfo_list.navigatepageNums}" var="page_Num">--%>
            <%--                        <c:if test="${page_Num==pageinfo_list.pageNum}">--%>
            <%--                            <li class="active"><a href="#">${page_Num}</a></li>--%>
            <%--                        </c:if>--%>
            <%--                        <c:if test="${page_Num!=pageinfo_list.pageNum}">--%>
            <%--                            <li><a href="${pageContext.request.contextPath}/book/books?pn=${page_Num}">${page_Num}</a>--%>
            <%--                            </li>--%>
            <%--                        </c:if>--%>

            <%--                    </c:forEach>--%>
            <%--                    <c:if test="${pageinfo_list.hasNextPage}">--%>
            <%--                        <li>--%>
            <%--                            <a href="${pageContext.request.contextPath}/book/books?pn=${pageinfo_list.pageNum+1}" aria-label="Next">--%>
            <%--                                <span aria-hidden="true">&raquo;</span>--%>
            <%--                            </a>--%>
            <%--                        </li>--%>
            <%--                    </c:if>--%>
            <%--                    <li><a href="${pageContext.request.contextPath}/book/books?pn=${pageinfo_list.pages}">末页</li>--%>
            <%--                    <li>--%>
            <%--                </ul>--%>
            <%--            </nav>--%>
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
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-3.5.1.js"></script>
<script type="text/javascript">
    $(function () {
        $.ajax({
            url: "${pageContext.request.contextPath}/book/books",
            data: "pn=1",
            type: "GET",
            success: function (result) {
                // console.log(result)
                //1.解析并且显示书本信息
                build_books_table(result);

                //2.解析并显示分页信息
                build_page_info(result)

                //3.并显示分页条
                build_page_nav(result)


            }
        });

    });

    function build_books_table(result) {
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
            result.extend.pageinfo_list.pages + "页,总" +
            result.extend.pageinfo_list.total + "条记录");
        totalRecord = result.extend.pageinfo_list.total;
        currentPage = result.extend.pageinfo_list.pageNum;
    }

    //解析分页条
    function build_page_nav(result) {

    }
</script>
</html>
