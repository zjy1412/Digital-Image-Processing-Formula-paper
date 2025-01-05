#import "@preview/mitex:0.2.4": *
#heading[第五章：图像复原与重建]

== 图像退化/复原模型

// #image("./img/txfy.png",height: 10%)
建模图像退化为用h算子和f运算,加上加性噪声$eta$,生成一幅退化图像g\
空域：$g(x, y) =(h star f)(x, y) + eta(x, y)$  ;
频域：$G(u, v) = H(u, v) F(u, v) +N(u, v)$

== 噪声模型

// 高斯,瑞利,伽马,指数,均匀,椒盐

*高斯* $p(z) = frac(1, sqrt(2 pi) sigma) e^(-(z - macron(z))^2 \/ 2 sigma^2)$ ;
*瑞利* $p(z) =brace.l mat(delim: #none, frac(2, b)(z - a) e^(-(z - a)^2 - b), comma z gt.eq a;
0, comma z < a,)$ || $macron(z) = a + sqrt(pi b \/ 4), sigma^2 = frac(b(4 - pi), 4)$\
*爱尔兰（伽马）*$p(z) =brace.l mat(delim: #none, frac(a^b z^(b - 1),(b - 1)!) e^(-a z), comma z gt.eq 0;
0, comma z < 0,)$ || $macron(z) = frac(b, a), sigma^2 = frac(b, a^2)$ a>0,b正整数\
*指数* $p (z) = cases(a e^(- a z) & z gt.eq 0, 0& z < 0 )$ || $macron(z) = frac(1, a), sigma^2 = frac(1, a^2)$\
*均匀* $p(z) =brace.l
mat(delim: #none, frac(1, b - a), comma a lt.eq z lt.eq b;
0, comma o t h e r w i s e,)$ || $macron(z) = frac(a + b, 2), sigma^2 = frac((b - a)^2, 12)$ ;
*椒盐* $p(z) =brace.l
mat(delim: #none, P_s, comma z = 2^(k - 1);
P_p, comma z = 0;
1 -(P_s + P_p), comma z = V,)$\
场景:高斯电子电路随机波动引起,或者传感器在低光照高温工作产生的噪声;瑞利模拟随机波动;伽马和指数模拟激光成像;均匀:随机数在指定范围内均匀分布;椒盐:成像设备中的瞬时故障或错误\
噪声估计参数参数$overline(z) = sum_(i = 0)^(L - 1) z_i p_S (z_i) quad sigma^2 = sum_(i = 0)^(L - 1) (z_i - overline(z))^2 p_S (z_i)$

== 只存在噪声的复原——空间滤波

仅被加性噪声退化后: $g(x, y) = f(x, y) + eta(x, y)$ $G(u, v) = F(u, v) +N(u, v)$ (噪声未知)\
当仅有加性噪声时，可考虑空间滤波方法，利用图像相邻像素之间的的相似性，降低噪声的影响，甚至可以有效去除噪声。

=== 均值滤波
$S_(x y)$表示中心在(x,y)，尺寸为$𝑚 times n$的矩形子图像窗口\
算术平均 $hat(f)(x, y) = frac(1, m n) sum_((r, c) in S_(x y)) g(r, c)$
;平滑图像的局部变化;在模糊了结果的同时减少了噪声\
几何平均滤波 $hat(f)(x, y) = [ product_((r, c) in S_(x y)) g(r, c) ]^frac(1, m n)$ ;
平滑度可以与算术均值相比;图像细节丢失更少\
谐波平均滤波 $hat(f)(x, y) = frac(m n, sum_((r comma c) in S_(x y)) frac(1, g(r comma c)))$ 适用“盐粒” 和 类似高斯噪声的噪声，不适用于“胡椒”;\

反谐波平均 $hat(f)(x, y) = (sum_((r, c) in S_(x y)) g(r, c)^(Q + 1))/( sum_((r, c) in S_(x y)) g(r, c)^Q)$ Q称为滤波器的阶数,`>0`用于胡椒, `<0`用于盐粒,`=0`变为算数平均,`=-1`变为谐波平均

==== 统计排序

