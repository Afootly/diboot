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
        <form  action="${pageContext.request.contextPath}/book/booklike" class="form-inline" method="post">
            <div class="form-group">
<%--                <label for="exampleInputName2">Name</label>--%>
                <input type="text" class="form-control"  name="queryBookName" id="exampleInputName2" placeholder="请输入要要查询书籍的名称">
            </div>
<%--            <div class="form-group">--%>
<%--                <label for="exampleInputEmail2">Email</label>--%>
<%--                <input type="email" class="form-control" id="exampleInputEmail2" placeholder="jane.doe@example.com">--%>
<%--            </div>--%>
            <button type="submit" class="btn btn-default">查询</button>
        </form>
    </div>
    <div class="row clearfix">
        <div class="col-md-12 column">
            <table class="table table-hover table-stript">

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
                <c:forEach var="books" items="${list}">
                    <tr>
                        <td>${books.bookID}</td>
                        <td>${books.bookName}</td>
                        <td>${books.bookCounts}</td>
                        <td>${books.detail}</td>
                        <td>
                            <form action="/book/book/${books.bookID }" method="post">
                                <input type="hidden" name="_method" value="DELETE">
                                <input id="deletebtn" type="submit" class="" value="删除">
<%--                                使用restful风格--%>
                            </form>
                            &nbsp;|&nbsp; <a href="/book/book/${books.bookID}">修改</a>


                        </td>

                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
<style>
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
</html>
