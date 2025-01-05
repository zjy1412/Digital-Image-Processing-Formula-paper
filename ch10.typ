
#import "@preview/mitex:0.2.4": *
#import "@preview/tablex:0.0.6": tablex, hlinex
#import "@preview/tablem:0.1.0": tablem

#heading[第十章：图像分割]

== 背景知识

*差分*: 前向 $frac(partial f (x), partial x) = f (x + 1) - f (x)$  后向 $frac(partial f (x), partial x) = f (x) - f (x - 1)$  中值 $frac(partial f (x), partial x) = frac(f (x + 1) - f (x - 1), 2)$  二阶 $frac(partial^2 f (x), partial x^2) = f (x + 1) - 2 f (x) + f (x - 1)$\
*一阶导*a）在恒定灰度区域为零；b）在灰度台阶和斜坡开始处不为零；c）在灰度斜坡上不为零\
*二阶导*a）在恒定灰度区域为零；b）在灰度台阶和斜坡开始处不为零；c）在灰度斜坡上为零\
(1)一阶导产生粗边缘；(2)二阶导对精细细节(如细线、孤立点和噪声)有更强的响应；(3)二阶导在灰度斜坡和台阶过渡处会产生双边缘响应；(4)二阶导的符号可用于确定边缘的过渡是从亮到暗(正)还是从暗到亮(负)。\
滤波器在核的中心点的响应是$Z  = sum_(k = 1)^9 w_k z_k$ w 1,2,3为核第一行,以此类推


== 孤立点检测

*拉普拉斯*  $nabla^2 f (x , y) = frac(partial^2 f, partial x^2) + frac(partial^2 f, partial y^2)  = f (x + 1 , y) + f (x - 1 , y) + f (x , y + 1) + f (x , y - 1) - 4 f (x , y)$

超过阈值T的标记 $g (x , y) = cases(delim: "{", 1  "," lr(|Z (x , y)|) > T, 0 "," upright("其他") & )$ $nabla^2 f=Z$

== 线检测
拉普拉斯核是各向同性的、特殊方向线检测通常采用如下4种*模板*\
// #image("./img/zxjc.png",height: 5%)
$"水平："
mat(
  -1, -1, -1;
   2,  2,  2;
  -1, -1, -1;
)

"+45°："
mat(
   2, -1, -1;
  -1,  2, -1;
  -1, -1,  2;
)
\
"垂直："
mat(
  -1,  2, -1;
  -1,  2, -1;
  -1,  2, -1;
)

"-45°："
mat(
  -1, -1,  2;
  -1,  2, -1;
   2, -1, -1;
)$

如果上述4种模板产生的响应分别为：Ri，如果|Ri(x,y)|>|Rj(x,y)|,并且i≠j，则认为此点与模板i方向的线有关。

验证：\
$"水平："
mat(
  b, b, b;
  a, a, a;
  a, a, a;
)

"垂直："
mat(
  b, a, a;
  b, a, a;
  b, a, a;
)

"+45°："
mat(
  b, b, a;
  b, a, a;
  b, a, a;
)

"-45°："
mat(
  a, a, a;
  b, a, a;
  b, b, a;
)$

== 边缘检测

*梯度* $nabla f (x , y) equiv upright(g r a d) [f (x , y)] equiv mat(delim: "[", g_x (x , y); g_y (x , y)) = mat(delim: "[", frac(partial f (x , y), partial x); frac(partial f (x , y), partial y))$\
*梯度幅度*(L2) $M (x , y) = ||nabla f (x , y)|| = sqrt(g_x^2 (x , y) + g_y^2 (x , y))$\
*绝对值来近似梯度幅度*(L1)：$M (x , y) approx lr(|g_x|) + lr(|g_y|)$\
*梯度方向*(垂直边缘) $alpha (x , y) = arctan [frac(g_y (x , y), g_x (x , y))]$

$mat(
  z_1, z_2, z_3;
  z_4, z_5, z_6;
  z_7, z_8, z_9
)$

