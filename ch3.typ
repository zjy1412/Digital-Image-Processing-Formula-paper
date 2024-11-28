#import "@preview/mitex:0.2.4": *

#heading[Chapter 3]

= 基本的灰度变换

反转变换$S=L-1-r$

对数变换$S=c log(1+r)$

幂律(伽马)变换$s=c r^gamma$

分段线性变换:
1.对比度拉伸,2.灰度级分层,3.比特平面分层

= 直方图处理

f的非归一化直方图$h(r_k) = n_k, quad k = 0, 1, 2, dots.c, L - 1$
$n_k$是f中灰度为$r_k$的像素的数量

f的归一化直方图$p(r_k) = frac(h(r_k), M N) = frac(n_k, M N)$

== 均衡化
使图像产生灰度级丰富且动态范围大的图像灰度

$s= T(r) , 0 lt.eq r lt.eq L - 1$

假设函数$T(r)$满足下列条件：

a) 在$0 lt.eq  r lt.eq  L-1$区间内，$T(r)$是严格单调递增

b)  当$0 lt.eq  r lt.eq  L-1$时，$0 lt.eq  T(r) lt.eq  L-1$。

变换前后的pdf为$p_r(r),p_s(s)$

若$T(r)$严格单增且可微，有$p_s (s) = p_r (r) lr(|frac(d r, d s)|)$

== 匹配(规定化)
输入原始图$p_r(r)$，目标图像$p_z(z)$，求输入𝑟到输出𝑧的变换公式

连续：

$T(r) =(L - 1) integral_0^r p_r (w) dif w$

$G(z) =(L - 1) integral_0^z p_z (nu) dif nu$

$z = G^(-1)(s) = G^(-1) [ T(r) ]$

离散：

$T(r_k) =(L - 1) sum_(j = 0)^upright(k) p_r (r_j), quad k = 0, 1, 2, dots.c, L - 1$

$G(z_q) =(L - 1) sum_(i = 0)^q p_z (z_i)$

$z_q = G^(-1)(s_k)$

== 局部处理
图像/图像块(全局/局部)的统计距计算

设$p(r_i) = frac(n_i, n), quad i = 0, 1, 2, . . ., L - 1$，则灰度级$r$相对于均值m的$n$阶中心矩为：

$mu_n (r) = sum_(i = 0)^(L - 1)(r_i - m)^n p(r_i)$

其中，m是r的均值。

$m = sum_(i = 0)^(L - 1) r_i p(r_i)$

当 n=2为方差：

$sigma^2 = mu_2 (r) = sum_(i = 0)^(L - 1)(r_i - m)^2 p(r_i)$

= 空间滤波

== 线性空间滤波

对于大小为m×n的核，假设m=2a+1和n=2b+1,其中a和b是非负整数。

$g(x, y) = sum_(s = - a)^a sum_(t = - b)^b w(s, t) f(x + s, y + t)$

== 空间相关与卷积
//有一个空心的星星叫相关，这里没笔记进来
一维核旋转 180°相当于这个核绕相对于其轴进行翻转。
在二维情况下，旋转180°等效于核关于其一个轴翻转，然后关于另一个轴翻转。+

相关$(w star.stroked f)(x, y) = sum_(s = - a)^a sum_(t = - b)^b w(s, t) f(x + s, y + t)$

大小为$m times n$的核$w$与图像$f(x,y)$的卷积$(w star f)(x,y)$ 定义为


 $(w star f)(x, y) = sum_(s = - a)^a sum_(t = - b)^b w(s, t) f(x - s, y - t)$  等同于将核旋转180度后再做相关

 满足交换，结合，分配律。

 == 可分离滤波器核
大小为 𝑚 x n 的滤波核可表示为两个向量的积 $w = w_1 w_2^T = w_1 star w_2$

一个列向量和一个行向量的积等于这两个向量的二维卷积

用可分离核执行卷积运算相对于使用不可分离核执行卷积运算的计算优势定义为$C = frac(M N m n, M N(m + n)) = frac(m n, m + n)$

可分离核条件：核 𝑤 的秩为1

分离方法： 在核中找到任何一个非零元素$a$,值为$E$；提取$a$所在的列与行，形成列向量$c$和$r;$ ；$w_{1}= c$ , $w_{2}^{T}= r/ E$

= 平滑（低通）空间滤波器
降低相邻灰度的急剧过度，以减少无关细节（噪声）；核越大越模糊;平滑通过对相邻像素求和（积分）实现.

$g(x, y) = frac(sum_(s = - a t = - b)^a sum_(-b)^b w(s comma t) f(x + s comma y + t), sum_(s = - a t = - b)^a sum_(-b)^b w(s comma t))$

高斯核函数

$w(s, t) = G(s, t) = K e^(-frac(s^2 + t^2, 2 sigma^2))$

= 锐化（高通）空间滤波器

凸显灰度的过渡部分，以增强图像中的细节。锐化则用相邻像素差分（导数）来实现.

拉普拉斯算子

连续：$nabla^2 f = frac(diff^2 f, diff x^2) + frac(diff^2 f, diff y^2)$

离散：$nabla^2 f = [ f(x + 1, y) + f(x - 1, y) + f(x, y + 1) + f(x, y - 1) ] - 4 f(x, y)$

= 低通、高通、带阻和带通滤波器

#image("./img/lbq.png")

单位冲激中心和滤波器核中心重合

低通 $l p(x comma y)$，高通 $h p(x comma y) = delta(x comma y) - l p(x comma y)$

带阻 $b r(x comma y) = l p_1 (x comma y) + h p_2 (x comma y), = l p_1 (x comma y) + [ delta(x comma y) - h p_2 (x comma y) ]$，带通 $b p(x comma y) = delta(x comma y) - b r(x comma y) = delta(x comma y) - [ l p_1 (x comma y) + [ delta(x comma y) - l p_2 (x comma y) ] ]$