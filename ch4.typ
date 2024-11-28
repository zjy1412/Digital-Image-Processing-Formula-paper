#import "@preview/mitex:0.2.4": *

#heading[Chapter 4]

= 采样

冲激串采样 $s_(Delta T)(t) = sum_(n = - infinity)^infinity sigma("x-n" Delta T)$

对连续函数采样 $tilde(f)(t) = f(t) s_(Delta T)(t) = sum_(n = - infinity)^(n = infinity) f(t) sigma(t - n Delta T)$ 每个点是有长度的冲激，需要再积分得到具体数值 $f_k = integral_(-infinity)^infinity f(t) delta(t - k Delta T) d t = f(k Delta T)$

= 单变量的离散傅里叶变换

DFT：$F(u) = sum_(x = 0)^(M - 1) f(x) e^(-j 2 pi u x \/ M) quad u = 0, 1, dots.c, M - 1$

IDFT：$f(x) = frac(1, M) sum_(x = 0)^(M - 1) F(u) e^(j 2 pi u x \/ M) quad x = 0, 1, dots.c, M - 1$

= 二变量函数的傅里叶变换

二维傅里叶变换是一维情形向两个方向的简单扩展

$F(u, v) = integral_(-infinity)^(+infinity) integral_(-infinity)^(+infinity) f(t, z) e^(-j 2 pi(u t + v z)) d t d z$

$\ f(t, z) = integral_(-infinity)^(+infinity) integral_(-infinity)^(+infinity) F(u, v) e^(j 2 pi(mu t + v z)) d u d v$

采样：$tilde(f)(t, z) = f(t, z) s_(Delta T Delta Z)(t, z) = sum_(m = - infinity)^(m = infinity) sum_(n = - infinity)^(n = infinity) f(t, z) sigma(t - m Delta T, z - n Delta Z)$


DTF：$F(u, v) = sum_(x = 0)^(M - 1) sum_(y = 0)^(N - 1) f(x, y) e^(-j 2 pi(u x \/ M + v y \/ N))$

IDFT：$f(x, y) = frac(1, M N) sum_(u = 0)^(M - 1 N - 1) F(u, v) e^(j 2 pi(u x \/ M + v y \/ N))$

== 二维DFT和IDFT性质
//表4.3
谱 $lr(|F(u comma nu)|) = [ R^2 (u, nu) + I^2 (u, nu) ]^(1 \/ 2), quad R = upright(R e a l)(F), I = upright(I m a g)(F)$ 相 角$phi.alt(u, v) = arctan  [ frac(I(u comma v), R(u comma v))  ]$

极坐标 $F(u comma nu) = lr(|F(u comma nu)|) e^(j phi.alt(u, v)) $

周期性(k为整数) $F(u, v) = F(u + k_1 M, v) = F(u, v + k_2 N) = F(u + k_1, v + k_2 N)$ \ $f(x, y) = f(x + k_1 M, y) = f(x, y + k_2 N) = f(x + k_1 M, y + k_2 N)$

卷积 $(f star h)(x, y) = sum_(m = 0)^(M - 1) sum_(n = 0)^(N - 1) f(m, n) h(x - m, y - n)$

相关 $(f star.stroked h)(x, y) = sum_(m = 0)^(M - 1) sum_(n = 0)^(N - 1) f^* (m, n) h(x + m, y + n)$

可分离性

使用DFT算法求 IDFT $M N f^* (x, y) = sum_(u = 0)^(M - 1) sum_(v = 0)^(N - 1) F^* (u, v) upright(e)^(-upright(j) 2 pi(u x \/ M + nu y \/ N))$ 结果取
复共轭并除以MN就可得到反变换
//表4.4

平移性 $f(x, y) upright(e)^(upright(j) 2 pi(u_0 x \/ M + v_0 y \/ N)) arrow.l.r.double F(u - u_0, v - v_0) $

$f(x - x_0, y - y_0) arrow.l.r.double F(u, v) upright(e)^(-upright(j) 2 pi(u x_0 \/ M + nu y_0 \/ N))$

= 频率域滤波
(1)对图像f(x,y)进行零填充(长宽均变为两倍，变为$P times Q$

(2) 频谱中心化：用$(-1)^x+y$乘以填充后的图像；

(3) 计算(2)结果的DFT，即$F(u,v);$

(4) 用滤波器函数$H(u,v)$乘以$F( u, v) :cal(G)(u, v) = H(u, v) F(u, v)$

(5)计算(4)中结果的IDFT，$g(x, y) = frak(J)^(-1) G(u, v)$

—理论值为实数，计算误差会导致寄生复成分；

 (6)得到(5)结果中的实部；

(7) 用$(-1)^x+y$乘以(6)中的结果；

(8)提取(7)中的左上角(与输入图像同大小)。

// = 低通频率域滤波器平滑图像

// = 高通滤波器锐化图像

// = 选择性滤波

= 快速傅里叶变换

基本思想：利用傅里叶变换基底性质，将$M$个数据的傅里叶变换转为2组$M/2$个数据的傅里叶变换，此时计算量从 $M^{2}$ 降低为 $M^{2}/2$

$F(u) = sum_(x = 0)^(K - 1) f(2 x) W_(2 K)^(u(2 x)) + sum_(x = 0)^(K - 1) f(2 x + 1) W_(2 K)^(u(2 x + 1))$ 偶数部分+奇数部分

$W_M = e^(-j 2 pi \/ upright(M)), quad W_(2 K) ""^(2 u x) = W_k ""^(u x)$

$F_(e v e n)(u) = sum_(x = 0)^(K - 1) f(2 x) W_K^(u x) quad F_(o d d)(u) = sum_(x = 0)^(K - 1) f(2 x + 1) W_K^(u x)$

$F(u) = F_(e v e n)(u) + F_(o d d)(u) W_(2 K)^u \ F(u + K) = F_(e v e n)(u) - F_(o d d)(u) W_(2 K)^u$