中值 $hat(f) (x , y) =m e d i a n_((r , c) in S_(x y)) {g (r , c)}$
与大小相同的线性平滑(均值)滤波相比，有效地降低某些随机噪声，且模糊度要小得多;对于单极和双极冲激噪声效果好\
最大值 $hat(f)(x, y) = max_((r, c) in S_(x y)) {g (r , c)}$ 发现最亮点;过滤胡椒\
最小值 $hat(f)(x, y) = min_((r, c) in S_(x y)) {g (r , c)}$ 发现最暗点;过滤盐粒\
中点$hat(f)(x, y) = frac(1, 2)  [ max_((r, c) in S_(x y))  {g(r, c) } + min_((r, c) in S_(x y))  {g(r, c) }  ]$统计排序滤波器和平均滤波器;适合处理随机分布的噪声，如高斯噪声和均匀噪声\
修正后的阿尔法均值滤波 $hat(f)(x, y) = frac(1, m n - d) sum_((r, c) in S_(x y)) g_R (r, c)$\
在𝑆邻域内去掉𝑔(r, c)最高灰度值的𝑑/2和最低灰度值的d/2 $g_R (r, c)$代表剩余的$𝑚 𝑛 - 𝑑$个像素.$d=0$变为算数平均;$d=m n-1$变为中值;当 d 取其它值时，适用于包括多种噪声的情况下，例如高斯噪声和椒盐噪声混合的情况。

==== 自适应

用$S_(x y)$的区域内图像的统计特征进行处理


自适应局部降噪\
$g(x,y)$表示噪声图像在点$(x,y)$上的值;$sigma_eta^2$噪声方差 $overline(z)_(S_(x y))$在$S_(x y)$上像素点的局部平均灰度;$sigma_(S_(x y))^2$在$S_(x y)$上像素点的局部方差;假设 $sigma_eta^2 lt.eq sigma_(S_(x y))^2$

$hat(f)(x, y) = g(x, y) - frac(sigma_eta^2, sigma_(S_(x y))^2) [ g(x, y) - overline(z)_(S_(x y)) ]$

自适应中值\
$z_(m i n)$是$S_(x y)$中的最小灰度值;$z_(m a x)$是$S_(x y)$中的最大灰度值;$z_(m e d)$是$S_(x y)$中的灰度值的中值;$z_(x y)$是坐标$(x,y)$处的灰度值;$S_(m a x)$是$S_(x y)$允许的最大尺寸。\
层次 A: 若$z_(m i n) lt z_(m e d) lt z_(m a x)$,则转到层次$B$ 否则，增$S_(x y)$的尺寸，\
若$S_(x y) lt.eq S_(m a x)$,则重复层次 A 否则，输出$z_(m e d)$\
层次 B: 若$z_(m i n) lt z_(x y) lt z_(m a x)$,则输出 $z_(x y)$ 否则，输出$z_(m e d)$\
普通的中值消除噪声的同时导致图像细节明显缺失;自适应中值能够额外保留图像细节

== 频域滤波降低周期噪声

陷波滤波器:阻止或通过事先定义的频率矩形邻域中的频率 $H_upright(N R) (u, nu) = product_(k = 1)^Q H_k (u, nu) H_(-k)(u, nu)$\
$H_k (u,ν)$ 和 $H_(-k)(u,ν)$分别是中心为 $(u_k,ν_k)$ 和 $(-u_k,-ν_k)$ 的高通滤波器传递函数;$D_(k) (u , v) = [(u - M \/ 2 - u_k)^2 + (v - N \/ 2 - v_k)^2]^(1 \/ 2)$;$D_(- k) (u , v) = [(u - M \/ 2 + u_k)^2 + (v - N \/ 2 + v_k)^2]^(1 \/ 2)$\
n阶巴特沃斯陷波带阻(3陷波对) $H_(upright(N R)) (u , nu) = product_(k = 1)^3 [frac(1, 1 + [D_(0 k) \/ D_k (u , nu)]^n)] [frac(1, 1 + [D_(0 k) \/ D_(- k) (u , nu)]^n)]$\
陷波带通滤波器(NR为带阻) $H_upright(N P) (u, nu) = 1 - H_upright(N R) (u, nu)$

存在多个干扰分量时，简单的滤波器传递函数在滤波过程中可能过多地滤除图像信息\
最优陷波:1.分离干扰模式的各个主要贡献;2.从被污染图像中减去该模式的一个可变加权部分\
假设G是被污染图像DFT
1.算出$eta$, $N(u, nu) = H_upright(N P) (u, nu) G(u comma nu)$   $eta(x, y) = F^(-1) {H_upright(N P) (u, nu) G(u, nu)}$  $hat(f)(x, y) = g(x, y) - w(x, y) eta(x, y)$\
2.求可变加权部分$w (x , y) = frac(overline(g dot eta) - overline(g) dot overline(eta), overline(eta^2) - overline(eta)^2)$