*Robert算子*   $g_x = frac(partial f, partial x) = (z_9 - z_5)$     $g_y = frac(partial f, partial y) = (z_8 - z_6)$\
*Prewitt算子*   $g_x = frac(partial f, partial x) = (z_7 + z_8 + z_9) - (z_1 + z_2 + z_3)$     $g_y = frac(partial f, partial y) = (z_3 + z_6 + z_9) - (z_1 + z_4 + z_7)$\
*Sobel 算子*  $g_x = frac(partial f, partial x) = (z_7 + 2 z_8 + z_9) - (z_1 + 2 z_2 + z_3)$     $g_y = frac(partial f, partial y) = (z_3 + 2 z_6 + z_9) - (z_1 + 2 z_4 + z_7)$\
与Sobel相比，Prewitt更简单，但Sobel能更好抑制（平滑）噪声。\
*Kirsch罗盘核*：用于检测8个罗盘方向的边缘幅度和方向\
二维高斯函数， $G (x , y) = upright(e)^(- frac(x^2 + y^2, 2 sigma^2))$ ;
*高斯拉普拉斯(LoG)函数*:  $nabla^2 G (x , y) = (frac(x^2 + y^2 - 2 sigma^2, sigma^4)) upright(e)^(- frac(x^2 + y^2, 2 sigma^2))$\
*Marr-Hildreth算法*  $g (x , y) = [nabla^2 G (x , y)] star.filled f (x , y) = nabla^2 [G (x , y) star.op f (x , y)]$  寻找g(x,y)的过零点来确定f(x,y)中边缘的位置\
高斯差分(DoG)来近似式的LoG函数  $D_G (x , y) = frac(1, 2 pi sigma_1^2) upright(e)^(- frac(x^2 + y^2, 2 sigma_1^2)) - frac(1, 2 pi sigma_2^2) upright(e)^(- frac(x^2 + y^2, 2 sigma_2^2))$\
*Canny 坎尼* 1.用一个高斯滤波器平滑输入图$f_s (x , y) = G (x , y) star.op f (x , y)$ 2.计算梯度幅值图像$M_S$(L2)和角度图像$alpha (x , y) = tan^(- 1) [frac(g_y (x , y), g_x (x , y))]$ 3.对梯度幅值图像应用非极大值抑制进行细化边缘 4.用双阈值处理和连通性分析来检测与连接边缘\
非极大值抑制 寻找最接近α方向dk,修改值$g_N (x , y) = cases( 0 & M_s \( upright("x,y)小于d")_k upright("方向上的两个邻点值"), M_s (x , y) & upright("否则") & ) $\
双阈值化处理$g_(N H) (x , y) = g_N (x , y) gt.eq T_H $强边缘(存在间断) $g_(N L) (x , y) = g_N (x , y) gt.eq T_L $强边缘+弱边缘 $g_(N L) (x , y) = g_(N L) (x , y) - g_(N H) (x , y) $ 弱边缘

== 连接边缘点

满足条件则连接 $mat(delim: "|", M (s , t) - M (x , y)) lt.eq E$ $mat(delim: "|", alpha (s , t) - alpha (x , y)) lt.eq A$

*霍夫变换*  $rho (theta) = x upright(c o s) theta + y upright(s i n) theta = R c o s (theta - phi.alt) = sqrt(x^2 + y^2) upright(c o s) (theta - arctan x / y)$

== 阈值处理

*单阈值* $g (x , y) = cases(delim: "{", 1 " " f (x , y) >= T,0" " f (x , y) lt.eq T & )$ 

*双阈值* $g (x , y) = cases(delim: "{", a ", " f (x , y) > T_2, b "," T_1 < f (x , y) lt.eq T_2, c "," f (x , y) lt.eq T_1 & )$

*基本的全局阈值化*
1. 为全局阈值$T$选择一个初始估计值。\
2. 在 $g (x , y) = cases(delim: "{", 1 "," f (x , y) > T, 0 "," f (x , y) lt.eq T & )$中用$T$分割图像。这将产生两组像素：由灰度值大于$T$的所有像素组成的$G_1$,由所有小于等于$T$的像素组成的$G_2$\
3. 对 $G_1$ 和 $G_2$中的像素分别计算平均灰度值(均值)$m_1$和 $m_2$\
4. 在$m_1$和 $m_2$之间计算一个新的阈值： $T=(m_1+m_2)/2$\
5. 重复步骤 2 到步骤 4,直到连续迭代中的两个$T$值间的差小于某个预定义的值$Delta T$为止。

*`OSTU`方法*:\
// $n_i$ 表示灰度级i的像素数, $M*N= sum_(i=0)^(L-1) n_i;p_i=n_i/(M N);sum_(i = 0)^(L - 1) p_i = 1 , quad p_i gt.eq 0$\
// 分为两类 $c_1,c_2$  累计概率 $P_1 (k) = sum_(i = 0)^k p_i;P_2 (k) = sum_(i = k + 1)^(L - 1) p_i = 1 - P_1 (k)$ \
// 平均灰度  $m_1 (k) = frac(1, P_1 (k)) sum_(i = 0)^k i p_i;m_2 (k) = frac(1, P_2 (k)) sum_(i = k + 1)^(L - 1) i p_i$ \
// k级累计灰度 $m (k) = sum_(i = 0)^k i p_i$  整个图像平均灰度  $m_G = sum_(i = 0)^(L - 1) i p_i$\
// 约束条件 $P_1 m_1 + P_2 m_2 = m_G;P_1 + P_2 = 1$\
// 全局方差  $sigma_G^2 = sum_(i = 0)^(L - 1) (i - m_G)^2 p_i$ \
// 类间方差  $sigma_B^2 = P_1 (m_1 - m_G)^2 + P_2 (m_2 - m_G)^2 = P_1 P_2 (m_1 - m_2)^2 = frac((m_G P_1 - m)^2, P_1 (1 - P_1))$ \
// (选择k最大化 $sigma_B^2$ )\
// 扩展到多阈值$sigma_B^2 = sum_(k = 1)^K P_k (m_k - m_G)^2$ ; $sigma_B^2 (k_1^(\*) , k_2^(\*) , dots.h.c , k_(K - 1)^(\*)) = max_(0 < k_1 < k_2 < dots.h.c k_K < L - 1) sigma_B^2 (k_1 , k_2 , dots.h.c , k_(K - 1))$


通过最大化类间方差来优化全局阈值：
$sigma_B^2(k) = frac([m_G P_1(k) - m(k)]^2, P_1(k)[1 - P_1(k)])$

其中：
$m_G$ 是图像的全局均值：
  $m_G = sum_(i=0)^(L-1) i dot p_i$\
$m(k)$ 是灰度级 $k$ 的累积均值：
  $m(k) = sum_(i=0)^k i dot p_i$

*类间方差*：
将图像分为两类：前景（$C_1$）和背景（$C_2$），阈值为 $k$\
计算两类的概率：
  $P_1(k) = sum_(i=0)^k p_i, quad P_2(k) = sum_(i=k+1)^(L-1) p_i$

计算两类的均值：
  $m_1(k) = frac(sum_(i=0)^k i dot p_i, P_1(k)), quad m_2(k) = frac(sum_(i=k+1)^(L-1) i dot p_i, P_2(k))$\
计算类间方差：
  $sigma_B^2(k) = P_1(k) dot P_2(k) dot [m_1(k) - m_2(k)]^2$

最佳阈值：遍历所有可能的阈值 $k$（$0 <= k <= L-1$），找到使类间方差 $sigma_B^2(k)$ 最大的 $k$：
$k^* = "arg max"_(0 <= k <= L-1) sigma_B^2(k)$

*步骤*：计算图像的灰度直方图,遍历所有可能的阈值 $k$，计算每个 $k$ 对应的类间方差 $sigma_B^2(k)$,找到使 $sigma_B^2(k)$ 最大的阈值 $k^*$,使用 $k^*$ 对图像进行二值化处理


*优点*：
  *自动选择阈值*：无需手动设置阈值，适合处理大量图像;
  *适用于双峰直方图*：对前景和背景对比明显的图像效果较好;
  *计算简单*：基于直方图统计，计算效率高

*缺点*：
  *对噪声敏感*：如果图像噪声较多，直方图可能不再是双峰分布，导致阈值选择不准确;
  *仅适用于全局阈值*：对于光照不均匀的图像，Otsu 方法可能无法得到理想的分割结果


//P554
== 区域生长 分离 聚合

*区域生长*
//p565
1. *初始种子区域*：从种子数组S(x,y)中找到所有连通分量，并将这些区域标记为1，其他位置标记为0。\
2. *条件筛选*：根据谓词Q对图像f(x,y)进行筛选，形成新的图像f，其中满足条件的像素标记为1，否则为0。\
3. *区域扩展*：将所有在图像f中8连通到种子点的1值点添加到S中，形成新的图像g。\
4. *连通区域标记*：用不同的标签标记图像g中的每个连通分量，得到最终的区域生长分割结果。

*优点*：
可以处理复杂的图像结构。
适合处理具有多尺度特征的图像。

*缺点*：
计算复杂度较高。
对谓词逻辑的设计要求较高。

*分离聚合*
//p567
令R表示整个图像区域，Q是针对区域的一个逻辑谓词比如\
$Q = cases(delim: "{", upright(t r u e) " " sigma > alpha and 0 < m < b, upright(f a l s e) " "upright(o t h e r w i s e) & )$\
1把满足Q(Ri)=FALSE的任何Ri区域分离为四个不相交的子象限区域；\
2无法进一步分离时，聚合满足谓词逻辑$Q(R_j union R_k) = "TRUE"$的任意两个邻接区域Rj和Rk;\
3在无法进一步聚合时停止。
#image("./img/分离聚合.png",height: 8%)
== 分水岭变换

//P585
1. 梯度图像：算法使用图像的梯度图像 $g(x,y)$，其中包含多个区域极小值 $M_{1}, M_{2},  M_{g}$。这些极小值对应于图像中的局部低谷。\
2. 汇水盆地：每个区域极小值 $M_{i}$ 都有一个与之相关联的汇水盆地 $C(M_i)$，这些汇水盆地中的点形成一个连通分量。\
3. 淹没过程：算法通过模拟水位从最小值 $min$ 逐渐上升到最大值 $max$ 的过程来分割图像。在每个水位 $n$，集合 $T[n]$ 包含所有灰度值小于 $n$ 的点。\
4. 二值图像：在每个水位 $n$，$T[n]$ 可以被视为一幅二值图像，其中黑点表示位于平面 $g(x,y) = n$ 下方的点。\
5. 汇水盆地分割：随着水位上升，算法通过比较当前水位 $n$ 的连通分量与前一水位 $n-1$ 的汇水盆地，来确定是否需要构建水坝以防止不同汇水盆地的水流溢出。\
6. 水坝构建：当水位上升到某个点时，如果发现有多个汇水盆地的水流可能溢出，算法会在这些汇水盆地之间构建水坝（即分割线），以阻止水流混合。\

*优点*：
能够生成闭合的区域边界;
适合处理具有复杂形状的目标。

*缺点*:受噪声影响大;容易过度分割

== 空间域技术

累积差值图像*ADI*主要有三种类型：

*绝对ADI*：检测任何变化，不考虑变化的方向。

$d_(i j)^("abs")(x,y) = cases(
  1 "if " |f(x,y,t_i) - f(x,y,t_j)| > T,
  0 "otherwise"
)$

*正ADI*：只检测正向变化（亮度增加）,适用于检测出现的物体或光照增强区域。

$d_(i j)^("pos")(x,y) = cases(
  1 "if " f(x,y,t_i) - f(x,y,t_j) > T,
  0 "otherwise"
)$

*负ADI*：只检测负向变化（亮度减少）,适用于检测消失的物体或阴影区域。。

$d_(i j)^("neg")(x,y) = cases(
  1 "if " f(x,y,t_j) - f(x,y,t_i) > T,
  0 "otherwise"
)$
