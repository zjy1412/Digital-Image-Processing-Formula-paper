
#import "@preview/mitex:0.2.4": *
#import "@preview/tablex:0.0.6": tablex, hlinex
#import "@preview/tablem:0.1.0": tablem

#heading[第十一章 特征提取]

== 边界预处理

*跟踪二值图像中1值区域R的边界算法*:从左上角标记为1的点开始,按顺时针找8邻域中下一个1,然后继续从下一个1开始执行算法,直到回到起点

弗里曼链码 基于线段的4连通或8连通，使用一种编号方案对每个线段的方向进行编码。用于表示由顺次连接的具有指定长度和方向的直线段组成的边界。

#image("./img/链码的种类.png",height: 5%)

从起点开始,往哪个箭头方向走就标记哪个数字,直到回到起点;形状和链码是一一对应的;改变起点会让链码循环位移

*归一化*:循环位移后数字最小的链码

*差分*:相邻的做差,i为当前a[i+1] - a[i],最后加一个起点-终点;之后对4或者8取mod;$D = [(C_2 - C_1) mod m, (C_3 - C_2) mod m,..., (C_1 - C_n) mod m]$

*形状数*(差分+归一化) 将码按一个方向循环，使其构成的自然数最小序列;形状数的阶݊n定义为形状数中的数字的数量。

*斜率链码* 在曲线周围放置*等长*的直线段得到，其中的直线段的端点与曲线相接,直线段的斜率记录链码

*最小周长多边形*:使用尽量少的线段来得到给定边界的基本形状;abc三点行列式,逆时针为正,顺时针为负,共线为0;先找所有凸起和凹陷点,然后凹顶点需要镜像;
//看ppt吧

*标记图*:把*质心到边界的距离*画成*角度的函数*。将原始的二维边界简化为一维函数表示。

//骨架、中轴和距离变换

== 边界特征描述子
边界B的直径 $upright(d i a m e t e r (B) = m a x_(i , j) [D (p i , p j)])$ 式中D为距离测度，pi和pj是边界上的点。

长度$upright(l e n g t h)_(upright(m)) = [(upright(x)_2 - upright(x)_1)^2 + (upright(y)_2 - upright(y)_1)^2]^(1 \/ 2)$方向$upright(a n g l e)_(upright(m)) = arctan [frac(y_2 - y_1, x_2 - x_1)]$

曲线的曲折度定义为斜率链码链元素的绝对值之和:$tau = sum_(i = 1)^n lr(|alpha_i|)$,式中的n是斜率链码中的元素数量,$lr(|alpha_i|)$是链码中元素的值(斜率变化)。

*傅里叶描述子*:二维边界可以被视为复数从而一维化表示为s(k) = x(k) + jy(k)\
边界的傅里叶描述子$a (u) = sum_(k = 0)^(K - 1) s (k) e^(- j 2 pi u k \/ K)$\
$s (k) = 1 / K sum_(u = 0)^(K - 1) a (u) e^(j 2 pi u k \/ K)$; 只采用前P个系数$hat(s) (k) = 1 / K sum_(u = 0)^(P - 1) a (u) e^(j 2 pi u k \/ K)$

*统计矩*:
1.把g(r)的幅度视为离散随机变量z，形成幅度直方图p(zi),A是灰度值最大的区间数量。将p归一化，使其元素之和等于1，那么p(zi)是灰度值zi的概率估计;\
z关于其平均值的n阶矩为 $mu_n (z) = sum_(i = 0)^(A - 1) (z_i - m)^n p (z_i)$ \
m是z的均值，$μ_2$是z的方差，只需要前几个矩来区分明显不同形状的标记图。

2.将g(r)面积归一化为1，并视为直方图，g(ri)可被视为值ri出现的概率。r是随机变量K是边界上的点数， $μ_n(r)$ 与标记图g(r)形状直接相关\
矩是 $ mu_n (r) = sum_(i = 0)^(K - 1) (r_i - m)^n g (r_i)$ 其中$m = sum_(i = 0)^(K - 1) r_i g (r_i)$



== 区域特征描述子

面积A为区域中的像素数量。周长p是其边界的长度;紧致度（无量纲） $p^2/A$ ;圆度（无量纲） $(4 pi A) / p^2$ ; 有效直径  $d_e=2sqrt(A / pi)$