== 线性位置不变退化

如果退化模型为线性和位置不变的,则满足Ch5顶部建模的空域,频域表达式.许多退化类型可以近似表示为线性的位置不变过程；而非线性的与位置有关的技术难以求解。
== 估计退化函数
1.观察法:收集图像自身的信息来估计H;
2.试验法:使用与获取退化图像的设备相似的装置;
3.数学建模法:建立退化模型，模型要把引起退化的环境因素考虑在内
== 逆滤波

$hat(F)(u, v) = frac(G(u comma v), H(u comma v))=F(u, v) + frac(N(u comma v), H(u comma v))$;问题:N一般未知,挡H的任何元素为0或者较小时,后面分数项主导了结果;解决方法:限制滤波频率, 从而减少遇到零值的可能性(H(0,0)的值最大).

== 最小均方误差（维纳）滤波
$S_f (u,v)=|F(u,v)|^2$为未退化函数功率； $S_eta ( u, v) = | N( u, v) | ^2$ 为噪声功率谱；

$hat(F)(u, v) = [ frac(1, H(u comma v)) frac(lr(|H(u comma v)|)^2, lr(|H(u comma v)|)^2 + S_eta (u comma v) \/ S_f (u comma v)) ] G(u, v)$ \
假设两个功率谱之比为常数K,有 $hat(F)(u, v) = [ frac(1, H(u comma v)) frac(lr(|H(u comma v)|)^2, lr(|H(u comma v)|)^2 + K) ] G(u, v)$ K通常在复原时调整

// $H(u,v)$为退化传递函数； $H^*(u,v)=H(u,v)$为其复共轭；


信噪比:频域 $"SNR" = (sum _(u = 0)^(M - 1) sum _(nu = 0)^(N - 1) |F(u, nu) |^2 ) / (sum _(u = 0)^(M - 1) sum _(nu = 0)^(N - 1) |N(u, nu) |^2)$ 空域$upright(S N R) = (sum_(x = 0)^(M - 1) sum_(y = 0)^(N - 1) hat(f)(x, y)^2 ) / (sum_(x = 0)^(M - 1) sum_(y = 0)^(N - 1)  [ f(x, y) - hat(f)(x, y)  ]^2)$ 均方误差 $upright(M S E) = frac(1, M N) sum_(x = 0)^(M - 1) sum_(y = 0)^(N - 1) [ f(x, y) - hat(f)(x, y) ]^2$


== 约束最小二乘方滤波

约束$|g - H hat(f)|^2=|eta|^2$ 准则函数最小化$C = sum_(x = 0)^(M - 1) sum_(y = 0)^(N - 1) [ nabla^2 f(x, y) ]^2$\
最佳问题的解$hat(F)(u, v) =  [ frac(H^* (u comma v), |H(u comma v) |^2 + gamma |P(u comma v) |^2)  ] G(u, v)$ 当$gamma$ = 0时,退变成逆滤波\
$P (u, v)$ 为 $p(x, y)$ 的傅里叶变换 $p(x,y)$为拉普拉斯空间卷积核\
估计$gamma$:设$||r||^2 = ||g - H hat(f)||^2$,通过$||upright(bold(r))||^2 = ||eta||^2 plus.minus a$,由于r关于$gamma$单调,$||upright(bold(r))||^2 < ||eta||^2 minus a$增加$gamma$;$||upright(bold(r))||^2 > ||eta||^2 plus a$减少$gamma$\
估计$||eta||^2$:$||eta||^2 = M N [sigma_eta^2 + overline(eta)^2]$ 用方差和均值


== 几何均值滤波

$hat(F)(u, v) = [ frac(H^* (u comma v), lr(|H(u comma v)|)^2) ]^a [ frac(H^* (u comma v), lr(|H(u comma v)|)^2 + beta [ frac(S_eta (u comma v), S_f (u comma v)) ]) ]^(1 - alpha)$\
当 $alpha=0$ 时,滤波器退化为逆滤波器;当 $alpha=0$ 时,滤波器退化为参数维纳滤波器;当 $alpha=0,beta=1$ 时,滤波器退化为标准维纳滤波器;当 $alpha=1/2$ 时,滤波器为几何均值滤波器;当 $beta=1,alpha$ 减到 $1/2$ 以上,它接近逆滤波器,当 $beta=1,alpha$ 减到 $1/2$ 以下,它接近维纳滤波器;当 $beta=1,alpha=1/2$ 时,它被称为谱均衡滤波器;
