package pojo;

public class Books {
    private Integer bookID;
    private String bookName;
    public Integer getBookID() {
        return bookID;
    }
    public void setBookID(Integer bookID) {
        this.bookID = bookID;
    }
    public String getBookName() {
        return bookName;
    }
    public void setBookName(String bookName) {
        this.bookName = bookName;
    }
    public Integer getBookCounts() {
        return bookCounts;
    }
    public void setBookCounts(Integer bookCounts) {
        this.bookCounts = bookCounts;
    }
    private Integer bookCounts;
    private String detail;
    public String getDetail() {
        return detail;
    }
    public void setDetail(String detail) { this.detail = detail == null ? null : detail.trim(); }
    @Override
    public String toString() {
        return "Books{" +
                "bookIDd=" + bookID +
                ", bookName='" + bookName + '\'' +
                ", bookCounts=" + bookCounts +
                ", detail='" + detail + '\'' +
                '}';

    }}
