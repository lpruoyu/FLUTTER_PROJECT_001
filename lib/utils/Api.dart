// domain
const String domain = "http://jd.itying.com/";

const String domain2 = "${domain}api/";

// 轮播图接口 请求方式：GET
const String bannerURL = "${domain2}focus";

// 商品分类接口 请求方式：GET
const String productCategory = "${domain2}pcate";

// 商品列表接口
const String productList = "${domain2}plist";

// 猜你喜欢
const String guessYouLike = "$productList?is_best=1";

// 热门推荐
const String hotProduct = "$productList?is_hot=1";

// 商品一级分类
const String productCate1 = "${domain2}pcate";

// 商品二级分类
// http://jd.itying.com/api/pcate?pid=59f1e1ada1da8b15d42234e9
const String productCate2 = "$productCate1?pid=";

// 商品详情
// http://jd.itying.com/api/pcontent?id=59f6a2d27ac40b223cfdcf81
const String productDetails = "${domain2}pcontent?id=";