偏心率 标准椭圆  $upright("eccentricity") = c / a = sqrt(a^2 - b^2) / a = sqrt(1 - (b \/ a)^2) quad a gt.eq b$  \
任意方向椭圆(协方差矩阵的特征值)  $upright("eccentricity") = sqrt(1 - (lambda_2 \/ lambda_1)^2) quad lambda_1 gt.eq lambda_2$

拓扑描述子:孔洞的数量H和连通分量C的数量,定义欧拉数 E = C - H\
顶点数表示为V，将边数表示为 Q，将面数表示为F时，V-Q+F=E

纹理:统计方法(和统计矩1类似),光滑度 $R = 1 - frac(1, 1 + sigma^2 (z))$   $sigma^2$ 是方差 $μ_2$ ;一致性 $U = sum_(i = 0)^(L - 1) p^2 (z_i)$  熵 $p = - sum_(i = 0)^(L - 1) p (z_i) log_2 p (z_i)$

共生矩阵中的元素$g_(i j)$值定义为图像f中灰度($z_i$,$z_j$)的像素对出现的次数;像素对不一定是左右的,可以跨格子;从$z_i$到$z_j$

共生矩阵（$K times K$）的描述子, $p_i j$ 等于G中第i,j项处于G的元素之和

最大概率:$max_{i,j} p_{i j}$度量 G 的最强响应，值域是 [0,1]\

相关:$frac(sum_(i = 1)^K sum_(j = 1)^K (i - m_r)(j - m_c) p_(i j), sigma_r sigma_c) quad sigma_r eq.not 0, sigma_c eq.not 0$一个像素在整个图像上与其相邻像素有多相关的测度，值域是 [-1,1]。-1 对应完全负相关，1 对应完全正相关。标准差为 0 时，该测度无定义 \
对比度: $sum_(i = 1)^K sum_(j = 1)^K (i - j)^2 p_(i j)}$ 一个像素在整个图像上与其相邻像素之间的灰度对比度的测度，值域是从 0 到 $(K-1)^2$ \
均匀性（也称能量）:  $sum_(i = 1)^K sum_(j = 1)^K p_(i j)^2$ 均匀性的一个测度，值域为 [0,1]，恒定图像的均匀性为 1\
同质性 $sum_(i = 1)^K sum_(j = 1)^K frac(p_(i j), 1 +|i - j|)$ G 中对角分布的元素的空间接近度的测度，值域为 [0,1]。当 G 是对角阵时，同质性达到最大值\
熵 $-sum_(i = 1)^K sum_(j = 1)^K p_(i j) log_2 p_(i j)$ G 中元素的随机性的测度。当所有 $p_{i j}$  均匀分布时，熵取最大值，因此最大值为 $2 log_2 K$


极坐标下的频谱函数 $S (r) = sum_(theta = 0)^pi S_theta (r) quad S (theta) = sum_(r = 1)^(R_0) S_r (theta)$


矩不变量:大小为MxN ܰ的数字图像f(x,y)的二维(p+q)阶矩为 $m_(p q) = sum_(x = 0)^(M - 1) sum_(y = 0)^(N - 1) x^p y^q f (x , y)$ ;\
(p+q)阶中心矩为 $mu_(p q) = sum_(x = 0)^(M - 1) sum_(y = 0)^(N - 1) (x - overline(x))^p (y - overline(y))^q f (x , y)$  $overline(x) = m_10 / m_00 , quad overline(y) = m_01 / m_00$


归一化(p+q)阶中心矩为 $eta_(p q) = mu_(p q) / mu_(0 0)^((p + q) \/ 2 + 1)$


== 主成分描述子

x是n维列向量,总体平均向量$m_x=E(x)$,向量总体的协方差矩阵(nxn)$C_x=E{(x-m_x)(x-m_x)^T}$

霍特林变换:令A是一个矩阵，这个矩阵的各行由Cx的特征向量构成;$y=A(x-m_x)$

可以证明： $m_y = E { y } = 0$\
$y$ 的协方差矩阵：$C_y = A C_x A^T$ $bold(C)_y = mat(delim: "[", lambda_1, , , 0; #none, lambda_2, , , ; #none, , dots.down, , ; 0, , , lambda_n)$对角阵对角元。

可通过 $y$ 恢复 $x$ ：$x = A^(- 1) y + m_x = A^T y + m_x$\
近似恢复 $x$ ：$hat(x) = A_k^T y + m_x$\ 代表 $k$ 个最大特征值的 $k$ 个特征向量形成的矩阵。\
恢复误差：
$e_(m s) = sum_(j = 1)^n lambda_j - sum_(j = 1)^k lambda_j = sum_(j = k + 1)^n lambda_j$